describe 'Auth requests', auth_helpers: true, api_version: :'v2.1', set_app: true do
  let(:user)    { FactoryBot.create(:user) }
  let(:repo)    { Repository.by_slug('svenfuchs/minimal').first }
  let(:request) { repo.requests.first }

  # TODO
  # post '/requests'

  describe 'in public mode, with a private repo', mode: :public, repo: :private do
    describe 'GET /requests?repository_id=%{repo.id}' do
      it(:with_permission)    { should auth status: 200, empty: false }
      it(:without_permission) { should auth status: 404 }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 404 }
    end

    describe 'GET /requests/%{request.id}' do
      it(:with_permission)    { should auth status: 200, empty: false }
      it(:without_permission) { should auth status: 404 }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 404 }
    end
  end

  describe 'in public mode, with a public repo', mode: :public, repo: :public do
    describe 'GET /requests?repository_id=%{repo.id}' do
      it(:with_permission)    { should auth status: 200, empty: false }
      it(:without_permission) { should auth status: 200, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, empty: false }
    end

    describe 'GET /requests/%{request.id}' do
      it(:with_permission)    { should auth status: 200, empty: false }
      it(:without_permission) { should auth status: 404 }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 404 }
    end
  end

  # +----------------------------------------------------+
  # |                                                    |
  # |   !!! THE ORIGINAL BEHAVIOUR ... DON'T TOUCH !!!   |
  # |                                                    |
  # +----------------------------------------------------+

  describe 'in private mode, with a private repo', mode: :private, repo: :private do
    describe 'GET /requests?repository_id=%{repo.id}' do
      it(:with_permission)    { should auth status: 200, empty: false }
      it(:without_permission) { should auth status: 404 }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /requests/%{request.id}' do
      it(:with_permission)    { should auth status: 200, empty: false }
      it(:without_permission) { should auth status: 404 }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end
  end

  describe 'in org mode, with a public repo', mode: :org, repo: :public do
    describe 'GET /requests?repository_id=%{repo.id}' do
      it(:with_permission)    { should auth status: 200, empty: false }
      it(:without_permission) { should auth status: 200, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, empty: false }
    end

    describe 'GET /requests/%{request.id}' do
      it(:with_permission)    { should auth status: 200, empty: false }
      it(:without_permission) { should auth status: 200, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, empty: false }
    end
  end
end