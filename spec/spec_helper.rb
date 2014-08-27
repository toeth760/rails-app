# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'webmock/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec do |c|
    c.syntax = :expect
  end
end

# This is a nice little helper method I added to help with performance tests.
# The basic use is as follows:
#
# all test setup
# ...
# ...
# results = benchmark do
#   trigger action you want to time (eg: post :visits)
# end
# results[:mean].should be <= your time restriction
#
# Optionally the you can specify a number of samples other than the default
# (100) or if you want garbage collection disabled for the benchmark run.
#
def benchmark(number_of_samples = 100, disable_garbage_collection = false, &blk)
  elapsed_realtime = nil
  begin
    sum_of_samples = 0
    samples = []
    sample_variance_sum = 0
    if disable_garbage_collection
      GC.start
      GC.disable
    end
    5.times { blk.call } # call 5 times to get rid of caching weirdness
    number_of_samples.times do
      elapsed_realtime = Benchmark.realtime { blk.call }
      sum_of_samples += elapsed_realtime
      samples << elapsed_realtime
    end
    if disable_garbage_collection
      GC.enable
      GC.start
    end

    # Compute the mean
    mean = sum_of_samples/number_of_samples.to_f
    # Compute the sample variance
    samples.each do |s|
      sample_variance_sum += (s-mean)**2
    end
    sample_variance = sample_variance_sum/number_of_samples.to_f
    # Compute the standard deviation
    standard_deviation = Math.sqrt(sample_variance)

    return { :mean => mean, :variance => sample_variance, :standard_deviation => standard_deviation, :average_calls_per_second => 1.0/mean }
  rescue Exception => e
    GC.enable
    raise e
  end
end

def http_basic_login(username = nil, password = nil)
  if username == nil
    user = 'admin'
  else
    user = username
  end
  if password == nil
    pw = 'nimda'
  else
    pw = password
  end
  request.env['HTTP_AUTHORIZATION'] =
    ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
end
