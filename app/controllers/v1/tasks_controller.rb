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

	    def create
	      task = Task.new create_params
	      if task.save
	        render json: task, status: 201
	      else
	        render json: { errors: task.errors.full_messages }, status: 400
	      end
	    end

	    def show
      	task = Task.where(id: params[:id]).first
	      if task.present?
	        render json: TaskSerializer.new(task).attributes, status: 200
	      else
	        render json: { errors: ['Task not found'] }, status: 404
	      end
	    end

	    def index_params
	      params.permit(:page, :page_size, :project_id).to_h.symbolize_keys
	    end

	    def create_params
	    	params.require(:task).permit(:project_id, :name, :description, :state).to_h.symbolize_keys
	    end

	    def task_params
	      params.require(:task).permit :name, :description, :state
	    end

	end

end