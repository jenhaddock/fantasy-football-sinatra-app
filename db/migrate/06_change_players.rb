class ChangePlayers < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :pro_team, :string
    remove_column :teams, :pro_team
  end
end
