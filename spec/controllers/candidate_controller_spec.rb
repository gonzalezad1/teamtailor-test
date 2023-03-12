require 'rails_helper'
require 'spec_helper'
require 'httparty'
require 'csv'

RSpec.describe CandidatesController, type: :controller do
    describe "#download_csv" do
        it "returns a CSV file" do
            get :download_csv
            expect(response.content_type).to include('csv')
            expect(response.headers['Content-Disposition']).to include('attachment')
        end
    end
end