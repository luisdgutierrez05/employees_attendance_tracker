# frozen_string_literal: true

module Api
  module V1
    # Handles User resources
    class UsersController < ApiController
      before_action :find_user, except: %i[index create]

      # GET /users
      # Displays all employees
      # @returns [Hash] list of employees.
      def index
        employees = User.employees.paginate(page: params[:page])
        json_response(employees, :ok, pagination_details(employees))
      end

      # POST /users
      # Creates a new User and his authentication token.
      # @returns [Hash] User information created.
      def create
        new_user = User.create!(user_params)
        json_response(new_user, :created)
      end

      # PUT /users/{:id}
      # Updates current user.
      # @returns [Hash] User information updated.
      def update
        @user.update!(user_params)
        json_response(@user)
      end

      # DELETE /users/{:id}
      # Deletes a User by Id.
      # @returns
      def destroy
        @user.destroy
      end

      # GET /users/{:id}
      # Display User information by Id
      # @returns [Hash] User information found.
      def show
        json_response(@user, :ok)
      end

      private

      # Gets user attributes from request parameters.
      # @return [Hash] the user parameters.
      def user_params
        params.require(:data)
              .require(:attributes)
              .permit(:first_name, :last_name, :email, :dni, :phone_number,
                      :start_date, :end_date, :date_of_birth, :position,
                      :address, :password, :password_confirmation)
      end

      # Finds User by Id
      # @returns [Hash] User details.
      # raises an ActiveRecord::RecordNotFound exception if User is not found.
      def find_user
        @user = User.find(params[:id])
      end
    end
  end
end
