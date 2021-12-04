require "json"
require "http/client"
require "toml"

module Treqs
  extend self
  VERSION = "0.1.0"

  record Req,
    url : String,
    method : String,
    # headers : Hash(String, String)?,
    # query_params : Hash(String, String),
    body : String?

  def read_file(filename)
    parsed = TOML.parse_file(filename)
    Req.new(
      parsed["url"].as(String),
      parsed["method"].as(String),
      parsed["body"].as(Hash(String, TOML::Type)).to_json
    )
  end

  def perform(req)
    HTTP::Client.exec(
      req.method,
      req.url,
      nil,
      req.body
    ).body
  end

end

include Treqs
puts perform(read_file(ARGV[0]))
