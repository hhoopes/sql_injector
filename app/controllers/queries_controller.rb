class QueriesController < ApplicationController
  def index 
    payload = query_params
    if payload[:query_action].present?
      begin
      query_type = Queries.detect {|q| q[:action] == payload[:query_action].to_sym }
      payload[query_type[:input][:name]] = payload[:sql_string]
      
      @results = eval(query_type[:query])
      rescue StandardError => e
            @error = e
      end
    end
    if query_type
      @sql_string = query_type[:sql].gsub("'REPLACE'", payload[:sql_string])
      @previous_params = payload
    end
    @queries = Queries
  end

  private

  def query_params
    params.permit(:query_action, :sql_string)
  end
end