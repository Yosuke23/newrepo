class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers, :show]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save # 保存の成功をここで扱う。
      @user.send_activation_email #←UserMailer.account_activation(@user).deliver_nowから更新 # ←log_in @userから更新
      flash[:info] = "まだ登録は完了しておりません。ご本人様確認のため、yosuke4123@gmail.comよりご登録いただきました#{@user.email}へメールを送信しました。
      メール本文のURLをクリックし、本登録をしてください。"
      redirect_to root_url
    else
      render 'new'#errorメッセージのページ
    end
  end

  def edit
  end
 
  def update
    if @user.update_attributes(user_params)
     flash[:success] = "登録情報変更完了"
     redirect_to @user    
      # 更新に成功した場合を扱う。成功時のみ
    else
      render 'edit'
    end
  end

  def destroy
   User.find(params[:id]).destroy
   flash[:success] = "削除しました"
   redirect_to users_url
  end
 
  def following
   @title = "フォロー"
   @user = User.find(params[:id])
   @users = @user.following.paginate(page: params[:page])
   render 'show_follow'
  end

  def followers
   @title = "フォロワー"
   @user = User.find(params[:id])
   @users = @user.followers.paginate(page: params[:page])
   render 'show_follow'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # beforeアクション
    def admin_user
     redirect_to(root_url) unless current_user.admin?
    end

# ユーザーがログインなしであればログイン画面に転送させる [app/controllers/application_controller.rb] へ移動済み
    # def logged_in_user
    #   unless logged_in?
    #     store_location
    #     flash[:danger] = "Please log in."
    #     redirect_to login_url
    #   end
    # end

 # アクセスしてきたユーザーとログイン中のユーザー（current_user）が同一でなければroot_urlに転送させ論理値を返す
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
