require "http"

module Types
  class QueryType < Types::BaseObject
    field :user, UserType, null: true do
      description "fetch user by id"
      argument :id, ID, required: true
      argument :cached, Boolean, required: false, default_value: true
    end

    def user(id:, cached:)
      User::Cache.new("arron", "arrontaylor")
    end

    field :rockets, [Types::RocketsType], null: false do
      description "Query that return all Rockets information"
    end

    def rockets
      rockets = HTTP.post("https://api.spacexdata.com/v4/rockets/query").body.to_s
      data = JSON.parse(rockets)
      #diameter = data["docs"][0]["diameter"]["feet"]
      finalData = Array.new()

      for i in data["docs"] do
        #diameter = data["docs"][0]["diameter"]["feet"]
        finalData.append({
        diameter: i["diameter"],
        name: i["name"],
        mass: i["mass"],
        height: i["height"],
        })
        puts "Value of I is #{finalData}"
      end

      return finalData
    end
  end
end
