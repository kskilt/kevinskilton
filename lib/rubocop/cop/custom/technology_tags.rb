require "yaml"

module RuboCop
  module Cop
    module Custom
      class TechnologyTags < Base
        MSG = 'Technology tag `%<tag>s` is not registered in config/technology_pills.yml.'

        def on_block(node)
          send_node, _args_node, body_node = *node
          return unless send_node.method?(:technology_tags)

          inspect_tags_in_array(body_node)
        end

        def on_send(node)
          return unless node.method?(:technology_tags)

          first_arg = node.arguments.first
          inspect_tags_in_array(first_arg) if first_arg&.array_type?
        end

        private

        def inspect_tags_in_array(node)
          return unless node&.array_type?

          node.values.each do |element|
            tag = literal_tag(element)
            next if tag.nil? || allowed_tags.include?(tag)

            add_offense(element, message: format(MSG, tag: tag))
          end
        end

        def literal_tag(node)
          return node.value if node.str_type? || node.sym_type?
        end

        def allowed_tags
          @allowed_tags ||= YAML.load_file(configuration_file_path).keys.map(&:to_s)
        end

        def configuration_file_path
          File.expand_path("../../../../config/technology_pills.yml", __dir__)
        end
      end
    end
  end
end
