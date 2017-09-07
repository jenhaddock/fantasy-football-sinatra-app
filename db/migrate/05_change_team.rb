class ChangeTeam < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :pro_team, :string
  end
end
