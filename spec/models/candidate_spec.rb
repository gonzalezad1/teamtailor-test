require 'rails_helper'

RSpec.describe Candidate, type: :model do
    
  it 'returns an array of candidates and job applications' do
    candidates, included_job_applications = Candidate.fetch_candidates_with_job_applications
    expect(candidates).to be_an(Array)
    expect(included_job_applications).to be_an(Array)
  end

  it 'returns job applications included with each candidate' do
    candidates, included_job_applications = Candidate.fetch_candidates_with_job_applications
    job_application_ids = included_job_applications.map { |app| app['id'] }
    candidates.each do |candidate|
      if candidate.dig('relationships', 'job-applications', 'data')
        candidate['relationships']['job-applications']['data'].each do |application|
          expect(job_application_ids).to include(application['id'])
        end
      end
    end
  end

  describe "#generate_csv" do  
    let(:candidates_data) do
      [
        {
          "id": "33950872",
          "type": "candidates",
          "links": {
              "self": "https://api.teamtailor.com/v1/candidates/33950872"
          },
          "attributes": {
              "connected": true,
              "created-at": "2022-09-08T11:33:21.540+02:00",
              "email": "ronnie_jerde+demo@example.net",
              "first-name": "Ronnie",
              "internal": false,
              "last-name": "Jerde",
              "original-resume": "https://teamtailor-production.s3.eu-west-1.amazonaws.com/resumes/3a52bd61a8c7a6b5793cb7d4f43ad80a4107853f.pdf?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAY6ECVO3IDA4YWK6D%2F20230310%2Feu-west-1%2Fs3%2Faws4_request&X-Amz-Date=20230310T143539Z&X-Amz-Expires=30&X-Amz-SignedHeaders=host&X-Amz-Signature=67b1002a2d0bb5ba3a40e3ce025fb53b37c5bda6b101983f048eb0eadd30456f",
              "phone": "+68711222926679",
              "referred": false,
              "resume": "https://teamtailor-production.s3.eu-west-1.amazonaws.com/resumes/3a52bd61a8c7a6b5793cb7d4f43ad80a4107853f.pdf?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAY6ECVO3IDA4YWK6D%2F20230310%2Feu-west-1%2Fs3%2Faws4_request&X-Amz-Date=20230310T143539Z&X-Amz-Expires=30&X-Amz-SignedHeaders=host&X-Amz-Signature=67b1002a2d0bb5ba3a40e3ce025fb53b37c5bda6b101983f048eb0eadd30456f",
              "sourced": false,
              "unsubscribed": false,
              "updated-at": "2022-09-08T11:34:36.661+02:00",
              "tags": []
          },
          "relationships": {
            "activities": {
                "links": {
                    "self": "https://api.teamtailor.com/v1/candidates/33950872/relationships/activities",
                    "related": "https://api.teamtailor.com/v1/candidates/33950872/activities"
                }
            },
            "department": {
                "links": {
                    "self": "https://api.teamtailor.com/v1/candidates/33950872/relationships/department",
                    "related": "https://api.teamtailor.com/v1/candidates/33950872/department"
                }
            },
            "role": {
                "links": {
                    "self": "https://api.teamtailor.com/v1/candidates/33950872/relationships/role",
                    "related": "https://api.teamtailor.com/v1/candidates/33950872/role"
                }
            },
            "regions": {
                "links": {
                    "self": "https://api.teamtailor.com/v1/candidates/33950872/relationships/regions",
                    "related": "https://api.teamtailor.com/v1/candidates/33950872/regions"
                }
            },
            "job-applications": {
                "links": {
                    "self": "https://api.teamtailor.com/v1/candidates/33950872/relationships/job-applications",
                    "related": "https://api.teamtailor.com/v1/candidates/33950872/job-applications"
                },
                "data": [
                    {
                        "type": "job-applications",
                        "id": "38269593"
                    }
                ]
            },
            "questions": {
                "links": {
                    "self": "https://api.teamtailor.com/v1/candidates/33950872/relationships/questions",
                    "related": "https://api.teamtailor.com/v1/candidates/33950872/questions"
                }
            },
            "answers": {
                "links": {
                    "self": "https://api.teamtailor.com/v1/candidates/33950872/relationships/answers",
                    "related": "https://api.teamtailor.com/v1/candidates/33950872/answers"
                }
            },
            "locations": {
                "links": {
                    "self": "https://api.teamtailor.com/v1/candidates/33950872/relationships/locations",
                    "related": "https://api.teamtailor.com/v1/candidates/33950872/locations"
                }
            },
            "uploads": {
                "links": {
                    "self": "https://api.teamtailor.com/v1/candidates/33950872/relationships/uploads",
                    "related": "https://api.teamtailor.com/v1/candidates/33950872/uploads"
                }
            },
            "custom-field-values": {
                "links": {
                    "self": "https://api.teamtailor.com/v1/candidates/33950872/relationships/custom-field-values",
                    "related": "https://api.teamtailor.com/v1/candidates/33950872/custom-field-values"
                }
            },
            "partner-results": {
                "links": {
                    "self": "https://api.teamtailor.com/v1/candidates/33950872/relationships/partner-results",
                    "related": "https://api.teamtailor.com/v1/candidates/33950872/partner-results"
                }
            }
          }
        }  
      ]
    end



    let(:included_job_applications) do
      [
        {
            "id": "38269593",
            "type": "job-applications",
            "links": {
                "self": "https://api.teamtailor.com/v1/job-applications/38269593"
            },
            "attributes": {
                "created-at": "2022-09-08T12:02:37.900+02:00"
            }
        }
      ]
    end


    it 'returns a string in CSV format' do
      csv_string = Candidate.generate_csv(candidates_data,included_job_applications)
      expect(csv_string).to be_a(String)
      expect(csv_string.lines.count).to eq(candidates_data.count + 1)
    end

    it 'contains the expected header and data rows' do
        csv_string = Candidate.generate_csv(candidates_data, included_job_applications)
        header_row = csv_string.lines.first.chomp
        data_rows = csv_string.lines.drop(1).map(&:chomp)

        expect(header_row).to eq('candidate_id,first_name,last_name,email,job_application_id,job_application_created_at')

        expect(data_rows).to contain_exactly(
          '33950872,Ronnie,Jerde,ronnie_jerde+demo@example.net,38269593,2022-09-08T12:02:37.900+02:00'
        )
    end
  end
end
