require 'spec_helper'

describe Api::ToolSlotsController do
  include Devise::Test::ControllerHelpers
  describe 'batch updates' do
    let(:user) { FactoryGirl.create(:user) }
    let!(:tool_slots) { FactoryGirl.create_list(:tool_slot, 3) }

    it 'updates a list of tool slots' do
      sign_in user
      payload = [ {id: tool_slots[0].id, name: "first"},
                  {id: tool_slots[1].id, name: "second"},
                  {id: tool_slots[2].id, name: "third"} ]
      post :create, body: {tool_slots: payload}.to_json, format: :json
      expect(response.status).to eq(200)
      expect(json[1][:name]).to eq("second")
      expect(ToolSlot.find(json[1][:id]).reload.name).to eq("second")
    end
  end
end