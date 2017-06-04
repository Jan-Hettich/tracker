class UpdateTask

  attr_defaultable :task_repository, -> {Task}
  attr_defaultable :result_serializer, -> {V1::TaskSerializer}

  def initialize id, params
    @id = id
    @params = params
    @errors = []
  end

  def call
    [response, errors]
  end

  def response
    serialized_updated_task
  rescue StandardError => e
    errors.push e.message
    nil
  end

  def serialized_updated_task
    result_serializer.new(updated_task).attributes
  end

  def updated_task
    t = self.task
    t.update!(@params) && t
  rescue
    t.reload
    raise
  end

  def task
    task_repository.where(id: @id).first || raise( "Not found: Task #{@id}" )
  end

  attr_reader :errors

end
