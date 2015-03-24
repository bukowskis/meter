ActiveSupport::Notifications.subscribe /process_action.action_controller/ do |*args|
  event       = ActiveSupport::Notifications::Event.new(*args)
  payload     = event.payload
  controller  = payload[:controller]
  action      = payload[:action]
  format      = payload[:format] || 'all'
  format      = "all" if format == "*/*"
  http_status = payload[:status]

  total_duration = event.duration.to_i

  meter_tags = {
    controller:  controller,
    format:      format,
    method:      payload[:method],
    http_status: http_status
  }

  meter_data = {
    action:      action,
    path:        payload[:path],
    params:      payload[:params].to_query,
    user_id:     payload[:user].to_s,
    duration:    total_duration
  }

  instrumented_layers = {
    db_runtime:            :db_duration,
    view_runtime:          :view_duration,
    elasticsearch_runtime: :elasticsearch_duration
  }

  instrumented_layers.each do |layer, tag_value|
    next unless payload.has_key? layer
    duration = payload[layer].to_i
    meter_data[tag_value] = duration
    Meter.timing("request.layer_duration", duration, tags: meter_tags.merge(layer: tag_value))
  end

  Meter.timing "request.total_duration", total_duration, tags: meter_tags
  Meter.track  "requests", tags: meter_tags, data: meter_data
end
