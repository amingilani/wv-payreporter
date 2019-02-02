module ApplicationHelper
  def flash_class(level)
    case level
    when 'success' then 'ui green message'
    when 'warn' then 'ui red message'
    else
      'ui message'
    end
  end
end
