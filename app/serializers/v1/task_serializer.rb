module V1
  class TaskSerializer < ActiveModel::Serializer

  	belongs_to :project
    attributes :id, :project_id, :name, :description, :state

  end
end