module ApplicationHelper
  def cargo_badge_class(cargo)
    case cargo
    when 'Administrativo'
      'bg-primary text-white'
    when 'Jefe de Campo'
      'bg-success text-white'
    when 'Jefe Tecnico'
      'bg-danger text-white'
    when 'Jefe Packing'
      'bg-warning text-dark'
    when 'Riego'
      'bg-info text-white'
    when 'Cosechador'
      'bg-secondary text-white'
    when 'Volante'
      'bg-dark text-white'  # Cambio de blanco a negro oscuro
    else
      'bg-light text-dark'  # Un color por defecto para evitar blanco
    end
  end

  require 'base64'

  def url_for_image(image)
    return nil unless image.image.present?

    # Detectar el tipo de imagen (asume PNG por defecto, ajusta según tus necesidades)
    mime_type = "image/png" # También puedes hacer una detección más avanzada si es necesario

    # Convertir binario a Base64
    "data:#{mime_type};base64,#{Base64.strict_encode64(image.image)}"
  end
  
end
