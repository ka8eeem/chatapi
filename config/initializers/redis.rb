$redis = Redis::Namespace.new("chatapi",
                              :redis => Redis.new(
                                host: ENV['REDIS_HOST'],
                                port: '6379',
                                db:   '0'))
