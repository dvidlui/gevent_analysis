class EventAnalysis
  attr_accessor :source, :events, :participants, :meeting_times, :merged_times, :free_times, :results, :rule_titles, :text_results

  include TimeRangeHelper

  SAMPLE_EVENTS1 = [{:title=>"Archer Hotel", :creator=>{:name=>"Megan Foy", :email=>"megan.foy@nobl.io"}, 
  :start_date=>DateTime.parse("2015-12-13 15:00:00 +0000"), 
  :end_date=>DateTime.parse("2015-12-17 15:00:00 +0000"), 
  :attendees=>[]}, 
{:title=>"Flight to New York", :creator=>{:name=>"Megan Foy", :email=>"megan.foy@nobl.io"}, 
  :start_date=>DateTime.parse("2015-12-13 21:40:00 +0000"), 
  :end_date=>DateTime.parse("2015-12-14 03:00:00 +0000"), 
  :attendees=>[{:email=>"megan.foy@nobl.io", :name=>"Megan Foy"}]}, 
{:title=>"Bunch 12/6", :creator=>{:name=>"David Lui", :email=>"dvidlui@gmail.com"}, 
  :start_date=>DateTime.parse("2015-12-14 02:00:00 +0000"), 
  :end_date=>DateTime.parse("2015-12-14 02:30:00 +0000"), 
  :attendees=>[{:email=>"dvidlui@gmail.com", :name=>"David Lui"}, {:email=>"megan.foy@nobl.io", :name=>"Megan Foy"}]}, 
{:title=>"Weekly Planning Prep", :creator=>{:name=>"Megan Foy", :email=>"megan.foy@nobl.io"}, 
  :start_date=>DateTime.parse("2015-12-14 04:00:00 +0000"), 
  :end_date=>DateTime.parse("2015-12-14 04:30:00 +0000"), 
  :attendees=>[{:email=>"bud.caddell@nobl.io", :name=>nil}, {:email=>"paula.cizek@nobl.io", :name=>nil}, {:email=>"megan.foy@nobl.io", :name=>"Megan Foy"}, {:email=>"mark.eckhardt@nobl.io", :name=>nil}, {:email=>"lauren@nobl.io", :name=>nil}]}, 
{:title=>"Weekly Planning", :creator=>{:name=>"Megan Foy", :email=>"megan.foy@nobl.io"}, 
  :start_date=>DateTime.parse("2015-12-14 17:30:00 +0000"), 
  :end_date=>DateTime.parse("2015-12-14 18:30:00 +0000"), 
  :attendees=>[{:email=>"bud.caddell@nobl.io", :name=>"Bud Caddell"}, {:email=>"paula.cizek@nobl.io", :name=>"Paula Cizek"}, {:email=>"megan.foy@nobl.io", :name=>"Megan Foy"}, {:email=>"mark.eckhardt@nobl.io", :name=>"Mark Eckhardt"}, {:email=>"lauren@nobl.io", :name=>nil}, {:email=>"mark@common.is", :name=>"Mark Eckhardt"}]}, 
{:title=>"Bunch 12/7", :creator=>{:name=>"David Lui", :email=>"dvidlui@gmail.com"}, 
  :start_date=>DateTime.parse("2015-12-15 02:00:00 +0000"), 
  :end_date=>DateTime.parse("2015-12-15 02:30:00 +0000"), 
  :attendees=>[{:email=>"megan.foy@nobl.io", :name=>"Megan Foy"}, {:email=>"dvidlui@gmail.com", :name=>"David Lui"}]}, 
{:title=>"CK Align Event | Workshop Day I (8:00 am - 6:00 pm EST)", :creator=>{:name=>nil, :email=>"mark.eckhardt@nobl.io"}, 
  :start_date=>DateTime.parse("2015-12-15 13:00:00 +0000"), 
  :end_date=>DateTime.parse("2015-12-15 22:50:00 +0000"), 
  :attendees=>[{:email=>"jordan.husney@nobl.io", :name=>nil}, {:email=>"mark@common.is", :name=>"Mark Eckhardt"}, {:email=>"bree.groff@nobl.io", :name=>nil}, {:email=>"mark.eckhardt@nobl.io", :name=>nil}, {:email=>"bud.caddell@nobl.io", :name=>nil}, {:email=>"jason.spinell@nobl.io", :name=>nil}, {:email=>"megan.foy@nobl.io", :name=>"Megan Foy"}, {:email=>"jg@jefferygarland.com", :name=>nil}, {:email=>"athena.diaconis@nobl.io", :name=>nil}]}, 
{:title=>"Bunch 12/8", :creator=>{:name=>"David Lui", :email=>"dvidlui@gmail.com"}, 
  :start_date=>DateTime.parse("2015-12-16 02:00:00 +0000"), 
  :end_date=>DateTime.parse("2015-12-16 02:30:00 +0000"), 
  :attendees=>[{:email=>"megan.foy@nobl.io", :name=>"Megan Foy"}, {:email=>"dvidlui@gmail.com", :name=>"David Lui"}]}, 
{:title=>"CK Align Event | Workshop Day II (8:00 am - 4:00 pm EST)", :creator=>{:name=>nil, :email=>"mark.eckhardt@nobl.io"}, 
  :start_date=>DateTime.parse("2015-12-16 13:00:00 +0000"), 
  :end_date=>DateTime.parse("2015-12-16 20:50:00 +0000"), 
  :attendees=>[{:email=>"bud.caddell@nobl.io", :name=>nil}, {:email=>"athena.diaconis@nobl.io", :name=>nil}, {:email=>"jg@jefferygarland.com", :name=>nil}, {:email=>"megan.foy@nobl.io", :name=>"Megan Foy"}, {:email=>"jordan.husney@nobl.io", :name=>nil}, {:email=>"bree.groff@nobl.io", :name=>nil}, {:email=>"mark.eckhardt@nobl.io", :name=>nil}, {:email=>"jason.spinell@nobl.io", :name=>nil}, {:email=>"mark@common.is", :name=>"Mark Eckhardt"}]}, 
{:title=>"Michael <-> Meg", :creator=>{:name=>"Megan Foy", :email=>"megan.foy@nobl.io"}, 
  :start_date=>DateTime.parse("2015-12-16 17:30:00 +0000"), 
  :end_date=>DateTime.parse("2015-12-16 18:00:00 +0000"), 
  :attendees=>[{:email=>"michael@thatmichaelbrown.com", :name=>"Michael Brown"}]}, 
{:title=>"Bunch 12/9", :creator=>{:name=>"David Lui", :email=>"dvidlui@gmail.com"}, 
  :start_date=>DateTime.parse("2015-12-17 02:00:00 +0000"), 
  :end_date=>DateTime.parse("2015-12-17 02:30:00 +0000"), 
  :attendees=>[{:email=>"dvidlui@gmail.com", :name=>"David Lui"}, {:email=>"megan.foy@nobl.io", :name=>"Megan Foy"}]}, 
{:title=>"Flight to Los Angeles", :creator=>{:name=>"Megan Foy", :email=>"megan.foy@nobl.io"}, 
  :start_date=>DateTime.parse("2015-12-17 14:30:00 +0000"), 
  :end_date=>DateTime.parse("2015-12-17 20:55:00 +0000"), 
  :attendees=>[{:email=>"megan.foy@nobl.io", :name=>"Megan Foy"}]}, 
{:title=>"#scaledtodeath Retrospective", :creator=>{:name=>"Megan Foy", :email=>"megan.foy@nobl.io"}, 
  :start_date=>DateTime.parse("2015-12-17 19:00:00 +0000"), 
  :end_date=>DateTime.parse("2015-12-17 20:00:00 +0000"), 
  :attendees=>[{:email=>"bud.caddell@nobl.io", :name=>"Bud Caddell"}, {:email=>"paula.cizek@nobl.io", :name=>"Paula Cizek"}, {:email=>"megan.foy@nobl.io", :name=>"Megan Foy"}, {:email=>"mark.eckhardt@nobl.io", :name=>"Mark Eckhardt"}, {:email=>"lauren@nobl.io", :name=>nil}, {:email=>"mark@common.is", :name=>"Mark Eckhardt"}]}, 
{:title=>"Bunch 12/10", :creator=>{:name=>"David Lui", :email=>"dvidlui@gmail.com"}, 
  :start_date=>DateTime.parse("2015-12-18 02:00:00 +0000"), 
  :end_date=>DateTime.parse("2015-12-18 02:30:00 +0000"), 
  :attendees=>[{:email=>"dvidlui@gmail.com", :name=>"David Lui"}, {:email=>"megan.foy@nobl.io", :name=>"Megan Foy"}]}, 
{:title=>"Bunch Huddle", :creator=>{:name=>"Megan Foy", :email=>"megan.foy@nobl.io"}, 
  :start_date=>DateTime.parse("2015-12-18 16:30:00 +0000"), 
  :end_date=>DateTime.parse("2015-12-18 17:00:00 +0000"), 
  :attendees=>[{:email=>"bud.caddell@nobl.io", :name=>nil}, {:email=>"megan.foy@nobl.io", :name=>"Megan Foy"}, {:email=>"laurac3146@gmail.com", :name=>"Laura Carpenter"}, {:email=>"nick@nickstevens.com", :name=>"Nicholas Stevens"}]}, 
{:title=>"Add in your #s to the measurement dashboard", :creator=>{:name=>nil, :email=>"bud.caddell@nobl.io"}, 
  :start_date=>DateTime.parse("2015-12-18 17:00:00 +0000"), 
  :end_date=>DateTime.parse("2015-12-18 17:30:00 +0000"), 
  :attendees=>[{:email=>"lauren@nobl.io", :name=>"Lauren Brock"}, {:email=>"bud.caddell@nobl.io", :name=>nil}, {:email=>"paula.cizek@nobl.io", :name=>nil}, {:email=>"mark.eckhardt@nobl.io", :name=>nil}, {:email=>"megan.foy@nobl.io", :name=>"Megan Foy"}]}, 
{:title=>"NOBL update call w/Megan", :creator=>{:name=>"Katy Preston", :email=>"kpreston@hpccpa.com"}, 
  :start_date=>DateTime.parse("2015-12-18 17:00:00 +0000"), 
  :end_date=>DateTime.parse("2015-12-18 17:30:00 +0000"), 
  :attendees=>[{:email=>"megan.foy@nobl.io", :name=>"Megan Foy"}, {:email=>"kpreston@hpccpa.com", :name=>"Katy Preston"}]}, 
{:title=>"Closing Round", :creator=>{:name=>"Megan Foy", :email=>"megan.foy@nobl.io"}, 
  :start_date=>DateTime.parse("2015-12-18 17:30:00 +0000"), 
  :end_date=>DateTime.parse("2015-12-18 18:30:00 +0000"), 
  :attendees=>[{:email=>"bud.caddell@nobl.io", :name=>"Bud Caddell"}, {:email=>"paula.cizek@nobl.io", :name=>"Paula Cizek"}, {:email=>"megan.foy@nobl.io", :name=>"Megan Foy"}, {:email=>"mark.eckhardt@nobl.io", :name=>"Mark Eckhardt"}, {:email=>"lauren@nobl.io", :name=>nil}, {:email=>"mark@common.is", :name=>"Mark Eckhardt"}]}]

  SAMPLE_EVENTS2 = [{:title=>"Bunch 12/6",
  :creator=>{:name=>"David Lui", :email=>"dvidlui@gmail.com"},
  :start_date=>DateTime.parse("2015-12-14 10:00:00 +0800"),
  :end_date=>DateTime.parse("2015-12-14 10:30:00 +0800"),
  :attendees=>[{:email=>"megan.foy@nobl.io", :name=>"Megan Foy"}, {:email=>"dvidlui@gmail.com", :name=>"David Lui"}]},
 {:title=>"Bunch 12/7",
  :creator=>{:name=>"David Lui", :email=>"dvidlui@gmail.com"},
  :start_date=>DateTime.parse("2015-12-15 10:00:00 +0800"),
  :end_date=>DateTime.parse("2015-12-15 10:30:00 +0800"),
  :attendees=>[{:email=>"megan.foy@nobl.io", :name=>"Megan Foy"}, {:email=>"dvidlui@gmail.com", :name=>"David Lui"}]},
 {:title=>"Bunch 12/8",
  :creator=>{:name=>"David Lui", :email=>"dvidlui@gmail.com"},
  :start_date=>DateTime.parse("2015-12-16 10:00:00 +0800"),
  :end_date=>DateTime.parse("2015-12-16 10:30:00 +0800"),
  :attendees=>[{:email=>"megan.foy@nobl.io", :name=>"Megan Foy"}, {:email=>"dvidlui@gmail.com", :name=>"David Lui"}]},
 {:title=>"Bunch 12/9",
  :creator=>{:name=>"David Lui", :email=>"dvidlui@gmail.com"},
  :start_date=>DateTime.parse("2015-12-17 10:00:00 +0800"),
  :end_date=>DateTime.parse("2015-12-17 10:30:00 +0800"),
  :attendees=>[{:email=>"megan.foy@nobl.io", :name=>"Megan Foy"}, {:email=>"dvidlui@gmail.com", :name=>"David Lui"}]},
 {:title=>"Bunch 12/10",
  :creator=>{:name=>"David Lui", :email=>"dvidlui@gmail.com"},
  :start_date=>DateTime.parse("2015-12-18 10:00:00 +0800"),
  :end_date=>DateTime.parse("2015-12-18 10:30:00 +0800"),
  :attendees=>[{:email=>"megan.foy@nobl.io", :name=>"Megan Foy"}, {:email=>"dvidlui@gmail.com", :name=>"David Lui"}]}]  

  def initialize(source, events)
    self.source = source
    self.events = events.present? ? events : SAMPLE_EVENTS2

    self.participants   = {}
    self.meeting_times  = []
    self.merged_times   = [] # Time ranges overlapping ragnes combined properly
    self.free_times     = []

    self.results = {rule1: 0, rule2: 0, rule3: 0, rule4: 0, rule5: 0, rule6: 0, rule7: {}}
    self.rule_titles = {
      rule1: "Meeting versus maker time, maybe like a seesaw or something?",
      rule2: "Your amount of flow, maybe 5 flow chunks is the max and visually it's like a thermometer?",
      rule3: "The price tag of your most crowded meeting, assuming everyone bills at $100/hr",
      rule4: "Number of cups of coffee for each early and late meeting",
      rule5: "Visual of meetings that are vying for your attention (e.g. Balboa vs Creed)",
      rule6: "Your 3 longest meetings and their share of your day (e.g. Weekly Status – 30% of your Tuesday)",
      rule7: "Your top 3 peers by share of time in meetings (e.g. Bud – 20% of your meetings, Lauren – 15%)",
    }
    self.text_results = []
  end

  def analyze
    return nil unless events.present?

    self.events.each_with_index do |e|
      self.results[:rule3] += 1 if check_rule3(e)
      self.results[:rule4] += 1 if check_rule4(e)
      check_rule5(e)
      self.results[:rule6] += 1 if check_rule6(e)
      check_rule7(e)
    end
    self.participants = self.participants.sort { |(k1, v1), (k2,v2)| v2[:age] <=> v1[:age] }
    self.participants = Hash[*self.participants.flatten]
    self.results[:rule7] = self.participants.select { |k, v| v[:num_meetings] >=3 }

    # Combines overlapping time ranges
    time_ranges = self.meeting_times.map { |e| (e[:start_date]..e[:end_date]) }
    self.merged_times = merge_overlapping_ranges(time_ranges)

    check_rule1
    check_rule2

    get_answers
  end

  # Gets text-only answers
  def get_answers
    if self.results[:rule1] < 20
      self.text_results << {title: self.rule_titles[:rule1], 
                            answer: "You've got a bevy of maker time this week. Use it. Make us proud."}
    else
      self.text_results << {title: self.rule_titles[:rule1], 
                            answer: "Are you sitting down? We've got some bad news. Your week is (percent) meetings."\
                                    " Also, sitting down is killing you. Pro-tip: Get ruthless with the 'decline' button."}
    end

    if self.results[:rule2] == 0
      self.text_results << {title: self.rule_titles[:rule2], 
                            answer: "Whoah. You're going to have a hard time finding any time to be "\
                                    "creative outside of your meetings. Pro-tip: try to move some of your existing meetings around."}
    else
      self.text_results << {title: self.rule_titles[:rule2], 
                            answer: "You've got #{self.results[:rule2]} chance(s) to get focused and creative next week. "\
                                    "Pro-tip: Protect next (insert day and time) and find a quiet space to crank."}
    end

    if self.results[:rule3] == 0
      self.text_results << {title: self.rule_titles[:rule3], 
                            answer: "Huzzah! Looks like your team is keeping your meetings lean and mean "\
                                    "(or maybe you just can't afford to hire more than 10 people yet). Keep it up."}
    else
      self.text_results << {title: self.rule_titles[:rule3], 
                            answer: "Watch out, you've got meeting bloat on (days with bloated meetings). "\
                            "We'd gently inquire if the meeting could get broken up or if any reading materials "\
                            "could be sent out prior to cut down on time. But if all else fails, "\
                            "play it like college, skip them and have someone take notes for you."}
    end

    if self.results[:rule4] == 0
      self.text_results << {title: self.rule_titles[:rule4], 
                            answer: "I don't know how you did it, but you managed to consolidate all of your meetings between 9am-5pm. Well done."}
    else
      self.text_results << {title: self.rule_titles[:rule4], 
                            answer: "Looks like you'll burning the candle at both ends with early "\
                                    "morning and late night meetings. Pack in the sleep and protein "\
                                    "before both of these meetings to keep your energy levels up."}
    end

    if self.results[:rule5] == 0
      self.text_results << {title: self.rule_titles[:rule5], 
                            answer: "You'll be in #{self.events.count} meetings next week. "\
                            "Pro-tip: Give your team feedback on these meetings. Were they helpful?"}
    else
      self.text_results << {title: self.rule_titles[:rule5], 
                            answer: "Uh oh, you can't be in two places at once. Want to send both meeting creators a note? [Auto-responder]"}
    end

    if self.results[:rule6] == 0
      self.text_results << {title: self.rule_titles[:rule5], 
                            answer: "No endless meetings on the books this week. Skip prepping a thermus and trail mix for your meetings this week."}
    else
      self.text_results << {title: self.rule_titles[:rule5], 
                            answer: "You have #{self.results[:rule6]} opportunities to get what you need from your team. "\
                                    "Pro-tip: Book weekly planning meetings on Mondays, and "\
                                    "closing meetings on Fridays rather than meetings throughout the week."}
    end

    if self.results[:rule7].count == 0
      names = self.participants.map { |k, v| v[:name].present? ? v[:name] : v[:email] }[0..2]
      self.text_results << {title: self.rule_titles[:rule5], 
                            answer: "#{names.to_sentence} are your meeting buddies for the week. Say hi for us."}
    else
      names = self.results[:rule7].map { |k, v| v[:name].present? ? v[:name] : v[:email] }[0..2]
      self.text_results << {title: self.rule_titles[:rule5], 
                            answer: "You're practically glued at the hip this week with #{names.to_sentence}. "\
                            "Maybe instead of formal meetings, you all could work in the same space or "\
                            "do 15 minute stand ups first thing everyday?"}
    end
    self.text_results
  end

  # Apply RULE#1
  #   Meetings take up more than 20 hours of your week
  def check_rule1
    total_minutes = self.merged_times.sum { |e| (e.end.to_i-e.begin.to_i)/60 }
    self.results[:rule1] = total_minutes / 60
  end

  # Apply RULE#2
  #   Flow Time (2 contiguous hours of free time between 9am and 5pm)
  def check_rule2
    return unless merged_times.present?
    # Gets free time ranges first
    self.merged_times.each_with_index do |t_range, i|
      t1 = nil and t2 = nil
      if i == 0
        t1 = t_range.begin.change(hour:0, minute: 0, second: 0)
      else
        t1 = self.merged_times[i-1].end
      end
      t2 = t_range.begin
      self.free_times << (t1..t2)
    end
    last_range = self.merged_times[-1]
    self.free_times << (last_range.end..last_range.end.change(hour:24, minute: 0, second: 0))

    self.free_times.each do |t_range|
      self.results[:rule2] += 1 if check_rule2_with_free_range(t_range)
    end
  end

  # Checks the range of free time between 9am and 5pm, and >= 2 hrs
  def check_rule2_with_free_range(free_range)
    t1 = free_range.begin and t2 = free_range.end
    if t1.day == t2.day
      d1 = t1.change(hour: 9, minute: 0, second: 0)
      d2 = t1.change(hour: 17, minute: 0, second: 0)
      d_range = d1..d2
      x_range = intersect_ranges(free_range, d_range)
      return false if x_range.nil?
      return time_span_in_DHMS(x_range.begin, x_range.end)[1] >= 2
    else
      d1_range = t1.change(hour: 9, minute: 0, second: 0)..t1.change(hour: 17, minute: 0, second: 0)
      x1_range = intersect_ranges(free_range, d1_range)
      return true if x1_range.present? && time_span_in_DHMS(x1_range.begin, x1_range.end)[1] >= 2

      d2_range = t2.change(hour: 9, minute: 0, second: 0)..t2.change(hour: 17, minute: 0, second: 0)
      x2_range = intersect_ranges(free_range, d2_range)
      return true if x2_range.present? && time_span_in_DHMS(x2_range.begin, x2_range.end)[1] >= 2
    end
    false
  end

  # Apply RULE#3 against an event
  #   Crowded Meetings (meetings with more than 10 participants)
  def check_rule3(e)
    e[:attendees].count >= 10
  end

  # Apply RULE#4 against an event
  #   Earliest and latest meetings of the week (meetings found before 9am and after 5pm)
  def check_rule4(e)
    e[:start_date].hour < 9 || e[:start_date].hour >= 17
  end

  # Apply RULE#5 against an event
  #   Double booked or conflicting meetings
  def check_rule5(e)
    meeting_times.each do |t|
      if (t[:start_date]..t[:end_date]).overlaps?(e[:start_date]..e[:end_date])
        self.results[:rule5] += 1
      end
    end
    meeting_times << {start_date: e[:start_date], end_date: e[:end_date]}
  end

  # Apply RULE#6 against an event
  #   Meetings that are longer than 90 minutes
  def check_rule6(e)
    ((e[:end_date]-e[:start_date])/1.minute) >= 90
  end

  # Apply RULE#7 against an event
  #   Top recurring people (anyone that you're in more than 3 meetings per week with)
  def check_rule7(e)
    e[:attendees].each do |person|
      email = person[:email]
      next if email == source.email

      name = person[:name]
      if self.participants.include?(email)
        self.participants[email][:num_meetings] += 1
      else
        self.participants[email] = {email: email, name: name, num_meetings: 1}
      end
    end
  end

end