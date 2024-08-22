# single_file_test.rb

require 'active_record'
require 'minitest/autorun'
require 'tzinfo'

ActiveRecord::Base.establish_connection(
  adapter: "postgresql",
  encoding: "unicode",
  database: "postgres",
  username: "postgres",
  password: "",
  host: "postgres",
)

class CreateTimezonesTable < ActiveRecord::Migration[7.2]
  def change
    create_table :timezones do |t|
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
  end
end

class Timezone < ActiveRecord::Base
end


class TimezoneTest < Minitest::Test
  def setup
    CreateTimezonesTable.migrate(:up)
  end

  def teardown
    CreateTimezonesTable.migrate(:down)
  end

  def test_user_creation
    # Prepare timezone A
    first_start_at = "2024-08-22T02:00:00+0300"
    first_end_at = "2024-08-23T16:00:00+0300"
    # Prepare timezone B
    second_start_at = "2024-08-22T02:00:00+0000"
    second_end_at = "2024-08-23T16:00:00+0000"


    timezone_a = Timezone.create(start_at: first_start_at, end_at: first_end_at)
    timezone_b = Timezone.create(start_at: second_start_at, end_at: second_end_at)

    puts "========= TIMEZONE A ============"
    puts timezone_a.start_at
    puts timezone_a.end_at
    puts "========= TIMEZONE B ============"
    puts timezone_b.start_at
    puts timezone_b.end_at
    puts "================================="

    # -"2024-08-21 23:00:00 UTC"
    # +"2024-08-22T02:00:00+0300"
    assert_equal timezone_a.start_at.to_s, first_start_at
  end
end
