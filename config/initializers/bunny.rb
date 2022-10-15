class RabbitConnection
  include Singleton
  attr_reader :connection
  def initialize
    @connection = Bunny.new("amqp://guest:guest@#{ENV['RABBITMQ_HOST']}")
    @connection.start

    Sneakers.configure(:amqp => "amqp://guest:guest@#{ENV['RABBITMQ_HOST']}")
  end
  def channel
    @channel ||= ConnectionPool.new do
      connection.create_channel
    end
  end
end
