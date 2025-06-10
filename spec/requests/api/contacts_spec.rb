# spec/requests/contacts_spec.rb
require 'rails_helper'

RSpec.describe "Contacts API", type: :request do
  let(:valid_attributes) do
    { name: "Ausevia", phone: "1234567890", email: "ause@example.com" }
  end

  let(:invalid_email_attributes) do
    { name: "Benicio", phone: "0987654321", email: "Benicio_sin_arroba" }
  end

  it "adds a valid contact" do
    post "/api/contacts", params: { contact: valid_attributes }
    expect(response).to have_http_status(:created)
    expect(JSON.parse(response.body)["name"]).to eq("Ausevia")
  end

  it "prevents duplicate names" do
    Contact.create!(valid_attributes)
    post "/api/contacts", params: { contact: valid_attributes }
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it "validates email format" do
    post "/api/contacts", params: { contact: { name: "Test", phone: "123", email: "bad_email" } }, headers: { "ACCEPT" => "application/json" }
    expect(response).to have_http_status(:unprocessable_entity)
    expect(JSON.parse(response.body)["errors"]).to include("Email Wrong email format")
  end

  it "deletes a contact by name" do
    Contact.create!(valid_attributes)
    delete "/api/contacts/Ausevia"
    expect(response).to have_http_status(:no_content)
  end

  it "lists contacts in alphabetical order" do
    Contact.create!(name: "Gregorio", phone: "1", email: "grego@example.com")
    Contact.create!(name: "Bonifacia", phone: "2", email: "Boni@example.com")
    get "/api/contacts"
    names = JSON.parse(response.body).map { |c| c["name"] }
    expect(names).to eq([ "Bonifacia", "Gregorio" ])
  end
end
