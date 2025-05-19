module Api
  module V1
    class BaseController < ActionController::API
      include ActionController::MimeResponds
      include ActionController::ImplicitRender

      before_action :authenticate_user!

      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity

      private

      def not_found(exception)
        render json: { error: "Resource not found: #{exception.message}" }, status: :not_found
      end

      def unprocessable_entity(exception)
        render json: { error: "Validation failed: #{exception.message}" }, status: :unprocessable_entity
      end
    end
  end
end
