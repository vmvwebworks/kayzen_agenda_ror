require 'rails_helper'
require 'cgi'

RSpec.describe "Api::Contacts", type: :request do
  describe "GET /api/contacts" do
    it "returns all contacts ordered by name" do
      create(:contact, name: "Aurora")
      create(:contact, name: "Benancio")
      get "/api/contacts"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).map { |c| c["name"] }).to eq(["Aurora", "Benancio"])
    end
  end

  describe "GET /api/contacts/:id" do
    let(:contact) { create(:contact) }

    it "returns the contact" do
      get "/api/contacts/#{CGI.escape(contact.name)}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["name"]).to eq(contact.name)
    end
  end

  describe "POST /api/contacts" do
    context "with valid params" do
      let(:valid_params) { { contact: { name: "New Contact", phone: "123456789", email: "new@example.com" } } }

      it "creates a contact" do
        post "/api/contacts", params: valid_params
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["name"]).to eq("New Contact")
      end
    end

    context "with invalid params" do
      let(:invalid_params) { { contact: { name: "", phone: "", email: "bad" } } }

      it "returns errors" do
        post "/api/contacts", params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to include("Name can't be blank")
      end
    end
  end

  describe "DELETE /api/contacts/:id" do
    let!(:contact) { create(:contact) }

    it "deletes the contact" do
      expect {
        delete "/api/contacts/#{CGI.escape(contact.name)}"
      }.to change(Contact, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
