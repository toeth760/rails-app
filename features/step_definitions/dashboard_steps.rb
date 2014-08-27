When /^I visit the dashboard page as an admin$/ do
  api_key = "?api_key=#{RESQUEHEALTH_CONFIG['api_key']}"
  stub_request(:get, "http://66.150.153.19/capture_api/resque_health.json" + api_key).
    to_return(:status => 200, :body => '{"pending":0,"processed":0,"queues":0,"workers":0,"working":0,"failed":0,"servers":["redis://capture.services.dev:6379/0"],"environment":"development","queue_names":{}}', :headers => {})
  stub_request(:get, "http://66.150.153.19/capture_api/health.json" + api_key).
    to_return(:status => 200, :body => '{"dependencies":{"cassandra_connection":"OK","redis_connection":"OK","resque_workers":"WARN"},"version":"0.37.2"}', :headers => {})
  stub_request(:get, "http://65.97.51.19/capture_api/resque_health.json" + api_key).
    to_return(:status => 200, :body => '{"pending":0,"processed":0,"queues":0,"workers":0,"working":0,"failed":0,"servers":["redis://capture.services.dev:6379/0"],"environment":"development","queue_names":{}}', :headers => {})
  stub_request(:get, "http://65.97.51.19/capture_api/health.json" + api_key).
    to_return(:status => 200, :body => '{"dependencies":{"cassandra_connection":"OK","redis_connection":"OK","resque_workers":"WARN"},"version":"0.37.2"}', :headers => {})
  stub_request(:get, "https://realpractice.airbrake.io/projects/85939/groups.xml?auth_token=f456e6708f0cada0a1a12c3047c0da9434406929&page=1").
        to_return(:status => 200, :body => "<?xml version=\"1.0\" encoding=\"UTF-8\"?><nil-classes type=\"array\"/>", :headers => {})


  visit "http://admin:nimda@rlets-test.com:9887/dashboard/"
end

Then /^I should see the LAX Capture Resque module$/ do
  # Check if the DIV container exists.
  expect(page).to have_selector('div#lax-resque-container')

  # Check if the dashboard module is rendered.
  expect(page).to have_selector('div.lax-resque-module')
end

Then /^I should see the LAX capture_api health check module$/ do
  # Check if the DIV container exists.
  expect(page).to have_selector('div#lax-health-check-container')

  # Check if the dashboard module is rendered.
  expect(page).to have_selector('div.lax-health-check-module')
end

Then /^I should see the IAD Capture Resque module$/ do
  # Check if the DIV container exists.
  expect(page).to have_selector('div#iad-resque-container')

  # Check if the dashboard module is rendered.
  expect(page).to have_selector('div.iad-resque-module')
end

Then /^I should see the IAD capture_api health check module$/ do
  # Check if the DIV container exists.
  expect(page).to have_selector('div#iad-health-check-container')

  # Check if the dashboard module is rendered.
  expect(page).to have_selector('div.iad-health-check-module')
end

Then /^I should see the LAX health check dependencies$/ do
  expect(page).to have_selector('div#lax-health-check-container div#health-check-cassandra_connection-status')
  expect(page).to have_selector('div#lax-health-check-container div#health-check-redis_connection-status')
  expect(page).to have_selector('div#lax-health-check-container div#health-check-resque_workers-status')
end

Then /^I should see the IAD health check dependencies$/ do
  expect(page).to have_selector('div#iad-health-check-container div#health-check-cassandra_connection-status')
  expect(page).to have_selector('div#iad-health-check-container div#health-check-redis_connection-status')
  expect(page).to have_selector('div#iad-health-check-container div#health-check-resque_workers-status')
end

When /^I visit the dashboard page$/ do
  visit "http://rlets-test.com:9887/dashboard/"
end

Then /^the dashboard page request status should be (\d+)$/ do |arg1|
  expect(page.status_code.to_s()).to eq(arg1)
end

Then /^I should see the Capture Airbrake module$/ do
  sleep 5
  # Check if the DIV container exists.
  expect(page).to have_selector('div#airbrake-container')

  # Check if the dashboard module is rendered.
  expect(page).to have_selector('div.airbrake-module')
end

Then /^the Capture Airbrake should be updated at some interval$/ do
  date_str = page.find('.airbrake-last-updated-on').text
  interval_time = page.evaluate_script('airbrake.settings("updateInterval")')
  sleep interval_time
  expect(date_str).not_to eq(page.find('.airbrake-last-updated-on').text)
end

Then(/^I see the Capture Internal Reporting module$/) do
  sleep 5
  expect(page).to have_selector('#internal-reports-container')
end

Then(/^I see links to the internal reports$/) do
  report_module = page.find('#internal-reports-container')
  expect(report_module).to have_link('Events detail report')
  expect(report_module).to have_link('Visitor path report')
  expect(report_module).to have_link('Visitor path detail report')
  expect(report_module).to have_link('Site summary report')
  expect(report_module).to have_link('Attribution report')
end
