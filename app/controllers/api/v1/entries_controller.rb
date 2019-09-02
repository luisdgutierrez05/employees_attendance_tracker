# frozen_string_literal: true

module Api
  module V1
    # Handles Entry resources
    class EntriesController < ApiController
      before_action :find_entry, except: %i[index create]

      # GET /entries
      # Displays all entries
      # @returns [Hash] list of entries.
      def index
        entries = FilterEntriesService.new(query_params).perform
        json_response(entries, :ok, pagination_details(entries))
      end

      # POST /entries
      # Creates a new Entry.
      # @returns [Hash] Entry information created.
      def create
        new_entry = Entry.create!(entry_params)
        json_response(new_entry, :created)
      end

      # PUT /entries/{:id}
      # Updates current entry.
      # @returns [Hash] Entry information updated.
      def update
        @entry.update!(entry_params)
        json_response(@entry)
      end

      # GET /entries/{:id}
      # Display Entry information by Id
      # @returns [Hash] Entry information found.
      def show
        json_response(@entry, :ok)
      end

      # DELETE /entries/{:id}
      # Deletes a Entry by Id.
      # @returns no content.
      def destroy
        @entry.destroy
      end

      private

      # Gets Entry attributes from request parameters.
      # @returns [Hash] the Entry parameters.
      def entry_params
        params.require(:data)
              .require(:attributes)
              .permit(:checkin_at, :checkout_at, :user_id, :observation)
      end

      # Finds Entry by Id
      # @returns [Hash] Entry details.
      # raises an ActiveRecord::RecordNotFound exception if Entry is not found.
      def find_entry
        @entry = Entry.find(params[:id])
      end

      # Gets query parameters only.
      # @returns [Hash] query parameters.
      def query_params
        request.query_parameters
      end
    end
  end
end
