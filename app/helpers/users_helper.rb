module UsersHelper
  def full_name(user)
    if user.class == User
      "#{user.first_name} #{user.last_name} <#{user.email}>"
    elsif user.class == Offspring
      "#{user.first_name} #{user.last_name}"
    end
  end
end
