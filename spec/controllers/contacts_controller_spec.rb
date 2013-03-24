require 'spec_helper'

describe ContactsController do
  context 'routing' do
    it {should route(:post, '/contacts').to :action => :create}
    it {should route(:get, '/contacts/1').to :action => :show, :id => 1}
    it {should route(:put, '/contacts/1').to :action => :update, :id => 1}
    it {should route(:delete, '/contacts/1').to :action => :destroy, :id => 1}
    it {should route(:get, '/contacts').to :action => :index}
  end

  context 'POST create' do
    context 'with valid parameters' do
      let(:valid_attributes) {{:name => 'michael'}}
      let(:valid_parameters) {{:contact => valid_attributes}}

      it 'creates a new contact' do
        expect {post :create, valid_parameters}.to change(Contact, :count).by(1)
      end

      before {post :create, valid_parameters}

      it {should respond_with 201}
      it {should respond_with_content_type :json}
      it 'responds with a json representation of the newly-created contact' do
        response.body.should eq Contact.find(JSON.parse(response.body)['contact']['id']).to_json
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) {{:name => ''}}
      let(:invalid_parameters) {{:contact => invalid_attributes}}
      before {post :create, invalid_parameters}

      it {should respond_with 422}
      it {should respond_with_content_type :json}
      it 'responds with a json representation of the errors' do
        response.body.should eq Contact.create(invalid_attributes).errors.to_json
      end
    end
  end

  context 'GET show' do
    let(:contact) {FactoryGirl.create :contact}
    before {get :show, :id => contact.id}

    it {should respond_with 200}
    it {should respond_with_content_type :json}
    it 'responds with a json representation of the contact' do
      response.body.should eq contact.to_json
    end
  end

  context 'PUT update' do
    let(:contact) {FactoryGirl.create :contact}

    context 'with valid parameters' do
      let(:valid_attributes) {{:email => 'michael@epicodus.com'}}
      let(:valid_parameters) {{:id => contact.id, :contact => valid_attributes}}
      before {put :update, valid_parameters}

      it 'updates the contact' do
        Contact.find(contact.id).email.should eq valid_attributes[:email]
      end

      it {should respond_with 200}
      it {should respond_with_content_type :json}
      it 'responds with a json representation of the updated contact' do
        response.body.should eq contact.reload.to_json
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) {{:name => ''}}
      let(:invalid_parameters) {{:id => contact.id, :contact => invalid_attributes}}
      before {put :update, invalid_parameters}

      it {should respond_with 422}
      it {should respond_with_content_type :json}

      it 'responds with a json representation of the errors' do
        contact.update_attributes(invalid_attributes)
        response.body.should eq contact.errors.to_json
      end
    end
  end

  context 'DELETE destroy' do
    it 'destroys a contact' do
      contact = FactoryGirl.create :contact
      expect {delete :destroy, {:id => contact.id}}.to change(Contact, :count).by(-1)
    end

    let(:contact) {FactoryGirl.create :contact}
    before {delete :destroy, {:id => contact.id}}

    it {should respond_with 204}
  end

  context 'GET index' do
    before {Contact.create({:name => 'michael'})}
    before {get :index}

    it {should respond_with 200}
    it {should respond_with_content_type :json}
    it 'responds with a json representation of all the contacts' do
      response.body.should eq Contact.all.to_json
    end
  end
end

# describe ContactsController do
#   context 'POST create' do
#     context 'with valid parameters' do
#       let(:valid_attributes) {{:name => 'michael'}}
#       let(:valid_parameters) {{:contact => valid_attributes}}

#       it 'creates a new contact' do
#         expect {post :create, valid_parameters}.to change(Contact, :count).by(1)
#       end

#       before {post :create, valid_parameters}

#       it {should respond_with 201}
#       it {should respond_with_content_type :json}
#       it 'responds with a json representation of the newly-created contact' do
#         response.body.should eq Contact.find(JSON.parse(response.body)['contact']['id']).to_json
#       end
#     end
#   end

#   context 'POST create' do
#     context 'with invalid parameters' do
#       let(:invalid_attributes) {{:name => ''}}
#       let(:invalid_parameters) {{:contact => invalid_attributes}}

#       before {post :create, invalid_parameters}

#       it {should respond_with 422}
#       it {should respond_with_content_type :json}
#       it 'responds with a json representation of the errors' do
#         response.body.should eq Contact.create(invalid_attributes).errors.to_json
#       end
#     end
#   end
# end