class PagesController < ApplicationController

	 wrap_parameters :page, include: [:name, :page_layout, :page_kind, :page_type]
   skip_before_action :require_login, only: [:all]

  def all
    @pages = Page.all
    render json: @pages
  end

	def make_initial_pages_for(user)
			components_to_add = ComponentsController.new
      homepage = Page.create(:name => "Homepage", :page_type => "Index", :page_kind => "Page", :page_layout => "eyJST09UIjp7InR5cGXECHJlc29sdmVkTmFtZSI6Ik1haW5XcmFwcGVyIn0sImlzQ2FudmFzIjpmYWxzZSwicHJvcHMiOnt9LCJkaXNwbGF50zksImN1c3RvbcYoaGlkZGVuyUJub2RlcyI6WyJoZndvUlMwbzFHIl0sImxpbmtlZE7GHXt9xDjKIPoAsEJvZHn/ALD2ALDMOf8AsOYAsPEApM1DOiJDVnA4emVzbEfkAIhwYXJlbnQiOuYBb30syx7pAMwiZGl2IuwAs3RydesAsiJzdHls5QDzaGVpZ2jETTUwMHB4IuQBHO4AzEVsZW3Eb/8AyOcBeHlwdlV4WHRfZPMBd+sAuusBf30syzX6AYxDb2x1bW5Db250YWlu/wGQInNyY8RldHRwczovL3dhbGxwYXBlcmFjY2Vzcy5jb20vZnVsbC8zNDA1OTcuanBnIizqAQk45QEJLCJ3aWR0aCI6IjEwMHZ3xHDuARjmAJEg6gCS/wEh+AHpQ29sykQ6Img2aEowTkxyX2HtAevtAgHLJP8B8eoBE2NsYXNz5wC7ZWRpdF9j7gFRX18zX1F6WOQBCewAuv8CD/8A7iJQMlYzd2RYdEHkAWJZM3lfaEp5d0j+AhzqAg59LMxB/wIcbu4CE+8A/+kB3jEwMO4B3CIsIm1hcmdpbkxlZsQh5gH9xhNUb3DJEnNldHRpbmdzRXh0ZW5zaW9ux31JbWFnZSBTb3VyY2XEJ+0Ce3Jlcy5jbG91ZGluYXJ55QJ6Y3NzLXRyaWNrcy9pxDsvZmV0Y2gvd182MDAscV9hdXRvLGbFBy/IRmNkbjQuYnV5c2VsbGFkcy5uZXQvdXUvNy83ODE4MC8xNjA4NjgwMTg3LU1DU21hcnRfRW5nYWdlX0PlAaNfRmVhdHVyZV/FHFJlY3NfR2V0U3RhcnRlZF8xeDEtXzFf5wMGaWTmAVAx8gLx/wH67wH6MS1zOE1kUGct/wQJ7QLv6gIi/wHt/wHt/wHt/wHt/wHt/wHt/wHt/wHt/wHt/wHt/wHt/wHt/wHt+QHtbnVsbP8B5OsB5OoCGfoB5E5hdkl0ZW3+BeVmb250U2l6xDAxMiIsxRBGYW1pbHkiOiJjb21pYyBzYW5zIG1zIiwidGV45ACLTmV3IMVaLCJjb2xv5AVxIzPFASIsImJhY2tncm91bmRDyBxmZcQC8gEf6ACh/wEf9wX07AEd6wThfX0=")
			components_to_add.configure(homepage)
      user.pages << homepage
	end

	def create
		page = @user.pages.create(page_params)
    if page.valid?
      render json: {page: page}
    else
        render json: {errors: user.errors.full_messages}, status: :not_acceptable
    end
	end
  def delete 
    @page = Page.find_by(id: params[:id])
    @page.destroy
  end
  def edit 

    @page = Page.find_by(id: params[:id])
    @page.page_layout = params[:page_layout]
    @page.save

  end
	def page_params
      params.require(:page).permit(:name, :page_layout, :page_kind, :page_type, :id)
    end
end