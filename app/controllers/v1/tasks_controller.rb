module V1
  class TasksController < ApplicationController
    swagger_controller :tasks, 'Tasks'

    swagger_api :index do
      summary 'List all tasks'
      notes 'This lists all the tasks for the given project or for all projects'
      param :query, :project_id, :string, :optional, 'Id of project for which tasks will be listed'
      param :query, :page, :integer, :optional, 'Page number of results, default 1'
      param :query, :page_size, :integer, :optional, 'Number of results per page, default 25'
    end
    def index
      tasks, errors = ListTasks.new(index_params).call
      if errors.any?
        render json: { errors: errors }, status: 400
      else
        render json: tasks
      end
    end

    swagger_api :create do
      summary 'Creates a new task'
      notes 'This creates a new task for the given project (created in the todo state)'
      param :form, :project_id, :string, :required, 'Id of project for which task will be created'
      param :form, :name, :string, :required, 'Task designation'
      param :form, :description, :string, :required, 'Task description'
    end
    def create
      task = Task.new create_params
      if task.save
        render json: task, status: 201
      else
        render json: { errors: task.errors.full_messages }, status: 400
      end
    end

    swagger_api :update do
      summary 'Updates an existing task'
      param :path, :id, :string, :required, 'Task id'
      param :form, :name, :string, :optional, 'Task designation'
      param :form, :description, :string, :optional, 'Task description'
      param :form, :state, :integer, :optional, 'Task state'
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

    swagger_api :show do
      summary 'Fetch a single task'
      param :path, :id, :string, :required, 'Task id'
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
