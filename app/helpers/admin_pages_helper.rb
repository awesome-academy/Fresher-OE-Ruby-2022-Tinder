module AdminPagesHelper
  def actived_icon user
    user.confirmed? ? "fa-check" : "fa-xmark"
  end

  def admin_icon user
    user.admin? ? "fa-check" : "fa-xmark"
  end

  def type_of_btn user
    user.gold? ? "link-danger" : "link-primary"
  end

  def act user
    user.gold? ? t(".down") : t(".up")
  end

  def disabled_btn user
    !user.confirmed? ? "disabled" : ""
  end

  def load_type_of
    User.type_ofs.map{|k, v| [k, v]}
  end
end
