class Watcher
  def initialize(client, organization, matcher, reporter)
    @client = client
    @organization = organization
    @matcher = matcher
    @reporter = reporter
  end

  def watch(from = 0, events_per_user = 10)
    e = events(members, events_per_user)
    p = recent_pushes(pushes(e), from)
    c = commits(p)
    bad = matches(c)
    @reporter.print(bad)
    max(p) || from
  end

  private

  attr_reader :client

  def members
    client.org_members(@organization, per_page: 100)
  end

  def events(members, events_per_user)
    members.flat_map do |member|
      client.user_public_events(member[:login], per_page: events_per_user)
    end
  end

  def pushes(events)
    events.select { |event| event[:type] == 'PushEvent' }
  end

  def recent_pushes(pushes, from)
    pushes.select { |push| push[:id].to_i > from }
  end

  def max(pushes)
    pushes.any? ? pushes.max_by(&:id)[:id] : nil
  end

  def commits(pushes)
    pushes.flat_map do |push|
      push[:payload][:commits].map do |commit|
        begin
          client.get(commit.url)
        rescue StandardError
          nil
        end
      end
    end.compact
  end

  def matches(commits)
    commits.flat_map do |commit|
      commit[:files].flat_map do |file|
        @matcher.check(file).map do |hit|
          { commit: commit, file: file, reason: hit }
        end
      end
    end
  end
end
