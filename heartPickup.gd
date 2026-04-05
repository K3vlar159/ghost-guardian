extends Area2D

@onready var audio : AudioStreamPlayer =$pickup
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body is Player:
		if body.health != 3:
			audio.play()
			SignalBus.emit_signal("heal")
			


func _on_pickup_finished():
	queue_free()
