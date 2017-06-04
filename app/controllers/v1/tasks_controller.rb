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

    def update
      task, errors = UpdateTask.new(params[:id], task_params).call
      if task.present?
        render json: task, status: 200
      else
        status =  errors.any? { |e| e =~ /not found/i } ? 404 : 400
        render json: { errors: errors}, status: status
      end
    end

    def show
      task, errors = GetTask.new(params[:id]).call
      if task.present?
        render json: task
      else
        status =  errors.any? { |e| e =~ /not found/i } ? 404 : 400
        render json: { errors: errors}, status: status
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
