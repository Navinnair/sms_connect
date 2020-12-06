# expose only two end points with post request. If any other HTTP method is sent to the API, return HTTP 405
module ActionDispatch
  class ExceptionWrapper
    def status_code
      if @exception.is_a? ActionController::RoutingError
        405
      end
    end
  end
end