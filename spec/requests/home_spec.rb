require "rails_helper"

RSpec.describe "Home", type: :request do
  let(:user) { create(:user) }
  
  before do
    session = user.sessions.create!(user_agent: "Rails Testing", ip_address: "127.0.0.1")
    allow(Current).to receive(:session).and_return(session)
  end

  describe "GET /" do
    it "returns successful response" do
      get root_path
      expect(response).to be_successful
    end

    it "renders dashboard header" do
      get root_path
      expect(response.body).to include("Bem-vindo ao Doce Lar")
    end

    it "renders quick stats section" do
      get root_path
      expect(response.body).to include("Tarefas pendentes")
      expect(response.body).to include("Pagamentos a vencer")
    end

    it "renders module groups section" do
      get root_path
      expect(response.body).to include("12 Pilares do Doce Lar")
    end

    context "when there are pending tasks" do
      before do
        create_list(:task, 3, status: :planned)
      end

      it "shows correct tasks count in quick stats" do
        get root_path
        expect(response.body).to include("3")
      end
    end

    context "when there are due payments" do
      let(:card) { create(:card) }
      let(:purchase) { create(:purchase, card: card) }
      
      before do
        create_list(:payment, 2, purchase: purchase, due_at: Date.today + 3.days)
      end

      it "shows correct payments count in quick stats" do
        get root_path
        expect(response.body).to include("2")
      end
    end

    context "when there are dogs" do
      before do
        create_list(:dog, 2)
      end

      it "shows correct pets count in quick stats" do
        get root_path
        expect(response.body).to include("2")
      end
    end

    context "when there are photos and videos" do
      let(:gallery) { create(:gallery) }
      
      before do
        create_list(:photo, 3, gallery: gallery)
      end

      it "shows correct photos count in quick stats" do
        get root_path
        expect(response.body).to include("3")
      end
    end

    context "when there are upcoming tasks" do
      before do
        create_list(:task, 5, status: :planned)
      end

      it "renders upcoming tasks section" do
        get root_path
        expect(response.body).to include("Tarefas Recentes")
      end
    end

    context "when there are recent payments" do
      let(:card) { create(:card) }
      let(:purchase) { create(:purchase, card: card) }
      
      before do
        create_list(:payment, 3, purchase: purchase, due_at: Date.today + 3.days)
      end

      it "renders recent activity section" do
        get root_path
        expect(response.body).to include("Atividade Recente")
      end

      it "shows recent payments in activity" do
        get root_path
        expect(response.body).to include(purchase.merchant)
      end
    end

    context "when there are no activities" do
      it "does not render recent activity section" do
        get root_path
        expect(response.body).not_to include("Atividade Recente")
      end
    end

    describe "accessibility" do
      it "has skip link" do
        get root_path
        expect(response.body).to include('class="skip-link"')
      end

      it "has proper ARIA labels on navigation" do
        get root_path
        expect(response.body).to include('aria-label="Navegação móvel"')
        expect(response.body).to include('aria-label="Navegação principal"')
      end

      it "has proper ARIA labels on sections" do
        get root_path
        expect(response.body).to include('aria-label="Estatísticas rápidas"')
        expect(response.body).to include('aria-label="Seus widgets"')
        expect(response.body).to include('aria-label="Módulos do Doce Lar"')
      end
    end
  end
end
