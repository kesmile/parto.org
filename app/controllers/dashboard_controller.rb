class DashboardController < ApplicationController
  require 'securerandom'
  def lista
    @comadronas = Comadrona.all;
    render :layout => 'dashboard'
  end
  def index
    @eventos = Evento.all;
    render :layout => 'dashboard'
  end
  #metodos post y get
  def add_comadrona
      if params[:nombre] != '' && params[:direccion] != '' && params[:telefono]
         o = [('a'..'z'), ('1'..'9')].map { |i| i.to_a }.flatten
         @string = (1...6).map { o[rand(o.length)] }.join @string
        user = Comadrona.create(nombre: params[:nombre], direccion: params[:direccion], telefono: params[:telefono], categoria: 'centro05', token: @string);
        msg = { :status => "ok", :message => "Se ha guardado exitosamente el token es: <b>" + @string + "</b>", :token => @string}
      else
        msg = { :status => "error", :message => "campos vacios"}
      end
    render :json => msg
  end
  def add_evento
      if params[:token] != '' && params[:tipo]
        @comadrona = Comadrona.find_by token: params[:token]
        if @comadrona != nil
          Evento.create(tipo: params[:tipo], usuario: @comadrona.nombre ,telefono: @comadrona.telefono,fecha: DateTime.now, status: true)
          msg = { :status => "ok", :message => "Success!"}
        end
      else
        msg = { :status => "error", :message => "Campos vacios"}
      end
    render :json => msg
  end
end
