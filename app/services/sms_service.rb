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
      return [false, "#{key} is missing"] unless instance_variable_get("@#{key}").present? # validate key presence
      return [false, "#{key} is invalid"] unless validate_length(key).present? # validate string length for the keys
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

end