class SmsService

  attr_accessor :params

  def initialize(params)
    @from = params[:from]
    @to = params[:to]
    @text = params[:text]
    @current_user = SmsConnect.present_user
  end

  # basic params validations
  def validate_params
    %w[from to text].each do |key|
      raise SmsConnect::ApiError, "#{key} is missing" unless instance_variable(key).present? # validate key presence
      raise SmsConnect::ApiError, "#{key} is invalid" unless validate_length(key).present? # validate string length for the keys
    end
  end

  # make instance variable from key
  def instance_variable(key)
    instance_variable_get("@#{key}")
  end

  # validate string length for the keys
  def validate_length(key)
    if key == 'text'
      instance_variable_get("@#{key}").size.between?(1, 120)
    else
      instance_variable_get("@#{key}").size.between?(6, 16)
    end
  end

  def process_inbound
    verify_param_existence('to')
    text_validation_and_cache
    true
  end

  # check phone number record presence in the database as per the given parameter
  def verify_param_existence(key)
    raise SmsConnect::ApiError, "#{key} parameter not found" unless @current_user.phone_numbers_search(instance_variable(key)).present?
  end

  # if stop present in text then cache the record
  def text_validation_and_cache
    cache_record if stop_text?
  end

  # stop text presence check
  def stop_text?
    stop_text_array.include?(@text)
  end

  def stop_text_array
    %w[STOP STOP\n STOP\r STOP\r\n]
  end

  # cache the record with 4 hour validity
  def cache_record
    Rails.cache.write("block_#{@from}_#{@to}", expires_in: 4.hours)
  end

  def process_outbound
    verify_param_existence('from')
    outbound_cache_mechanism
    true
  end

  def outbound_cache_mechanism
    raise SmsConnect::ApiError, "sms from #{@from} to #{@to} blocked by STOP request" if blocked?
    cache_limit_check_and_count
  end

  # check stop cache presence for outbound sms
  def blocked?
    Rails.cache.exist?("block_#{@from}_#{@to}")
  end

  # do not allow more than 50 API requests using the same ‘from’ number in 24
  # hours from the first use of the ‘from’ number and reset counter after 24 hours. Return an
  # error in case of limit reached
  def cache_limit_check_and_count
    cache_key = "limit_counter_for_#{@from}"
    Rails.cache.write(cache_key, 1, raw: true, unless_exist: true, expires_in: 24.hours)
    count = Rails.cache.read(cache_key)
    if count.to_i > 50
      raise SmsConnect::ApiError, "limit reached for from #{@from}"
    end
    Rails.cache.increment(cache_key, 1)
  end

end