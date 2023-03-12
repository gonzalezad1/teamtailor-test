class CandidatesController < ApplicationController


    def download_csv
        # Fetch candidate data from Teamtailor API
        candidates, included_job_applications = Candidate.fetch_candidates_with_job_applications
        # Convert data to CSV format and Download CSV
        csv_data = Candidate.generate_csv(candidates,included_job_applications )
        send_data csv_data, filename: 'candidates_data.csv', disposition: 'attachment'
    end
end
