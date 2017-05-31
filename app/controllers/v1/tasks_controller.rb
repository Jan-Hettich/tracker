module V1

	class TasksController < ApplicationController

	    def index
	      tasks, errors = ListTasks.new(index_params).call
	      if errors.any?
	      	render json: { errors: errors }, status: 400
	      else
	        render json: tasks
	      end
	    end

	    def index_params
	      params.permit(:page, :page_size, :project_id).to_h.symbolize_keys
	    end

	    def task_params
	      params.permit(:task).permit :name, :description
	    end

	end

end