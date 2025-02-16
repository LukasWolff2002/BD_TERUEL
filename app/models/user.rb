class User < ApplicationRecord
    has_many :receptions
    has_many :irrigations
    has_many :harvests
    has_many :inventorie_historys, dependent: :destroy
  
    # Callbacks
    before_validation :normalizar_rut
  
    # Validaciones
    validates :rut, presence: true, uniqueness: true
    validates :nombre, presence: true
    validates :apellido, presence: true
    validates :email, presence: true, uniqueness: true
  
    validates :cargo, inclusion: { 
      in: ['Administrativo', 'Jefe de Campo', 'Jefe Tecnico', 'Jefe Packing', 'Jefe Volante', 'Riego', 'Cosechador', 'Volante'],
      message: "debe ser uno de: Administrativo, Jefe de Campo, Jefe Tecnico, Jefe Packing, Riego, Cosechador o Volante" 
    }
  
    validates :contrato, inclusion: { 
      in: ['interno', 'externo'],
      message: "debe ser interno o externo" 
    }
  
    # Método para obtener el nombre completo
    def nombre_completo
      [nombre, apellido].compact.join(" ")
    end
  
    private 
  
    def normalizar_rut
      # Si está en blanco, no hace nada
      return if rut.blank?
  
      # 1. Eliminar todo carácter que no sea dígito ni k/K y convertir a minúscula
      rut_sanitizado = rut.gsub(/[^0-9kK]/, '').downcase
  
      # 2. Separar el cuerpo y el DV (último carácter)
      cuerpo = rut_sanitizado[0..-2]
      dv     = rut_sanitizado[-1]
  
      # 3. Formatear el cuerpo con puntos cada 3 dígitos (de derecha a izquierda)
      cuerpo_formateado = cuerpo.reverse.scan(/\d{1,3}/).join('.').reverse
  
      # 4. Unir con el guion para formar "XX.XXX.XXX-DV"
      self.rut = "#{cuerpo_formateado}-#{dv}"  # <= Se asigna aquí
    end
  end
  