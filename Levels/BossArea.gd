extends Area2D

var started = false
@onready var spawn : CollisionShape2D =$CollisionShape2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if !started and (body is Player):
		SignalBus.emit_signal("startBoss")
		started = true
