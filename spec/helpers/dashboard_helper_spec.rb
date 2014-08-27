require 'spec_helper'

describe DashboardHelper do
  subject { helper }

  let(:host) { double }
  let(:report1) { double }
  let(:report2) { double }

  before do
    stub_const('INTERNAL_REPORTS', {'host' => host, 'reports' => [report1, report2]})
  end

  describe '#each_report_link' do
    let(:link1) { double }
    let(:link2) { double }

    before do
      allow(subject).to receive(:report_link).with(report1) { link1 }
      allow(subject).to receive(:report_link).with(report2) { link2 }
    end

    it 'yields a link for each report' do
      expect {|b| subject.each_report_link(&b) }.to yield_successive_args(link1, link2)
    end
  end

  describe '#report_link' do
    let(:url) { double }
    let(:link_text) { double }

    before do
      allow(subject).to receive(:report_url).with(report1) { url }
      allow(report1).to receive(:humanize) { link_text }
    end

    it 'builds an anchor tag with new window target using the report name and url' do
      expect(subject).to receive(:link_to).with(link_text, url, { :target=>"_new" })
      subject.report_link(report1)
    end
  end

  describe '#report_url' do
    it 'builds the report url from the host and report name' do
      stub_const('INTERNAL_REPORTS', {'host' => 'http://capture.services.dev', 'reports' => []})
      report = Array('a'..'m').shuffle.join
      expect(subject.report_url(report)).to eq("http://capture.services.dev/internal_reporting/#{report}/new")
    end
  end
end
