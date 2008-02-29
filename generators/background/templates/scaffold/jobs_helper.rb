module Admin::JobsHelper

  def seconds_in_short(seconds)
    seconds = seconds.to_i
    minutes = seconds / 60
    hours   = seconds / (60 * 60)
    days    = seconds / (60 * 60 * 24)

    if days > 0
      return "#{days} d"
    elsif hours > 0
      return "#{hours} h"
    elsif minutes > 0
      return "#{minutes} m"
    else
      return "#{seconds} s"
    end
  end
  
  def time_ago_in_words_with_customization(time)
    if time
      "#{time_ago_in_words(time)} ago"
    else
      "n/a"
    end
  end
  
  def downloadable?(job)
    job.result.respond_to?(:join)
  end

end
