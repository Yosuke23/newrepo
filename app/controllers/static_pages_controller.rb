class StaticPagesController < ApplicationController

  def home
   if logged_in?
    @micropost = current_user.microposts.build

     if params[:q]#:q=>headerのviewで指定した属性
      relation = Micropost.joins(:user)
      @feed_items = relation.merge(User.search_by_keyword(params[:q])).or(relation.search_by_keyword(params[:q])).paginate(page: params[:page])
     else
      @feed_items = current_user.feed.paginate(page: params[:page])
     end
   end

   #ログインしていない状態で検索した場合はログイン画面にリダイレクトさせるためのunless文。
   #リダイレクトは非ログインでparams[:q]検索があった場合に限定しているため、ログインに
   #飛ばされてもlogoを押せば（homeアクション）rootに戻れます
   unless logged_in?
     if params[:q]#:q=>headerのviewで指定した属性
      logged_in_user
     end
   end
  end

  def help
  end

  def about
  end


  def contact
  end
end
