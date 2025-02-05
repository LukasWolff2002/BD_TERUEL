module ApplicationHelper
  def cargo_badge_class(cargo)
    case cargo
    when "Administrativo"
      "bg-danger"     # Rojo, por ejemplo
    when "Jefe de Campo"
      "bg-info"       # Azul claro
    when "Jefe Tecnico"
      "bg-warning"    # Amarillo
    when "Jefe Packing"
      "bg-secondary"  # Gris
    when "Riego"
      "bg-success"    # Verde
    when "Cosechador"
      "bg-primary"    # Azul oscuro
    when "Volante"
      "bg-dark"       # Negro (o similar)
    else
      "bg-light"
    end
  end
end
