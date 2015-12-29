class LoginController < ApplicationController
  def index
    if session[:user_id] != nil
      redirect_to controller: 'dashboard', action: 'index'
      return
    end
    render :layout => 'dashboard'
  end

  def validate
    if request.post?
       if params[:username] != '' && params[:password] != ''
         @user = User.find_by user: params[:username]
         if @user != nil
           if @user.password == params[:password]
             session[:user_id] = @user.id
             redirect_to controller: 'dashboard', action: 'index'
           else
             flash[:notice] = 'Contraseña incorrecta!'
             redirect_to controller: 'login', action: 'index'
           end
         else
           flash[:notice] = 'Usuario no encontrado!'
           redirect_to controller: 'login', action: 'index'
         end
       else
         flash[:notice] = 'Campos vacios'
         redirect_to controller: 'login', action: 'index'
       end
    else
      redirect_to controller: 'login', action: 'index'
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to controller: 'login', action: 'index'
  end
end
