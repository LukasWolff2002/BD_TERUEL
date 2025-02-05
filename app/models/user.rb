class User < ApplicationRecord
    has_many :images, dependent: :destroy
    has_many :receptions, dependent: :destroy  # Como evaluador
    has_many :irrigations, foreign_key: 'encargado_de_riego_id'
    
    validates :rut, presence: true, uniqueness: true
    validates :nombre, presence: true
    validates :apellido, presence: true

    # Validación de cargo como string
    validates :cargo, inclusion: { 
        in: ['Administrativo', 'Jefe de Campo', 'Jefe Tecnico', 'Jefe Packing', 'Riego', 'Cosechador', 'Volante'],
        message: "debe ser uno de: Administrativo, Jefe de Campo, Jefe Tecnico, Jefe Packing, Riego, Cosechador o Volante" 
    }

    # Validación de contrato como string
    validates :contrato, inclusion: { 
        in: ['interno', 'externo'],
        message: "debe ser interno o externo" 
    }

    def nombre_completo
        "#{nombre} #{apellido}"
    end
end