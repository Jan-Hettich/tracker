class ListCollection

  def initialize page: 1, page_size: 25
    @page = page
    @page_size = page_size
    @errors = []
  end

  def call
    [response, errors]
  end

  def collection_type
    fail NotImplementedError,
         'Please override in subclass, return a symbol representing the type of item in the collection'
  end

  def collection
    fail NotImplementedError,
         'Please override in subclass, return an active relation of results'
  end

  def result_serializer
    fail NotImplementedError,
         'Please override in subclass, return the serialzier class'
  end

  private

  def response
    {
      collection_type => serialized_collection,
      count: pager.total_count,
      current_page_number: pager.page,
      total_page_count: pager.total_page_count
    }
  rescue StandardError => e
    errors.push e.message
    nil
  end

  def pager
    @pager ||= Pager.new collection, page, page_size
  end

  def serialized_collection
    pager.results.map { |result| result_serializer.new(result).attributes }
  end

  attr_reader :page, :page_size, :errors

end
