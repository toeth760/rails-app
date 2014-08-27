module DashboardHelper
  def each_report_link
    INTERNAL_REPORTS['reports'].each do |report|
      yield report_link(report)
    end
  end

  def report_link(report)
    link_to(report.humanize, report_url(report), :target => "_new")
  end

  def report_url(report)
    "#{INTERNAL_REPORTS['host']}/internal_reporting/#{report}/new"
  end
end
