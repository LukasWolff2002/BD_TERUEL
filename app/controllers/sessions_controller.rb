class SessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]
  protect_from_forgery with: :exception

  def new
    Rails.logger.info "Renderizando formulario de login"
  end

  def create
    Rails.logger.info "Intentando iniciar sesión con parámetros: #{params.inspect}"

    rut_ingresado = params[:session][:rut].to_s.strip
    Rails.logger.info "RUT Ingresado: #{rut_ingresado}"

    # 1. Validar presencia de RUT
    if rut_ingresado.blank?
      flash.now[:alert] = 'El RUT no puede estar en blanco'
      return render :new, status: :unprocessable_entity
    end

    # 2. Normalizar RUT (igual o similar a tu método en User)
    rut_normalizado = normalizar_rut(rut_ingresado)

    # 3. Buscar al usuario
    begin
      user = User.find_by(rut: rut_normalizado)
      Rails.logger.info user ? "Usuario encontrado: #{user.nombre_completo}" : "Usuario no encontrado"

      if user
        session[:user_id] = user.id
        redirect_to root_path, notice: 'Inicio de sesión exitoso'
      else
        flash.now[:alert] = "No se encontró el RUT: #{rut_normalizado}"
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

  private

  # Método privado para normalizar el RUT (similar al que tienes en User)
  def normalizar_rut(rut)
    # 1. Eliminar todo carácter que no sea dígito ni k/K y convertir a minúscula
    rut_sanitizado = rut.gsub(/[^0-9kK]/, '').downcase

    return "" if rut_sanitizado.blank? # Si quedara vacío, lo retornamos vacío

    # 2. Separar el cuerpo y el DV
    cuerpo = rut_sanitizado[0..-2]
    dv     = rut_sanitizado[-1]

    # 3. Formatear el cuerpo con puntos cada 3 dígitos de derecha a izquierda
    cuerpo_formateado = cuerpo.reverse.scan(/\d{1,3}/).join('.').reverse

    # 4. Unir con el guion para formar "XX.XXX.XXX-DV"
    "#{cuerpo_formateado}-#{dv}"
  end
end
