# single_file_test.rb

require 'active_record'
require 'minitest/autorun'

ActiveRecord::Base.establish_connection(
  adapter: "postgresql",
  encoding: "unicode",
  database: "postgres",
  username: "postgres",
  password: "",
  host: "postgres",
)

# Clear database
ActiveRecord::Base.connection.tables.each do |table|
  ActiveRecord::Base.connection.drop_table(table)
end

class CreateEquipoTable < ActiveRecord::Migration[7.2]
  def change
    create_table :backendos do |t|
      t.string :name
    end

    create_table :frontendos do |t|
      t.string :name
      t.boolean :work_hard, default: false
      t.references :backendo
    end
  end

  def down
    drop_table :backendos
    drop_table :frontendos
  end
end

class Backendo < ActiveRecord::Base
    attribute :work_hard, :boolean, default: false
    has_many :frontendos

    before_validation :set_frontendos_to_work_hard

    def set_frontendos_to_work_hard
      self.frontendos.each do |frontend|
        puts "debug #{self.work_hard}"
        frontend.work_hard = self.work_hard
      end
    end
end

class Frontendo < ActiveRecord::Base
    attribute :work_hard, :boolean, default: false


end

class TimezoneTest < Minitest::Test
  def setup
    CreateEquipoTable.migrate(:up)
  end

  def teardown
    CreateEquipoTable.migrate(:down)
  end

  def test_frozen_attribute
    Backendo.create(name: "Backendo", frontendos: [
      Frontendo.new(name: "Frontendo 1"),
      Frontendo.new(name: "Frontendo 2"),
    ], work_hard: true)

    puts Backendo.first.frontendos.size
    puts Backendo.first.frontendos.first.work_hard
    puts Backendo.first.frontendos.last.work_hard
  end
end
