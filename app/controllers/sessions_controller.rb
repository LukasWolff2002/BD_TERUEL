class SessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]
  protect_from_forgery with: :exception

  def new
    Rails.logger.info "Renderizando formulario de login"
  end

  def create
    Rails.logger.info "Intentando iniciar sesión con parámetros: #{params.inspect}"
    
    begin
      user = User.find_by(rut: params[:session][:rut])
      Rails.logger.info user ? "Usuario encontrado: #{user.nombre_completo}" : "Usuario no encontrado"
      
      if user
        session[:user_id] = user.id
        redirect_to root_path, notice: 'Inicio de sesión exitoso'
      else
        flash.now[:alert] = 'RUT no encontrado'
        render :new, status: :unprocessable_entity
      end
    rescue => e
      Rails.logger.error "Error en login: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      flash.now[:alert] = 'Error al procesar el login'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    Rails.logger.info "Se recibió la solicitud de cierre de sesión. Session previa: #{session.inspect}"
    session[:user_id] = nil
    Rails.logger.info "Se ha cerrado la sesión. Nueva session: #{session.inspect}"
    redirect_to login_path, notice: 'Has cerrado sesión'
  end
end 