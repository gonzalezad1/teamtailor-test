class Candidate < ApplicationRecord

    require 'csv'
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

    def slef.generate_csv(candidates, included_job_applications)
        csv_string = CSV.generate do |csv|
            csv << ['candidate_id', 'first_name', 'last_name', 'email', 'job_application_id', 'job_application_created_at']
            candidates.each do |candidate|
                candidate_id = candidate[:id]
                first_name = candidate[:attributes][:'first-name']
                last_name = candidate[:attributes][:'last-name']
                email = candidate[:attributes][:email]
            
                candidate[:relationships][:'job-applications'][:data].each do |application|
                    job_application_id = application[:id]
                    job_application_created_at = included_job_applications.find { |obj| obj[:id] == job_application_id }[:attributes][:'created-at']
            
                    csv << [candidate_id, first_name, last_name, email, job_application_id, job_application_created_at]
                end
            end
        end
        csv_string
    end
end
