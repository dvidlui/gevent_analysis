class UserDatatable
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: users.count,
      iTotalDisplayRecords: users.total_entries,
      aaData: data.compact
    }
  end

  private

  def data
    users.map do |user|
      if user[:invitation_sent_at].present?
        invitation_sent_at = "#{user[:invitation_sent_at].strftime("%d %b %Y")}<br/>".html_safe
        invite_text = "Resend Invite"
      else
        invitation_sent_at = ""
        invite_text = "Send Invite"
      end
      invite_link = link_to(invite_text, "javascript: send_invite('/dashboard/users/#{user.id}/send_invite')")
      invite_link = "#{invitation_sent_at}#{invite_link}" unless invitation_sent_at.empty?
      [
        user.id,
        user.first_name,
        user.last_name,
        user.email,
        user.last_login,
        nil,
        user.sources.try(:first).try(:email),
        "row_#{user.id}"
      ]
    end
  end

  def users
    @users ||= fetch_users
  end

  def fetch_users
    if params[:sSearch].present?
      users = User.where("#{search_where_case}", search_param: "%#{params[:sSearch]}%")
                  .order(order_case).paginate(page: page, per_page: per_page)
    else
      users = User.where(member_type: User::MEMBER_TYPE[:app]).order(order_case).paginate(page: page, per_page: per_page)
    end
    users
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 15
  end

  def sort_column
    columns = %w[id first_name last_name email created_at]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  def search_where_case
    "(first_name LIKE :search_param OR "\
    "last_name LIKE :search_param) AND "\
    "member_type = #{User::MEMBER_TYPE[:app]}"
  end

  def order_case
    "#{sort_column} #{sort_direction}"
  end
end