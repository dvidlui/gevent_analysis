module TimeRangeHelper
  # Checks 2 time ranges intersect
  def ranges_overlap?(a, b)
    a.cover?(b.begin) || b.cover?(a.begin)
  end

  # Combines 2 overlapping time ranges
  def merge_ranges(a, b)
    [a.begin, b.begin].min..[a.end, b.end].max
  end

  # Combines overlapping time ranges
  def merge_overlapping_ranges(ranges)
    ranges.sort_by(&:begin).inject([]) do |ranges, range|
      if !ranges.empty? && ranges_overlap?(ranges.last, range)
        ranges[0...-1] + [merge_ranges(ranges.last, range)]
      else
        ranges + [range]
      end
    end
  end

  # Intersects 2 overlapping time ranges
  def intersect_ranges(a, b)
    return nil if (a.max < b.begin or b.max < a.begin) 
    [a.begin, b.begin].max..[a.max, b.max].min
  end

  # Gets time differences in hours (for DateTime variables)
  def time_span_in_DHMS (time1, time2)
    days, remaining = (time1.to_i - time2.to_i).abs.divmod(86400)
    hours, remaining = remaining.divmod(3600)
    minutes, seconds = remaining.divmod(60)
    [days, hours, minutes, seconds]
  end

end