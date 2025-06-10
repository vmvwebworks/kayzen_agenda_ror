# app/controllers/api/contacts_controller.rb
class Api::ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :destroy]

  def index
    @contacts = Contact.order(:name)
    render json: @contacts
  end

  def show
    render json: @contact
  end

  def create
    contact = Contact.new(contact_params)
    if contact.save
      render json: contact, status: :created
    else
      render json: { errors: contact.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @contact.destroy!
    head :no_content
  end

  private

  def set_contact
    @contact = Contact.find_by!(name: params[:id])
  end

  def contact_params
    params.require(:contact).permit(:name, :phone, :email)
  end
end

