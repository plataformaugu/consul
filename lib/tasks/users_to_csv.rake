require 'csv' # according to your settings, you may or may not need this line

namespace :users_to_csv do
  desc "TODO"
  task export_csv: :environment do
    export_to_csv User.all
  end

  def export_to_csv(users)
    CSV.open("./user.csv", "wb") do |csv|
      csv << User.attribute_names
      users.each do |user|
        csv << user.attributes.values
      end
    end
  end

end
