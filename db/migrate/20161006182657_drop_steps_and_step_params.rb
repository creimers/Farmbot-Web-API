class DropStepsAndStepParams < ActiveRecord::Migration[4.2]
  def change
    drop_table :step_params
    drop_table :steps
  end
end
