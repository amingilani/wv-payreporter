module ApplicationHelper
  def flash_class(level)
    case level
    when 'alert' then 'ui red message'
    when 'notice' then 'ui blue message'
    else
      'ui message'
    end
  end
end
