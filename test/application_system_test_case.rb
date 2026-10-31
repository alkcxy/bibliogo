require "test_helper"
require "socket"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  if ENV["SELENIUM_REMOTE_URL"].present?
    Capybara.register_driver :remote_chrome do |app|
      Capybara::Selenium::Driver.new(app, browser: :chrome, url: ENV["SELENIUM_REMOTE_URL"])
    end

    Capybara.server_host = "0.0.0.0"
    Capybara.server_port = 3010
    own_ip = Socket.ip_address_list.find { |addr| addr.ipv4? && !addr.ipv4_loopback? }.ip_address
    remote_app_host = "http://#{own_ip}:#{Capybara.server_port}"

    driven_by :remote_chrome, using: nil, screen_size: [1400, 1400]

    # Rails resets Capybara.app_host to http://127.0.0.1 in before_setup,
    # which the remote browser would resolve inside its own container.
    define_method :before_setup do
      super()
      host! remote_app_host
    end
  else
    driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
  end
end
