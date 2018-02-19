extends ReferenceRect

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var db = get_node('/root/db')
export(NodePath) var PlayerNode
export(String) var Animation

func _ready():
    var ubicaciones = db.read_key('ubicaciones')

    $Origen.populate(ubicaciones)
    $Destino.populate(ubicaciones)



func _on_iniciar_transporte_pressed():
    var Player = get_node(self.PlayerNode)
    Player.play(self.Animation)
