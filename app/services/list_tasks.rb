class ListTasks < ListCollection

  attr_defaultable :task_repository, -> { Task }
  attr_defaultable :result_serializer, -> { V1::TaskSerializer }

  def initialize params
  	super(params.slice(:page, :page_size))
  	@project_id = params[:project_id]
  end

  def collection_type
    :tasks
  end

  def collection
    @tasks ||= task_repository.where(project_id: @project_id)
  end

end