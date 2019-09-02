# frozen_string_literal: true

module ReportsSpecHelper # :nodoc:
  # Generates 9 hours diff from now.
  def from_9_am
    (Time.now.hour - 9).hours
  end

  # Generates 18 hours diff from now.
  def till_18_pm
    (Time.now.hour - 18).hours
  end

  # Generates date time for checkin at current day.
  def checkin_at_today
    Time.now.ago(from_9_am)
  end

  # Generates date time for checkout at current day.
  def checkout_at_today
    Time.now.ago(till_18_pm)
  end

  # Generates date time for checkin at pas day.
  def checkin_at_yesterday
    Time.now.prev_day.ago((Time.now.prev_day.hour - 9).hours)
  end

  # Generates date time for checkout at past day.
  def checkout_at_yesterday
    Time.now.prev_day.ago((Time.now.prev_day.hour - 18).hours)
  end

  # Generates date time for checkin at last week.
  def checkin_at_last_week
    Time.now.ago(7.days).ago(from_9_am)
  end

  # Generates date time for checkout at last week.
  def checkout_at_last_week
    Time.now.ago(7.days).ago(till_18_pm)
  end

  # Generates date time for checkin at last month.
  def checkin_at_last_month
    Time.now.ago(1.month).ago(from_9_am)
  end

  # Generates date time for checkout at last month.
  def checkout_at_last_month
    Time.now.ago(1.month).ago(till_18_pm)
  end

  # Generates date time for checkin at last year.
  def checkin_at_last_year
    Time.now.ago(1.year).ago(from_9_am)
  end

  # Generates date time for checkout at last year.
  def checkout_at_last_year
    Time.now.ago(1.year).ago(till_18_pm)
  end
end
