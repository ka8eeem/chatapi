class RabbitConnection
  include Singleton
  attr_reader :connection
  def initialize
    @connection = Bunny.new("amqp://guest:guest@localhost:5672")
    @connection.start

    Sneakers.configure(:amqp => "amqp://guest:guest@localhost:5672")
  end
  def channel
    @channel ||= ConnectionPool.new do
      connection.create_channel
    end
  end
end
