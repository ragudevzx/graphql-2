class AppSchema < GraphQL::Schema
  query(Types::QueryType)
end
