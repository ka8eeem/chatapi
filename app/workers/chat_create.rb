# https://www.monterail.com/blog/2014/event-sourcing-on-rails-with-rabbitmq
class ChatCreateWorker
  include Sneakers::Worker
  # This worker will connect to "dashboard.posts" queue
  # env is set to nil since by default the actuall queue name would be
  # "dashboard.posts_development"
  from_queue "chatapi.chat"

  # work method receives message payload in raw format
  # in our case it is JSON encoded string
  # which we can pass to RecentPosts service without
  # changes
  def work(raw_post)
    ActiveRecord::Base.connection_pool.with_connection do
      raw_json = JSON.parse(raw_post)
      chat = Chat.new(raw_json)
      chat.save!
      puts chat
    end
    ack! # we need to let queue know that message was received
  end
end