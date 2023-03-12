class Candidate < ApplicationRecord

    require 'dotenv/load'
    require 'httparty'

    API_VERSION = "20210218"

    def slef.fetch_candidates_with_job_applications
        candidates = []
        included_job_applications = []
        
        headers = {
            'Authorization' => "Bearer #{ENV['TEAMTAILOR_API_KEY']}",
            'X-Api-Version' => API_VERSION
        }

        # Define a recursif function to fetch candidates from a URL
        fetch_candidates = lambda do |url|
            response = HTTParty.get(url, headers: headers)
            json_response = JSON.parse(response.body, symbolize_names: true)
        
            candidates += json_response[:data]
            included_job_applications += json_response[:included].select { |obj| obj[:type] == 'job-applications' }
        
            next_url = json_response[:links][:next]
            fetch_candidates.call(next_url) if next_url
        end
        
        # Start by fetching the first page of candidate
        initial_url = 'https://api.teamtailor.com/v1/candidates?include=job-applications&fields[job-applications]=created-at'
        # Call the recursive function
        fetch_candidates.call(initial_url)
        
        return candidates, included_job_applications
    end
end
