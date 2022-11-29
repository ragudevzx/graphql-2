task :seed_roadmaps => :environment do

  # puts Dir.entries("./developer-roadmap/content/roadmaps/100-frontend/content/110-build-tools/101-module-bundlers")

  roadmap_id = SecureRandom.uuid

  roadmap = Roadmap::Commands.create(
    name: 'Frontend Developer',
    description: 'Step by step guide to becoming a modern frontend developer in 2022',
    user_id: 'community',
    id: roadmap_id,
    category: 'community'
  )

  if roadmap
    file = File.open("./developer-roadmap/content/roadmaps/100-frontend/content-paths.json")
    read_file =  file.read

    puts 'Adding all stacks to the roadmap...'

    ## Add all stacks to the roadmap

    JSON.parse(read_file).keys.each do |d|
      item_name = d.to_s.gsub('-', ' ')
      stack_name = item_name.split(':')[0].gsub('-', ' ')

      if (!Group::Cache.find_by(context_id: roadmap_id, name: stack_name, context_type: 'roadmap'))
        if (stack_name != 'home')
          stack = Group::Commands.create(
            name: stack_name,
            user_id: 'community',
            context_type: "roadmap",
            context_id: roadmap_id
          )
        end
      end

    end

    puts 'Done.'
    puts 'Adding all card groups to those stacks...'

    ## Add all card groups

    JSON.parse(read_file).keys.each do |d|
      item_name = d.to_s.gsub('-', ' ')
      stack_name = item_name.split(':')[0]

      has_third_name = item_name.split(':').length === 3
      card_group_name = item_name.split(':')[1]

      'hey:hi:ho'

      if (has_third_name)

        pre_existing_stack = Group::Cache.find_by(name: stack_name, context_id: roadmap_id, context_type: 'roadmap')
        pre_existing_card_group = Group::Cache.find_by(context_id: pre_existing_stack&.id, name: card_group_name, context_type: 'roadmap_child')

        if ( pre_existing_card_group )

            ## IF A CARD GROUP EXISTS ALREADY, HERE WE MAKE A NEW CARD
            ## AND PUT IT INSIDE OF THE GROUP WE JUST MADE

        else

          # puts "making the card group for #{card_group_name} with parent id #{pre_existing_stack&.id}"
          new_card_group_id = SecureRandom.uuid

          card_group = Group::Commands.create_nested_group(
            name: card_group_name,
            user_id: 'community',
            context_type: 'roadmap_child',
            context_id: pre_existing_stack&.id,
            id: new_card_group_id
          )

          if card_group
            Group::Commands.add_item_to_group(
              user_id: 'community',
              group_id: pre_existing_stack&.id,
              item_id: new_card_group_id
            )
          end

        end
      end

    end

    puts 'Done.'
    puts 'Adding all cards to those groups and stacks...'

    JSON.parse(read_file).keys.each do |d|
      item_name = d.to_s.gsub('-', ' ')
      stack_name = item_name.split(':')[0]
      one_name_only = item_name.split(':').length == 1
      two_names_only = item_name.split(':').length == 2
      three_names_only = item_name.split(':').length == 3

      card_group_name = item_name.split(':')[1]
      third_name = item_name.split(':')[2]

      file = File.open("./developer-roadmap/content#{JSON.parse(read_file)[d]}").read
      document = Nokogiri::HTML.parse(file)
      badge_links = document.xpath("//badgelink")

      ## really bad way to get the description....
      file_lines = File.readlines("./developer-roadmap/content#{JSON.parse(read_file)[d]}")
      description = file_lines[2] || nil

      if (two_names_only)

        pre_existing_stack = Group::Cache.find_by(name: stack_name, context_id: roadmap_id, context_type: 'roadmap')
        pre_existing_card_group = Group::Cache.find_by(name: card_group_name, context_id: pre_existing_stack&.id, context_type: 'roadmap_child')

        if badge_links.length > 0

          card_id = SecureRandom.uuid

          card = Card::Commands.create(
            user_id: 'community',
            name: card_group_name,
            id: card_id,
            roadmap_id: roadmap_id,
            description: description
          )

          if (pre_existing_card_group)
            ## IF THERE IS A PREEXISTING CARD GROUP, PUT THIS NEW CARD CARD IN THAT GROUP....
            card_group = Group::Commands.add_item_to_group(
              user_id: 'community',
              group_id: pre_existing_card_group&.id,
              item_id: card_id
            )

            if card_group
              badge_links.each do |link|
                puts "#{link[:badgetext].downcase} \t #{link[:href]} \t #{link.text.downcase}"

                task = Task::Commands.create(
                  user_id: 'community',
                  target_id: card_id,
                  target_type: 'card',
                  task_url: link[:href],
                  task_type: link[:badgetext].downcase,
                  task_name: link.text.downcase
                )
                puts task
              end
            end

          else
            ## ELSE, PUT THE CARD ON THE STACK
            stack = Group::Commands.add_item_to_group(
              user_id: 'community',
              group_id: pre_existing_stack&.id,
              item_id: card_id
            )
            if stack
              badge_links.each do |link|
                puts "#{link[:badgetext].downcase} \t #{link[:href]} \t #{link.text.downcase}"
                task = Task::Commands.create(
                  user_id: 'community',
                  target_id: card_id,
                  target_type: 'card',
                  task_url: link[:href],
                  task_type: link[:badgetext].downcase,
                  task_name: link.text.downcase
                )
                puts task
              end
            end
          end
        end

      end

      if (one_name_only)
        pre_existing_stack = Group::Cache.find_by(name: stack_name, context_id: roadmap_id, context_type: 'roadmap')

        if badge_links.length > 0
          card_id = SecureRandom.uuid

          card = Card::Commands.create(
            user_id: 'community',
            name: stack_name,
            id: card_id,
            roadmap_id: roadmap_id,
            description: description
          )

          stack = Group::Commands.add_item_to_group(
            user_id: 'community',
            group_id: pre_existing_stack&.id,
            item_id: card_id
          )

          if stack
            badge_links.each do |link|
              puts "#{link[:badgetext].downcase} \t #{link[:href]} \t #{link.text.downcase}"
              task = Task::Commands.create(
                user_id: 'community',
                target_id: card_id,
                target_type: 'card',
                task_url: link[:href],
                task_type: link[:badgetext].downcase,
                task_name: link.text.downcase
              )
            end
          end
        end
      end

      if (three_names_only)
        pre_existing_stack = Group::Cache.find_by(name: stack_name, context_id: roadmap_id, context_type: 'roadmap')
        pre_existing_card_group = Group::Cache.find_by(name: card_group_name, context_id: pre_existing_stack&.id, context_type: 'roadmap_child')

        if badge_links.length > 0
          card_id = SecureRandom.uuid

          card = Card::Commands.create(
            user_id: 'community',
            name: third_name,
            id: card_id,
            roadmap_id: roadmap_id,
            description: description
          )

          stack = Group::Commands.add_item_to_group(
           user_id: 'community',
           group_id: pre_existing_card_group&.id,
           item_id: card_id
         )

         if stack
           badge_links.each do |link|
             puts "#{link[:badgetext].downcase} \t #{link[:href]} \t #{link.text.downcase}"
             task = Task::Commands.create(
               user_id: 'community',
               target_id: card_id,
               target_type: 'card',
               task_url: link[:href],
               task_type: link[:badgetext].downcase,
               task_name: link.text.downcase
             )

           end

         end
        end

      end

    end

  end










  # file = File.open("./developer-roadmap/content/roadmaps/100-frontend/content/110-build-tools/101-module-bundlers/102-rollup.md")

  # read_file =  file.read

  # document = Nokogiri::HTML.parse(read_file)

  # badge_links = document.xpath("//badgelink")

  # puts 'hi mom'
  # puts document
  # puts badge_links

  # card_id = SecureRandom.uuid

  # card = Card::Commands.create(
  #   user_id: 'f987006a-ffad-4e09-9385-507728629c19',
  #   name: 'Rollup',
  #   id: card_id,
  #   # updated_attributes: ActionController::Parameters.new({ 'group_id': uuid }),
  #   roadmap_id: "16834665-fd4b-4e16-a9e6-15d38b288cd9"
  # )

  # if card

  #   stack = Group::Commands.add_item_to_group(
  #     user_id: 'f987006a-ffad-4e09-9385-507728629c19',
  #     group_id: "84ddcf23-3053-4069-a333-2c8c5939a2db",
  #     item_id: card_id
  #   )

  #   if stack
  #     badge_links.each do |link|
  #       puts "#{link[:badgetext].downcase} \t #{link[:href].downcase} \t #{link.text.downcase}"

  #       task = Task::Commands.create(
  #         user_id: 'f987006a-ffad-4e09-9385-507728629c19',
  #         target_id: card_id,
  #         target_type: 'card',
  #         task_url: link[:href].downcase,
  #         task_type: link[:badgetext].downcase,
  #         task_name: link.text.downcase
  #       )
  #       puts task

  #     end

  #   end



  # end




end