class BugHerdTest < Service::TestCase
  def setup
    @stubs = Faraday::Adapter::Test::Stubs.new
  end

  def test_push
    @stubs.post "/custom" do |env|
      assert_equal 'www.example.com', env[:url].host
      assert_equal 'application/x-www-form-urlencoded',
        env[:request_headers]['content-type']
      [200, {}, '']
    end

    svc = service :push,
      {'url' => 'http://www.example.com/custom', 'project_key' => 'KEY'}, payload
    svc.receive_push

    @stubs.post "/github_web_hook/KEY" do |env|
      assert_equal 'www.bugherd.com', env[:url].host
      assert_equal 'application/x-www-form-urlencoded',
        env[:request_headers]['content-type']
      [200, {}, '']
    end

    svc = service :push,
      {'url' => '', 'project_key' => 'KEY'}, payload
    svc.receive_push
    svc.receive_issues
    svc.receive_issue_comment
  end

  def test_issues
    @stubs.post "/custom" do |env|
      assert_equal 'www.example.com', env[:url].host
      assert_equal 'application/x-www-form-urlencoded',
        env[:request_headers]['content-type']
      [200, {}, '']
    end

    svc = service :push,
      {'url' => 'http://www.example.com/custom', 'project_key' => 'KEY'}, payload
    svc.receive_issues

    @stubs.post "/github_web_hook/KEY" do |env|
      assert_equal 'www.bugherd.com', env[:url].host
      assert_equal 'application/x-www-form-urlencoded',
        env[:request_headers]['content-type']
      [200, {}, '']
    end

    svc = service :push,
      {'url' => '', 'project_key' => 'KEY'}, payload
    svc.receive_issues
  end

  def test_issue_comment
    @stubs.post "/custom" do |env|
      assert_equal 'www.example.com', env[:url].host
      assert_equal 'application/x-www-form-urlencoded',
        env[:request_headers]['content-type']
      [200, {}, '']
    end

    svc = service :push,
      {'url' => 'http://www.example.com/custom', 'project_key' => 'KEY'}, payload
    svc.receive_issue_comment

    @stubs.post "/github_web_hook/KEY" do |env|
      assert_equal 'www.bugherd.com', env[:url].host
      assert_equal 'application/x-www-form-urlencoded',
        env[:request_headers]['content-type']
      [200, {}, '']
    end

    svc = service :push,
      {'url' => '', 'project_key' => 'KEY'}, payload
    svc.receive_issue_comment
  end

  def service(*args)
    super Service::BugHerd, *args
  end
end
