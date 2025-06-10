# spec/services/create_contact_service_spec.rb
require 'rails_helper'

RSpec.describe CreateContactService, type: :service do
  let(:valid_params) { { name: "John Doe", phone: "1234567890", email: "john@example.com" } }
  let(:invalid_params) { { name: "", phone: "", email: "invalid_email" } }

  describe "#call" do
    context "with valid params" do
      it "creates a contact" do
        service = CreateContactService.new(valid_params)
        expect(service.call).to be true
        expect(service.contact).to be_persisted
      end
    end

    context "with invalid params" do
      it "does not create a contact and sets errors" do
        service = CreateContactService.new(invalid_params)
        expect(service.call).to be false
        expect(service.errors).to include("Name can't be blank")
      end
    end
  end
end
