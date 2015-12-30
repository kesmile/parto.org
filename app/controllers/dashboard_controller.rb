class DashboardController < ApplicationController
  require 'securerandom'
  def index
    #@string = (SecureRandom.random_number * (10**6)).round.to_s
    render :layout => 'dashboard'
  end
  #metodos post y get
  def add_comadrona
      if params[:nombre] != '' && params[:direccion] != '' && params[:telefono]
        o = [('a'..'z'), ('1'..'9')].map { |i| i.to_a }.flatten
        @string = (0...6).map { o[rand(o.length)] }.join
        user = Comadrona.create(nombre: params[:nombre], direccion: params[:direccion], telefono: params[:telefono], categoria: 'centro05', token: @string);
        msg = { :status => "ok", :message => "Se ha guardado exitosamente el token es: <b>" + @string + "</b>", :token => @string}
      else
        msg = { :status => "error", :message => "campos vacios"}
      end
    render :json => msg
  end
end
