module NotificationsHelper
  def notification_icon(notification)
    icon_class = case notification.notification_type
    when 'document_shared'
      'bi-share'
    when 'signature_requested'
      'bi-pen'
    when 'document_signed'
      'bi-check2-circle'
    when 'signature_declined'
      'bi-x-circle'
    when 'document_completed'
      'bi-file-earmark-check'
    end

    content_tag :div, class: "notification-icon #{notification.notification_type}" do
      content_tag :i, nil, class: "bi #{icon_class}"
    end
  end

  def notification_badge
    if current_user.notifications.unread.any?
      content_tag :span, current_user.notifications.unread.count,
        class: 'position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger'
    end
  end
end 