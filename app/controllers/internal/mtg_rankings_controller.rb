module Internal
  class MtgRankingsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: :create

    before_action :authenticate_ingest_token!

    def create
      decks = params_for_decks

      if decks.blank? || decks.any? { |deck| deck.nil? }
        return render json: { error: "malformed deck payload" }, status: :unprocessable_content
      end

      ActiveRecord::Base.transaction do
        decks.each do |deck|
          MtgDeck
            .find_or_initialize_by(archetype_name: deck[:archetype_name])
            .update!(win_rate: deck[:win_rate], popularity: deck[:popularity], scraped_at: Time.current)
        end
      end

      head :ok
    rescue ActiveRecord::RecordInvalid
      render json: { error: "malformed deck payload" }, status: :unprocessable_content
    end

    private

    def authenticate_ingest_token!
      provided_token = request.headers["Authorization"].to_s.delete_prefix("Bearer ")
      expected_token = ENV["MTG_INGEST_TOKEN"].to_s

      return head :unauthorized if expected_token.blank?
      head :unauthorized unless ActiveSupport::SecurityUtils.secure_compare(provided_token, expected_token)
    end

    def params_for_decks
      raw_decks = params[:decks]
      return [] unless raw_decks.is_a?(Array) && raw_decks.present?

      raw_decks.map { |deck| permitted_deck(deck) }
    end

    def permitted_deck(deck)
      return nil unless deck.respond_to?(:permit)

      attributes = deck.permit(:archetype_name, :win_rate, :popularity).to_h.symbolize_keys
      return nil if attributes[:archetype_name].blank? || attributes[:win_rate].blank? || attributes[:popularity].blank?

      attributes
    end
  end
end
