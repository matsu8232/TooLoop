module ApplicationHelper
  def show_breadcrumbs?
    return false if %w[devise/sessions devise/registrations].include?(controller_path)
    !(controller_name == "homes" && action_name == "top")
  end

  def breadcrumbs
    crumbs = [{ label: "ホーム", path: root_path }]

    case controller_name
    when "items"
      crumbs << { label: "備品一覧", path: items_path }
      case action_name
      when "new", "create"
        crumbs << { label: "備品登録", path: nil }
      when "show"
        crumbs << { label: current_item_label, path: nil }
      when "edit", "update"
        crumbs << { label: current_item_label, path: item_path(current_item_id) }
        crumbs << { label: "編集", path: nil }
      end
    when "reservations"
      crumbs << { label: "備品一覧", path: items_path }
      crumbs << { label: current_item_label, path: item_path(current_item_id) } if current_item_id
      case action_name
      when "index"
        crumbs << { label: "予約カレンダー", path: nil }
      when "new", "create"
        crumbs << { label: "予約作成", path: nil }
      when "show"
        crumbs << { label: "予約詳細", path: nil }
      end
    when "users"
      case action_name
      when "show"
        crumbs << { label: "マイページ", path: nil }
      when "edit", "update"
        crumbs << { label: "マイページ", path: user_path(current_user_id_for_breadcrumb) }
        crumbs << { label: "プロフィール編集", path: nil }
      end
    when "chats"
      crumbs << { label: "チャット", path: nil }
    else
      crumbs << { label: controller_name.humanize, path: nil }
    end

    crumbs
  end

  private

  def current_item_id
    @item&.id || params[:item_id] || params[:id]
  end

  def current_item_label
    @item&.name.presence || "備品詳細"
  end

  def current_user_id_for_breadcrumb
    @user&.id || current_user&.id || params[:id]
  end
end
