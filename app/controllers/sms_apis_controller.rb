class SmsApisController < ApplicationController
  before_action :set_and_validate_sms

  def inbound

  end

  def outbound

  end

  private
  def sms_params
    params.permit(:from, :to, :text)
  end

  # set sms service
  def sms_service
    @sms ||= SmsService.new(sms_params)
  end

  # validate params for the sms service
  def set_and_validate_sms
    validate = sms_service.validate_params
    render_json(422, validate[1]) and return unless validate[0].present?
  end

end
