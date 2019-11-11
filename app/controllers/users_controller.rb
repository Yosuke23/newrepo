class UsersController < ApplicationController

  def show
  	@user = User.find(params[:id])
  	  	# debugger
  end

  def new
  	@user = User.new
  	  	# debugger
  end

  def create
    @user = User.new(user_params)
    if @user.save # 保存の成功をここで扱う。
       flash[:success] = "Welcom to Sample App!"
       redirect_to @user
       # redirect_to user_url(@user) # 上記に等価
       # redirect_to user_url(id: @user.id) # 上記に等価
       # redirect_to "/users/#{@user.id}" # 上記に等価
    else
      render 'new' #errorメッセージのページ
    end
  end

  private

	  def user_params 
	  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
	  end

end
