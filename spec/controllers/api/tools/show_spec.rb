require 'spec_helper'

describe Api::ToolsController do
  include Devise::Test::ControllerHelpers
  describe '#show' do
    let(:user) { FactoryGirl.create(:user) }
    let(:tool_slot) { FactoryGirl.create(:tool_slot) }
    let(:tool) { FactoryGirl.create(:tool,
                    tool_slot: tool_slot,
                    device: user.device) }

    it 'renders a tool' do
      sign_in user
      get :show, params: { id: tool.id }
      expect(response.status).to eq(200)
      expect(json[:id]).to eq(tool.id)
    end
  end
end
