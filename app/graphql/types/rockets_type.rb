# frozen_string_literal: true

module Types
  class RocketsType < Types::BaseObject
    field :name, String, null: true
    field :mass, String, null: true
    field :height, String, null: true
    field :diameter, String, null: true
  end
end
