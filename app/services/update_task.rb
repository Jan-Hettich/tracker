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
    update
    notify
    serialize
  rescue StandardError => e
    errors.push e.message
    nil
  end

  def serialize
    result_serializer.new(task).attributes
  end

  def update
    @original_state = task.state
    task.update! @params
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
   (task.state == "done") && (original_state != "done")
  end

  def message
    @message ||= "Task \"#{task.name}\" is #{task.state}!"
  end

  attr_reader :errors
  attr_reader :original_state

end
