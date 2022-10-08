#https://github.com/elastic/elasticsearch-rails
#https://app.pluralsight.com/guides/elasticsearch-with-ruby-on-rails
# https://github.com/elastic/elasticsearch-rails/tree/main/elasticsearch-model

Elasticsearch::Model.client = Elasticsearch::Client.new log: true, host: 'http://elastic:changeme@localhost:9200'
