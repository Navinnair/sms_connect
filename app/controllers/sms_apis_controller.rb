class SmsApisController < ApplicationController
  before_action :set_and_validate_sms

  def inbound
    render_json(200, '', 'inbound sms ok') if @sms.process_inbound
  end

  def outbound
    render_json(200, '', 'outbound sms ok') if @sms.process_outbound
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
    sms_service.validate_params
  end

end
