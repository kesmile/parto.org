class DashboardController < ApplicationController
  require 'securerandom'
  def lista
    @username = session[:username]
    if session[:username] == 'ciesar'
      @comadronas = Comadrona.all;
    else
      @comadronas = Comadrona.where(:categoria => session[:categoria]);
    end
    render :layout => 'dashboard'
  end
  def index
    @username = session[:username]
    @s = session[:categoria];
    @eventos = Evento.all.order(id: :desc);
    render :layout => 'dashboard'
  end
  #metodos post y get
  def delete_event
    if params[:id]
      @e = Evento.find(params[:id]).destroy
    end
    render :json => msj = { :status => true, :message => 'ok'}
  end
  def delete_comadrona
    if params[:id]
      @e = Comadrona.find(params[:id]).destroy
    end
    render :json => msj = { :status => true, :message => 'ok'}
  end
  def get_events
    isRoot = false
    if session[:username] == 'ciesar'
      @e = Evento.all.order(id: :desc);
      isRoot = true
    else
      @e = Evento.where(:categoria => session[:categoria]).order(id: :desc);
    end
    @eventos = []

    @e.each do |e|
      tipo = ''
      if e.tipo == 'hemorragia-mucha-sangre'
        tipo = 'Hemorragia mucha sangre!!'
      elsif e.tipo == 'hemorragia-necesito-ayuda'
        tipo = 'Hemorragia necesito ayuda!!'
      elsif e.tipo == 'hemorragia-placenta'
        tipo = 'Hemorragia placenta no sale!!'
      else
        tipo = e.tipo
      end


      obj = {:id=> e.id, :tipo => tipo,:status => e.status, :usuario => e.usuario,
             :telefono => e.telefono,:fecha => e.fecha.strftime("%D - %H:%M:%S"),
             :fecha_gestion => e.fecha_gestion ? e.fecha_gestion.strftime("%D - %H:%M:%S") : '',
             :categoria => e.categoria
             }
      @eventos.push(obj);
    end
    render :json => {:data => @eventos}
  end
  def set_event
    if params[:id] != ''
      Evento.find_by_id(params[:id]).update(:status => false, :fecha_gestion => DateTime.now)
    end
    render :json => msj = { :status => true, :message => 'ok'}
  end
  def add_comadrona
      if params[:nombre] != '' && params[:direccion] != '' && params[:telefono]
         @token = '';
         validate_token = false
         while !validate_token do
           @token = get_token;
           @comadrona = Comadrona.find_by token: @token.downcase
           if @comadrona == nil
             break
           end
         end
        user = Comadrona.create(nombre: params[:nombre], direccion: params[:direccion], telefono: params[:telefono], categoria: session[:categoria], token: @string);
        msg = { :status => "ok", :message => " Se ha guardado exitosamente el token es: <b>" + @string + "</b>", :token => @string}
      else
        msg = { :status => "error", :message => "campos vacios"}
      end
    render :json => msg
  end
  def add_evento
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
      if params[:token] != '' && params[:tipo]
        @comadrona = Comadrona.find_by token: params[:token].downcase
        if @comadrona != nil
          Evento.create(tipo: params[:tipo], usuario: @comadrona.nombre ,telefono: @comadrona.telefono,fecha: DateTime.now, status: true, categoria: @comadrona.categoria)
          msg = { :status => "ok", :message => "Success!"}
        end
      else
        msg = { :status => "error", :message => "Campos vacios"}
      end
    render :json => msg
  end
end
