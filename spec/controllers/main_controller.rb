RSpec.describe MainController, :type => :controller do
    before do
        @controller = MainController()
    end

    describe "GET #index" do
        it "responds with a 200" do
            get :index
            expect(resporse).to be_success
            expect(response).to have_http_status(200)
        end
    end
end
