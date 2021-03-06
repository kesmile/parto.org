class LoginController < ApplicationController
  def index
    if session[:user_id] != nil
      redirect_to controller: 'dashboard', action: 'index'
      return
    end
    render :layout => 'login'
  end
  def register
    # if session[:user_id] != nil
    #   redirect_to controller: 'dashboard', action: 'index'
    #   return
    # end
    render :layout => 'login'
  end
  def validate_register
    if request.post?
       if params[:username] != '' && params[:password] != '' && params[:categoria] != ''
         @u = User.find_by user: params[:username]
         if @u == nil
           @user = User.create(user: params[:username], email: params[:email], password: params[:password],
                       status: true, categoria: params[:categoria]);
           session[:user_id] = @user.id
           session[:categoria] = @user.categoria
           redirect_to controller: 'dashboard', action: 'index'
         else
           flash[:notice] = 'El usuario ya existe'
           redirect_to controller: 'login', action: 'register'
         end
       else
         flash[:notice] = 'Campos vacios'
         redirect_to controller: 'login', action: 'register'
       end
    end
  end
  def validate
    if request.post?
       if params[:username] != '' && params[:password] != ''
         @user = User.find_by user: params[:username]
         if @user != nil
           if @user.password == params[:password]
             session[:user_id] = @user.id
             session[:categoria] = @user.categoria
             session[:username] = params[:username]
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
  def validate_token
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    if request.post?
      if params[:token] != ''
        @comadrona = Comadrona.find_by token: params[:token]
        if @comadrona != nil
          msg = { :status => "ok", :message => @comadrona.nombre }
        else
          msg = { :status => "error", :message => "token invalido" }
        end
      else
        msg = { :status => "error", :message => "token invalido" }
      end
    else
      msg = { :status => "error", :message => "token invalido" }
    end
    render :json => msg
  end
  def logout
    session[:user_id] = nil
    redirect_to controller: 'home', action: 'index'
  end
end
