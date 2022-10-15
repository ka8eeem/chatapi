#https://github.com/elastic/elasticsearch-rails
#https://app.pluralsight.com/guides/elasticsearch-with-ruby-on-rails
# https://github.com/elastic/elasticsearch-rails/tree/main/elasticsearch-model

Elasticsearch::Client.new log: true, host: ENV['ELASTIC_HOST'], retry_on_failure: true
