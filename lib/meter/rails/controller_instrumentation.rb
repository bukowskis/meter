ActiveSupport::Notifications.subscribe /process_action.action_controller/ do |*args|
  event       = ActiveSupport::Notifications::Event.new(*args)
  payload     = event.payload
  controller  = payload[:controller]
  action      = payload[:action]
  format      = payload[:format] || 'all'
  format      = 'all' if format == '*/*'
  http_status = payload[:status]

  total_duration = event.duration.to_i

  meter_data = {
    controller:  controller,
    format:      format,
    method:      payload[:method],
    http_status: http_status,
    action:      action,
    path:        payload[:path],
    params:      payload[:params].to_query,
    duration:    total_duration
  }

  Meter.log 'requests', tags: meter_tags, data: meter_data
end
