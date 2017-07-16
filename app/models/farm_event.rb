# Not the same thing as a Regimen. A farm_event is a "dumb" list of sequecnes that
# are executed at fixed intervals. FarmEvents are less flexible than Regimens
# because they can only perform one sequence. Also unlike Regimens, they can run
# forever.
class FarmEvent < ActiveRecord::Base
  NEVER              = "never"
  UNITS_OF_TIME      = %w(never minutely hourly daily weekly monthly yearly)
  UNITS_OF_TIME      << NEVER
  EXECUTABLE_CLASSES = [Sequence, Regimen]
  FE_USE             = "still in use by some farm events"
  belongs_to :executable, polymorphic: true
  validates  :executable, presence: true
  belongs_to :device
  validates  :device_id, presence: true

  # Check if an executable is in use.
  def self.if_still_using(executable)
    yield if self.where(executable: executable).any?
  end
end
