# Resources:
# https://www.monterail.com/blog/2014/event-sourcing-on-rails-with-rabbitmq
# https://medium.com/swlh/using-rabbitmq-with-rails-to-communicate-different-microservices-253505b92d49
# https://github.com/mperham/connection_pool

class Publisher
  # In order to publish message we need a exchange name.
  # Note that RabbitMQ does not care about the payload -
  # we will be using JSON-encoded strings

  # using the Direct Message queue routing style to differentiate between the 3 APIs
  # we are using connection Pool to singleton and lazy initialize the bunny connection
  def self.publish(exchangeName, message = {})
    RabbitConnection.instance.channel.with do |channel|
      exchange = channel.direct(exchangeName)
      channel.queue(exchangeName, durable: true).tap do |q|
        q.bind(exchangeName)
      end
      exchange.publish(message)
    end
  end
end