# single_file_test.rb

require 'active_record'
require 'minitest/autorun'
require 'timezone'

ActiveRecord::Base.establish_connection(
  adapter: "postgresql",
  encoding: "unicode",
  database: "postgres",
  username: "postgres",
  password: "",
  host: "postgres",
)


module Timezoned
  extend ActiveSupport::Concern

  class_methods do
    def timezoned(*fields)
      fields.each do |field|
        define_method "#{field.to_s}_timezoned" do
          ts = self.send(field)
          ts.blank? ? nil : self.timezone.time_with_offset(self.send(field))
        end
      end
    end
  end
end

class CreateSomewheresTable < ActiveRecord::Migration[7.2]
  def change
    create_table :somewheres do |t|
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
  end
end


class Somewhere < ActiveRecord::Base
  include Timezoned

  timezoned :start_at, :end_at
  def timezone
    Timezone['America/Recife']
  end 
end


class SomewheresTest < Minitest::Test
  def setup
    CreateSomewheresTable.migrate(:up)
  end

  def teardown
    CreateSomewheresTable.migrate(:down)
  end

  def test_user_creation
    first_start_at = "2024-08-22T10:00:00"
    first_end_at = "2024-08-23T16:00:00"

    timezone_a = Somewhere.create(start_at: first_start_at, end_at: first_end_at)
    
    assert_equal timezone_a.start_at.to_s, "2024-08-22 10:00:00 UTC"
    assert_equal timezone_a.start_at_timezoned.to_s, "2024-08-22 07:00:00 -0300"

    assert_equal timezone_a.end_at.to_s, "2024-08-23 16:00:00 UTC"
    assert_equal timezone_a.end_at_timezoned.to_s, "2024-08-23 13:00:00 -0300"
  end
end
