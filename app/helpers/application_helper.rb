module ApplicationHelper

  def flash_class name
    # Translate rails conventions to bootstrap conventions
    case name.to_sym
    when :notice
      :success
    when :alert
      :danger
    else
      name
    end
  end

end
