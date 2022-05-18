class AddThemeToProposals < ActiveRecord::Migration[5.2]
  def change
    add_reference :proposals, :proposals_theme, index: true
  end
end
