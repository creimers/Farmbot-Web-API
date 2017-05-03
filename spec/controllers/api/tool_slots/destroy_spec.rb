require 'spec_helper'

describe Api::ToolSlotsController do
  include Devise::Test::ControllerHelpers

  sequence_fixture = <<~HEREDOC
    [{ "kind":"move_absolute",
       "args":{
           "location":{ "kind":"tool", "args":{ "tool_id": --- } },
           "offset":{ "kind":"coordinate", "args":{ "x":0, "y":0, "z":0 } },
           "speed":800}}]
  HEREDOC

  describe '#destroy' do
    let(:user) { FactoryGirl.create(:user) }
    let!(:tool_bay) { FactoryGirl.create(:tool_bay, device: user.device) }
    let!(:tool) { FactoryGirl.create(:tool, device: user.device) }
    let!(:tool_slot) { tool.slot }
    let!(:sequence) { Sequences::Create.run!({
                        device: user.device,
                        name: "TOOL SLOT",
                        body: JSON
                              .parse(sequence_fixture.gsub("---", tool.id.to_s))
                      }) }

    it 'cleans up tool slot SequenceDependencies' do
      tool_slot.tool_bay.update_attributes(device: user.device)
      # This sequence requires the tool slot above.
      # deletetion should free up the resource.
      sequence.destroy!
      sign_in user
      payload = { id: tool_slot.id }
      before = ToolSlot.count
      delete :destroy, params: payload
      expect(response.status).to eq(200)
      after = ToolSlot.count
      expect(response.status).to eq(200)
      expect(after).to be < before
    end

    it 'disallows deletion of slots in use by sequences' do
      sign_in user
      tool_slot.tool_bay.update_attributes(device: user.device)
      payload = { id: tool_slot.id }
      before = ToolSlot.count
      delete :destroy, params: payload
      after = ToolSlot.count
      expect(response.status).to eq(422)
      expect(after).to eq(before)
    end
  end
end
