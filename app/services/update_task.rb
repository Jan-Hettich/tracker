class UpdateTask

  attr_defaultable :task_repository, -> {Task}
  attr_defaultable :result_serializer, -> {V1::TaskSerializer}
  attr_defaultable :notification_provider, -> {NotifyUser}

  def initialize id, params
    @id = id
    @params = params
    @errors = []
  end

  def call
    [response, errors]
  end

  def response
    @original_attributes = serialize
    update
    notify
    @updated_attributes
  rescue StandardError => e
    errors.push e.message
    nil
  end

  def serialize
    result_serializer.new(task).attributes
  end

  def update
    task.update! @params
    @updated_attributes = serialize
  rescue
    task.reload
    raise
  end

  def task
    @task ||= task_repository.where(id: @id).first || raise( "Task not found: #{@id}" )
  end

  def notify
    notification_provider.new(message).call() if notification_required?
  rescue
    Rails.logger.warn "Unable to send update notification:\n#{message}"
  end

  def notification_required?
   (updated_attributes[:state] == "done") && (original_attributes[:state] != "done")
  end

  def message
    @message ||= "Task \"#{task.name}\" is #{updated_attributes[:state]}!"
  end

  attr_reader :errors
  attr_reader :original_attributes
  attr_reader :updated_attributes

end
