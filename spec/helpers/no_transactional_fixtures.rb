module NoTransactionalFixtures
  def self.included(example_group)
    example_group.use_transactional_fixtures = false
  end
end
