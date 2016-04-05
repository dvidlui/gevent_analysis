Rack::Timeout.timeout = 300  # seconds

# Unregistering the observer to disable the logging
Rack::Timeout.unregister_state_change_observer(:logger)