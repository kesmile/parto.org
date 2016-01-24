class DashboardController < ApplicationController
  require 'securerandom'
  def lista
    @comadronas = Comadrona.where(:categoria => session[:categoria]);
    render :layout => 'dashboard'
  end
  def index
    @s = session[:categoria];
    @eventos = Evento.all.order(id: :desc);
    render :layout => 'dashboard'
  end
  #metodos post y get
  def get_events
    if params[:nombre] != nil
      @e = Evento.where("categoria = ? and usuario LIKE ?", "#{session[:categoria]}", "%#{params[:nombre]}%").order(id: :desc);
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
      elseif e.tipo == 'hemorragia-placenta'
        tipo = 'Hemorragia placenta no sale!!'
      else
        tipo = e.tipo
      end
      obj = {:id=> e.id, :tipo => tipo,:status => e.status, :usuario => e.usuario,
             :telefono => e.telefono,:fecha => e.fecha.strftime("%D - %H:%M:%S"), :updated_at => e.updated_at.strftime("%D - %H:%M:%S")}
      @eventos.push(obj);
    end
    render :json => {:data => @eventos}
  end
  def set_event
    if params[:id] != ''
      Evento.find_by_id(params[:id]).update_attribute(:status, false).update_attribute(:fecha_gestion, DateTime.now)
    end
    render :json => msj = { :status => true, :message => 'ok'}
  end
  def add_comadrona
      if params[:nombre] != '' && params[:direccion] != '' && params[:telefono]
         o = [('a'..'z'), ('1'..'9')].map { |i| i.to_a }.flatten
         @string = (1...6).map { o[rand(o.length)] }.join @string
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
        @comadrona = Comadrona.find_by token: params[:token]
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
