module V1
  class ProjectsController < ApplicationController
    swagger_controller :projects, 'Projects'

    swagger_api :index do
      summary 'List all projects'
      notes 'This lists all the active projects'
      param :query, :page, :integer, :optional, 'Page number of results, default 1'
      param :query, :page_size, :integer, :optional, 'Number of results per page, default 25'
    end
    def index
      projects, errors = ListProjects.new(index_params).call
      if errors.any?
        render json: { errors: errors }, status: 400
      else
        render json: projects
      end
    end

    swagger_api :show do
      summary 'Fetch a single project'
      param :path, :id, :string, :required, 'Project id'
    end
    def show
      project = Project.find_by params[:id]
      if project.present?
        render json: project
      else
        render json: { errors: ['Project not found'] }, status: 404
      end
    end

    swagger_api :create do
      summary 'Creates a new Project'
      param :form, :name, :string, :required, 'Project designation'
      param :form, :description, :string, :optional, 'Project description'
    end
    def create
      project = Project.new project_params
      if project.save
        render json: project, status: 201
      else
        render json: { errors: project.errors.full_messages }, status: 400
      end
    end

    swagger_api :update do
      summary 'Updates an existing Project'
      param :path, :id, :string, :required, 'Project id'
      param :form, :name, :string, :optional, 'Project designation'
      param :form, :description, :string, :optional, 'Project description'
    end
    def update
      project = Project.find_by params[:id]
      if project.present? && project.update_attributes(project_params)
        render json: project
      elsif project.present?
        render json: { errors: project.errors.full_messages }, status: 400
      else
        render json: { errors: ['Project not found'] }, status: 404
      end
    end

    swagger_api :destroy do
      summary 'Deletes an existing project'
      param :path, :id, :string, :required, 'Project id'
    end
    def destroy
      project = Project.find_by params[:id]
      if project.present? && project.update_attributes(state: :disabled)
        render json: project
      elsif project.present?
        render json: { errors: project.errors.full_messages }, status: 400
      else
        render json: { errors: ['Project not found'] }, status: 404
      end
    end

    private

    def index_params
      params.permit(:page, :page_size).to_h.symbolize_keys
    end

    def project_params
      params.require(:project).permit :name, :description
    end
  end
end
