require "elasticsearch"

class ElasticSearchService
  def initialize
    faraday_client = Elastic::Transport::Transport::HTTP::Faraday.new(
      hosts: [
        {
          host: "localhost",
          port: "9200",
          user: "elastic",
          password: ENV["ELASTIC_PASSWORD"],
          scheme: "https"
        }
      ]
    )

    @client = Elasticsearch::Client.new transport_options: {ssl: {ca_file: "/etc/elasticsearch/certs/http_ca.crt"}}
    @client.transport = faraday_client
  end

  def create_index index_name, properties_json
    properties = JSON.parse(properties_json)

    response = @client.perform_request("PUT", "/#{index_name}", {}, {
                                         settings: {
                                           number_of_shards: 1,
                                           number_of_replicas: 0
                                         },
                                         mappings: {
                                           properties:
                                         }
                                       })

    response.body
  end

  def create_document index_name, object, id
    path = "/#{index_name}/_doc/#{id}"
    body = object.as_json
    response = @client.perform_request("POST", path, {}, body)

    response.body
  end

  def search index_name, query
    response = @client.perform_request("GET", "/#{index_name}/_search", {},
                                       query)

    response.body
  end
end
