module V1
  class TaskSerializer < ActiveModel::Serializer

  	has_one :project
    attributes :id, :name, :description, :state

  end
end