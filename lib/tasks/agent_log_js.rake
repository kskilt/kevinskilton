namespace :javascript do
  desc "Build the agent-log page's React bundle"
  task build: :environment do
    sh "npm run build:agent-log"
  end
end

Rake::Task["assets:precompile"].enhance([ "javascript:build" ])
