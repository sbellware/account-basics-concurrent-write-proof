require_relative '../gems/bundler/setup'
require 'eventide/postgres'

class Deposit
  include Messaging::Message

  attribute :account_id, String
  attribute :amount, Numeric
  attribute :time, String
end

message = ->(account_id) do
  m = Deposit.new
  m.account_id = account_id.to_s
  m.amount = 100
  m.time = Clock.iso8601
  m
end

stream_name = ->(account_id) do
  "account:command-#{account_id}"
end

writer = ->(idx) do
  Thread.new do
    batch = (1_000 * (idx + 1)).times.map { message[idx] }
    Messaging::Postgres::Write.(batch, stream_name[idx])
  end
end

writers = 2
writers.times.map(&writer).map(&:join)
