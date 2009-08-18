module Admin::AdminHelper
  def submenu_items(controller)
    begin
      render :partial => "admin/shared/navigation/#{controller}"
    rescue ActionView::MissingTemplate # if there is not template catch it and display nothing
      ""
    end
  end
end