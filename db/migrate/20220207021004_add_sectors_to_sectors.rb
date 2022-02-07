class AddSectorsToSectors < ActiveRecord::Migration[5.2]
  def change
    (1..25).each do |n|
      execute("insert into sectors(name) values('C#{n}');")
    end
  end
end
