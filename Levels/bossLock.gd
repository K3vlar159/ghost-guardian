extends StaticBody2D


@onready var lockL : CollisionShape2D =$CollisionShape2D2
@onready var lockR : CollisionShape2D =$CollisionShape2D
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("lock", lock)
	SignalBus.connect("unlock", unlock)
	lockL.set_deferred("disabled",true)
	lockR.set_deferred("disabled",true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func lock():
	lockL.set_deferred("disabled",false)
	lockR.set_deferred("disabled",false)
	
func unlock():
	lockL.set_deferred("disabled",true)

