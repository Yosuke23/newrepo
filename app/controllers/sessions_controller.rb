class SessionsController < ApplicationController

  def new
  #debugger
  end


  def create
    auth = request.env["omniauth.auth"] # SNSログイン機能
   if auth.present?
       unless @auth = Authorization.find_from_auth(auth)
              @auth = Authorization.create_from_auth(auth)
       end
       @user = @auth.user
         session[:user_id] = @user.id
         #redirect_to @user
         redirect_back_or @user  
   else # 以下通常のログイン機能
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
  end

  def destroy
    log_out if logged_in? #定義済みのログイン有無で論理値を返すヘルパー
    redirect_to root_url
  end
  
end
