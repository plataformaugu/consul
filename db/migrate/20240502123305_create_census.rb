class CreateCensus < ActiveRecord::Migration[6.0]
  def change
    create_table :census_records do |t|
      t.string :document_number

      t.timestamps
    end
  end
end
