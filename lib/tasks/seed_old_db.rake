task :seed_old_db => :environment do
  require 'csv'
  require 'open-uri'

  priced_tires = Rails.configuration.mongo[:priced_tires]

  priced_tires.find().delete_many

  csv_text = URI.open 'https://transfer.sh/get/MGHOCE/old-db.csv'
  csv = CSV.parse csv_text, headers: true

  csv.each do |row|
    # row = {
    #   user_id: 'f987006a-ffad-4e09-9385-507728629c19',
    #   title: row['title'].to_s,
    #   content: row['body'].to_s,
    #   tags: row['category'].to_s.split(','),
    #   created_at: row['created_at']
    # }

    Post::Commands.create_from_seed(
      user_id: 'f987006a-ffad-4e09-9385-507728629c19',
      title: row['title'].to_s,
      content: row['body'].to_s,
      tags: row['category'].to_s.split(','),
      created_at: DateTime.parse(row["created_at"])
    )

    puts DateTime.parse(row["created_at"])
  end

end