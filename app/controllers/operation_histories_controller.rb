class OperationHistoriesController < ApplicationController
  # GET /operation_histories
  def index
    @operation_histories = OperationHistory.where(user: current_user).order('created_at DESC')
  end
end
