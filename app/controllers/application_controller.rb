class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  layout :determine_layout if respond_to? :layout

	before_action :set_notification

	def set_notification
	  request.env['exception_notifier.exception_data'] = { 'SlackExceptionBot' =>  'Greetings'}
	  raise "This is an exception"
	end

end
