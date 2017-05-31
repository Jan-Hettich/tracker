class ListTasks < ListCollection

  attr_defaultable :task_respository, -> { Task }
  attr_defaultable :result_serializer, -> { V1::TaskSerializer }

  def initialize params
  	@params = params
  end

  def collection_type
    :tasks
  end

  def collection
    @tasks ||= task_respository.where(@params)
  end

end