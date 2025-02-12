class User < ApplicationRecord
    # Si la tabla images no tiene la columna user_id, se debe quitar o modificar esta asociación:
    # has_many :images, dependent: :destroy

    # Queremos que al eliminar un usuario las recepciones, irrigations, harvests, etc. permanezcan,
    # por lo que se retira `dependent: :destroy` para esas asociaciones.
    has_many :receptions           # Se elimina `dependent: :destroy`
    has_many :irrigations           # Se elimina `dependent: :destroy`
    has_many :harvests              # Se elimina `dependent: :destroy`
    has_many :inventorie_historys, dependent: :destroy # Si para este caso deseas eliminar el historial, puedes dejarlo
    validates :rut, presence: true, uniqueness: true
    validates :nombre, presence: true
    validates :apellido, presence: true

    # Validación de cargo como string
    validates :cargo, inclusion: { 
        in: ['Administrativo', 'Jefe de Campo', 'Jefe Tecnico', 'Jefe Packing', 'Jefe Volante', 'Riego', 'Cosechador', 'Volante'],
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