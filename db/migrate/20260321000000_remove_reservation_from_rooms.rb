class RemoveReservationFromRooms < ActiveRecord::Migration[7.1]
  def change
    remove_reference :rooms, :reservation, foreign_key: true, index: true
  end
end
