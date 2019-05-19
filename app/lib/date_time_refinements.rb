# frozen_string_literal: true

require 'date'

module DateTimeRefinements
  refine DateTime.singleton_class do
    def try_parse(date_time_string)
      DateTime.parse(date_time_string)
    rescue ArgumentError, TypeError
      nil
    end
  end
end
