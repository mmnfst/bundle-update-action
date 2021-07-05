require 'dotenv/load'
require 'octokit'

CONFIG = {
  access_token: ENV['GITHUB_TOKEN'],
  repository: ENV['GITHUB_REPOSITORY'],
  branch: ENV['BRANCH'],
  base_branch: ENV['BASE_BRANCH'],
  pull_request_title: ENV['PULL_REQUEST_TITLE'],
  pull_request_body: ENV['PULL_REQUEST_BODY'],
  reviewers: ENV['REVIEWERS']&.split(','),
  assignees: ENV['ASSIGNEES']&.split(','),
  labels: ENV['LABELS']&.split(','),
  gems: ENV['GEMS']&.split(','),
  accept: 'application/vnd.github.groot-preview+json'
}

def client
  @client ||= Octokit::Client.new(access_token: CONFIG[:access_token])
end

def find_pull_request
  pull_requests = client.pull_requests(CONFIG[:repository])
  pull_requests.find { |pr| pr[:head][:ref] == CONFIG[:branch] && pr[:base][:ref] == CONFIG[:base_branch] }
end

def create_pull_request
  pull_request = client.create_pull_request(CONFIG[:repository], CONFIG[:base_branch], CONFIG[:branch], CONFIG[:pull_request_title])
  if CONFIG[:reviewers]&.size&.positive?
    client.request_pull_request_review(CONFIG[:repository], pull_request[:number], reviewers: CONFIG[:reviewers])
  end
  params = { assignees: CONFIG[:assignees], labels: CONFIG[:labels] }.compact
  client.update_issue(CONFIG[:repository], pull_request[:number], params) if params.size.positive?
  pull_request
end

def update_gems
  return `bundle update` if CONFIG[:gems].nil? || CONFIG[:gems] == '*'

  CONFIG[:gems].each { |gem| `bundle update #{gem}` }
end

def commit_updates
  `git commit -m "bundle update"`
end

update_gems
commit_updates
find_pull_request || create_pull_request
