namespace :javascript do
  desc "Build the agent-log page's React bundle"
  task build: :environment do
    sh "npm run build:agent-log"
  end
end

Rake::Task["assets:precompile"].enhance([ "javascript:build" ])

%w[test:prepare spec:prepare db:test:prepare].each do |task_name|
  Rake::Task[task_name].enhance([ "javascript:build" ]) if Rake::Task.task_defined?(task_name)
end
