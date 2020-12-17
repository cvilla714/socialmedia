module FriendshipsHelper
  def follow_btn(id = nil, is_me = false)
    out = ''
    friend = current_user.friend?(id || params[:id])
    if is_me || @is_me
      out << if current_user.request?(id || params[:id])
               accept_decline(id || params[:id])
             elsif friend == false
               link_to('Follow', friendships_url(friend_id: (id || params[:id])), method: :post, class: 'btn')
             elsif friend.nil?
               'Pending'
             else
               'Friends'
             end
    end
    out.html_safe
  end

  def list_friends
    out = ''
    @friends.each do |f|
      puts f
      out << "<li>#{f.friend.name} #{f.status && current_user.friend?(f.friend_id) ? '' : ', pending'}<li>"
    end
    out.html_safe
  end

  def accept_decline(user_id)
    out = ''
    out << "<div>
              #{link_to('Accept', friendship_url(id: user_id), method: :patch, class: 'btn')}
              #{link_to('Decline', friendship_url(id: user_id), method: :delete, class: 'btn decline')}
          </div>"
    out.html_safe
  end

  def list_requests
    out = ''
    @requests.each do |f|
      out << "<li class=\"for-btn\">
                <strong>#{f.user.name}</strong>
                #{accept_decline(f.user.id)}
            </li>"
    end
    out.html_safe
  end

  def render_requests
    out = ''
    unless @requests.empty?
      out << "<h1>Friend requests</h1>
                    <ul>
                        #{list_requests}
                    </ul>"
    end
    out.html_safe
  end

  def render_all_users
    out = ''
    out << '<ul class="users-list">'
    @users.each do |user|
      next unless user.id != current_user.id

      out << "<li class=\"space-between\">
              <strong>#{link_to user.name, user_path(id: user.id)}</strong>
              <div>#{follow_btn(user.id, true)}</div>
            </li>"
    end
    out << '</ul>'
    out.html_safe
  end
end
