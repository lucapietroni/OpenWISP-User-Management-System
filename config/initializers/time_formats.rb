Time::DATE_FORMATS[:month_and_year] = "%B %Y"
Time::DATE_FORMATS[:pretty] = lambda { |time| time.strftime("%a, %b %e %Y at %l:%M") + time.strftime("%p").downcase }
Time::DATE_FORMATS[:pretty_view] = lambda { |time| time.strftime("%a, %b %e %Y") }
Time::DATE_FORMATS[:month_day_and_year] = "%a, %b %e %Y"
Time::DATE_FORMATS[:year_month_day] = "%B %d %Y"
