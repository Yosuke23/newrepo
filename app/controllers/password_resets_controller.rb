class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end
  
  def create
   @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
     @user.create_reset_digest
     @user.send_password_reset_email
     flash[:info] = "パスワード変更メールを送信しました。本文のURLにアクセスして変更を完了してください"
     redirect_to root_url
    else
     flash.now[:danger] = "入力頂きましたメールアドレスでは登録の確認ができません。再度ご確認ください"
     render 'new'
   end
  end

  def edit
  end

  def update
  	if params[:user][:password].empty?
  	   @user.errors.add(:password, :blank)
  	   render 'edit'
  	elsif @user.update_attributes(user_params)
  		log_in @user
      @user.update_attribute(:reset_digest, nil)
  		flash[:success] = "パスワード変更完了"
  		redirect_to @user
    else
    	render 'edit'
    end
  end

private

 	def user_params
     params.require(:user).permit(:password, :password_confirmation)
 	end

#URLリンクのeditのgetリクエストでeditアクションに送られてきているURLリンクのメールアドレスをeditアクション/updateアクションの両方で受けるために作ったメソッド
    def get_user
     @user = User.find_by(email: params[:email])
    end

#（ユーザーが代入されている&&有効化されている&&ダイジェスト認証がされている）かを確認して、そのいずれか１つでもunless（反するなら）redirect_to root_urlするメソッド 
    def valid_user
     unless(@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
     redirect_to root_url
     end
    end
    # トークンが期限切れかどうか確認する
    def check_expiration
     if @user.password_reset_expired?
     	flash[:danger] = "パスワードの有効期限が切れましたので、もう一度変更リクエストをし直してください"
     	redirect_to new_password_reset_url
     end
    end
end
