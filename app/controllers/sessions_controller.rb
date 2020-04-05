class SessionsController < ApplicationController

  def new
  #debugger
  end


def facebook_login
  @user = User.from_omniauth(request.env["omniauth.auth"])
    result = @user.save(context: :facebook_login)
    if result
      log_in @user
      redirect_to @user
    else
      redirect_to auth_failure_path
    end
end

#認証に失敗した際の処理
def auth_failure 
  @user = User.new
  redirect_to root_url
end


def create
       @user = User.find_by(email: params[:session][:email].downcase)              # paramsハッシュで受け取ったemail値を小文字化し、email属性に渡してUserモデルから同じemailの値のUserを探して、user変数に代入
    if @user && @user.authenticate(params[:session][:password]) # user変数がデータベースに存在し、なおかつparamsハッシュで受け取ったpassword値と、userのemail値が同じ(パスワードとメールアドレスが同じ値であれば)true
      if @user.activated?
        log_in @user                                                              # sessions_helperのlog_inメソッドを実行し、sessionメソッドのuser_id（ブラウザに一時cookiesとして保存）にidを送る
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)   # ログイン時、sessionのremember_me属性が1(チェックボックスがオン)ならセッションを永続的に、それ以外なら永続的セッションを破棄する
        redirect_back_or @user
      else
        message = "まだユーザー登録が完了しておりません。"
        message += "ご本人様確認の為のメールを送信しておりますので、ご確認をお願いいたします。"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'メールアドレスが無効か、パスワードが不一致のようです'                # flashメッセージを表示し、新しいリクエストが発生した時に消す
      render 'new'                                                              # newビューの出力
    end
end


# def create
#  auth = request.env["omniauth.auth"]
# if auth.present?
# unless @auth = User.find_from_auth(auth)
# 　@auth = User.create_from_auth(auth)
# end
# 　user = @auth.user
# 　redirect_back_or user
#   else
#        @user = User.find_by(email: params[:session][:email].downcase)              # paramsハッシュで受け取ったemail値を小文字化し、email属性に渡してUserモデルから同じemailの値のUserを探して、user変数に代入
#     if @user && @user.authenticate(params[:session][:password]) # user変数がデータベースに存在し、なおかつparamsハッシュで受け取ったpassword値と、userのemail値が同じ(パスワードとメールアドレスが同じ値であれば)true
#       if @user.activated?
#         log_in @user                                                              # sessions_helperのlog_inメソッドを実行し、sessionメソッドのuser_id（ブラウザに一時cookiesとして保存）にidを送る
#         params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)   # ログイン時、sessionのremember_me属性が1(チェックボックスがオン)ならセッションを永続的に、それ以外なら永続的セッションを破棄する
#         redirect_back_or @user
#       else
#         message = "まだユーザー登録が完了しておりません。"
#         message += "ご本人様確認の為のメールを送信しておりますので、ご確認をお願いいたします。"
#         flash[:warning] = message
#         redirect_to root_url
#       end
#     else
#       flash.now[:danger] = 'メールアドレスが無効か、パスワードが不一致のようです'                # flashメッセージを表示し、新しいリクエストが発生した時に消す
#       render 'new'                                                              # newビューの出力
#     end
#   end
# end

  def destroy
    log_out if logged_in? #定義済みのログイン有無で論理値を返すヘルパー
    redirect_to root_url
  end
  
end
