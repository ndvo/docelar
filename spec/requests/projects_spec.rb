require "rails_helper"

RSpec.describe "Projects", type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  
  before do
    # Authenticate user via session (matching ApplicationController)
    post login_path, params: { email_address: user.email_address, password: "password123" }
  end

  describe "GET /projects" do
    context "when user has projects" do
      before do
        create_list(:project, 3, user: user)
      end

      it "returns successful response" do
        get projects_path
        expect(response).to be_successful
      end

      it "renders projects list" do
        get projects_path
        expect(response.body).to include("Projetos")
      end
    end

    context "when user has no projects" do
      it "returns successful response" do
        get projects_path
        expect(response).to be_successful
      end
    end
  end

  describe "GET /projects/new" do
    it "returns successful response" do
      get new_project_path
      expect(response).to be_successful
    end

    it "renders new project form" do
      get new_project_path
      expect(response.body).to include("Novo Projeto")
    end
  end

  describe "POST /projects" do
    let(:valid_attributes) do
      {
        project: {
          name: "Test Project",
          description: "A test project",
          project_type: "outcome_based",
          category: "work"
        }
      }
    end

    context "with valid parameters" do
      it "creates a new Project" do
        expect {
          post projects_path, params: valid_attributes
        }.to change(Project, :count).by(1)
      end

      it "redirects to projects list" do
        post projects_path, params: valid_attributes
        expect(response).to redirect_to(projects_path)
      end

      it "sets the user_id correctly" do
        post projects_path, params: valid_attributes
        expect(Project.last.user).to eq(user)
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) do
        { project: { name: "" } }
      end

      it "does not create a new project" do
        expect {
          post projects_path, params: invalid_attributes
        }.not_to change(Project, :count)
      end

      it "renders new template" do
        post projects_path, params: invalid_attributes
        expect(response).to be_successful
      end

      it "shows validation errors" do
        post projects_path, params: invalid_attributes
        expect(response.body).to include("Novo Projeto")
      end
    end
  end

  describe "GET /projects/:id" do
    it "returns successful response" do
      get project_path(project)
      expect(response).to be_successful
    end

    it "renders project details" do
      get project_path(project)
      expect(response.body).to include(project.name)
    end
  end

  describe "GET /projects/:id/edit" do
    it "returns successful response" do
      get edit_project_path(project)
      expect(response).to be_successful
    end
  end

  describe "PATCH /projects/:id" do
    let(:new_attributes) do
      { project: { name: "Updated Project Name" } }
    end

    it "updates the project" do
      patch project_path(project), params: new_attributes
      project.reload
      expect(project.name).to eq("Updated Project Name")
    end

    it "redirects to projects list" do
      patch project_path(project), params: new_attributes
      expect(response).to redirect_to(projects_path)
    end
  end

  describe "DELETE /projects/:id" do
    let!(:project_to_delete) { create(:project, user: user) }

    it "destroys the requested project" do
      expect {
        delete project_path(project_to_delete)
      }.to change(Project, :count).by(-1)
    end

    it "redirects to projects list" do
      delete project_path(project_to_delete)
      expect(response).to redirect_to(projects_path)
    end
  end
end
