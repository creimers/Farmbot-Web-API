class ToolSlotSerializer < ActiveModel::Serializer
  attributes :id, :tool_bay_id, :tool_id, :name, :x, :y, :z
end
