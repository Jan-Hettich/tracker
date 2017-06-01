class GetTask

	attr_defaultable :task_repository, -> {Task}
	attr_defaultable :result_serializer, -> {V1::TaskSerializer}

	def initialize id
		@task_id = id
    @errors = []
	end

	def call
    [response, errors]
  end

  def response
      serialized_task
  	rescue StandardError => e
    	errors.push e.message
    	nil
  end

  def serialized_task
  	result_serializer.new(task).attributes
  end

  def task
  	task_repository.where(id: @task_id)
  end

  attr_reader :errors

end