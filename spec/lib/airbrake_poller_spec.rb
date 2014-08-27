require 'spec_helper'
require 'airbrake_poller'

describe AirbrakePoller do

  describe "#initialize" do
    it "set up Airbrake connection" do
      expect_any_instance_of(AirbrakePoller).to receive(:connect)
      AirbrakePoller.new
    end
  end

  describe "#get_five_most_recent_errors" do
    it "retrieves the first page of errors for CaptureApi project" do
      allow(subject.class).to receive(:select_first_five)
      expect(AirbrakeAPI).to receive(:errors).with(:page => 1, :project_id => 85939)
      subject.get_five_most_recent_errors
    end

    it "selects first five errors" do
      errors = double('first page of errors')
      allow(AirbrakeAPI).to receive(:errors).and_return(errors)
      expect(subject.class).to receive(:select_first_five).with(errors)
      subject.get_five_most_recent_errors
    end

    it "returns the previously selected first five errors" do
      allow(AirbrakeAPI).to receive(:errors)
      errors = double("first five errors")
      allow(subject.class).to receive(:select_first_five).and_return(errors)
      expect(subject.get_five_most_recent_errors).to eq(errors)
    end
  end

  describe "#get_five_most_frequent_errors" do
    it "retrieves all pages of errors for CaptureApi project" do
      expect(subject).to receive(:get_all_errors)
      allow(subject.class).to receive(:sort_errors_by_notices_count_in_descending_order)
      allow(subject.class).to receive(:select_first_five)
      subject.get_five_most_frequent_errors
    end

    it "sorts errors by notices count in descending order" do
      errors = double('all errors')
      allow(subject).to receive(:get_all_errors).and_return(errors)
      allow(subject.class).to receive(:select_first_five)
      expect(subject.class).to receive(:sort_errors_by_notices_count_in_descending_order).with(errors)
      subject.get_five_most_frequent_errors
    end

    it "selects first five errors from previously sorted errors" do
      errors_descending_order = double('all errors in descending order')
      allow(subject).to receive(:get_all_errors)
      allow(subject.class).to receive(:sort_errors_by_notices_count_in_descending_order).and_return(errors_descending_order)
      expect(subject.class).to receive(:select_first_five).with(errors_descending_order)
      subject.get_five_most_frequent_errors
    end

    it "returns previously selected first five errors" do
      errors = double('first five sorted errors')
      allow(subject).to receive(:get_all_errors)
      allow(subject.class).to receive(:sort_errors_by_notices_count_in_descending_order)
      allow(subject.class).to receive(:select_first_five).and_return(errors)
      expect(subject.get_five_most_frequent_errors).to eq(errors)
    end
  end

  describe ".select_first_five" do
    context "Arguement is iterable" do
      it "selects the first five elements of a given array" do
        errors = double("first page of errors")
        expect(errors).to receive(:first).with(5)
        subject.class.select_first_five errors
      end

      it "returns the previously selected 5 elements" do
        errors = double("first page of errors")
        five_errors = double('selected five elements')
        allow(errors).to receive(:first).and_return(five_errors)
        expect(subject.class.select_first_five(errors)).to eq(five_errors)
      end
    end

    context "Arguement is not iterable" do
      it "raises an Arguement Exception" do
        expect { subject.class.select_first_five nil }.to raise_error
      end
    end
  end

  describe ".sort_errors_by_notices_count_in_descending_order" do
    it "sorts a collection in descending order" do
      Error = Struct.new(:notices_count)
      errors = [Error.new(4), Error.new(5), Error.new(2), Error.new(1), Error.new(9), Error.new(8)]
      expect(subject.class.sort_errors_by_notices_count_in_descending_order(errors)).to eq([errors[4], errors[5], errors[1], errors[0], errors[2], errors[3]])
    end
  end

  describe "#connect" do
    it "establishes a connection to Airbrake" do
      subject # constructor calls connect()
      expect(AirbrakeAPI).to receive(:configure).with(:account => 'realpractice', :secure => true, :auth_token => anything)
      subject.send :connect
    end
  end

  describe "#get_all_errors" do
    it "retreives all pages containing data for CaptureApi project" do
      expect(AirbrakeAPI).to receive(:errors).with(:page => 1, :project_id => 85939).and_return([2])
      expect(AirbrakeAPI).to receive(:errors).with(:page => 2, :project_id => 85939).and_return([3])
      expect(AirbrakeAPI).to receive(:errors).with(:page => 3, :project_id => 85939).and_return([4])
      expect(AirbrakeAPI).to receive(:errors).with(:page => 4, :project_id => 85939).and_return([])
      expect(AirbrakeAPI).not_to receive(:errors).with(:page => 5, :project_id => 85939)
      subject.send :get_all_errors
    end

    it "returns all errors retrieved" do
      all_errors = [1, 2, 3, 4, 5]
      page_1_errors = [1, 2]
      page_2_errors = [3]
      page_3_errors = [4, 5]
      page_4_errors = []
      allow(AirbrakeAPI).to receive(:errors).and_return(page_1_errors, page_2_errors, page_3_errors, page_4_errors)
      expect(subject.send(:get_all_errors)).to eq(all_errors)
    end
  end

end
