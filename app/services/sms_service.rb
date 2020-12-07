class SmsService

  attr_accessor :params

  def initialize(params)
    @from = params[:from]
    @to = params[:to]
    @text = params[:text]
    @current_user = SmsConnect.present_user
  end

  def validate_params
    %w[from to text].each do |key|
      raise SmsConnect::ApiError, "#{key} is missing" unless instance_variable_get("@#{key}").present? # validate key presence
      raise SmsConnect::ApiError, "#{key} is invalid" unless validate_length(key).present? # validate string length for the keys
    end
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
    verify_to_param_existence
    text_validation_and_cache
  end

  def verify_to_param_existence
    raise SmsConnect::ApiError, "to parameter not found" unless @current_user.to_param_records(@to).present?
  end

  def text_validation_and_cache
    cache_record if stop_text?
    true
  end

  def stop_text?
    stop_text_array.include?(@text)
  end

  def stop_text_array
    %w[STOP STOP\n STOP\r STOP\r\n]
  end

  def cache_record
    Rails.cache.write("block_#{@from}_#{@to}", expires_in: 4.hours)
  end

end