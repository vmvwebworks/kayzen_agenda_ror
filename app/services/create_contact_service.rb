# app/services/create_contact_service.rb
class CreateContactService
  attr_reader :contact, :errors

  def initialize(params)
    @params = params
    @errors = []
  end

  def call
    @contact = Contact.new(@params)
    if @contact.save
      true
    else
      @errors = @contact.errors.full_messages
      false
    end
  end
end
