extends Area2D

@onready var sprite : Sprite2D = $Sprite2D
@onready var text : Label = $Label
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	sprite.visible = true
	text.visible = true


func _on_body_exited(body):
	sprite.visible = false
	text.visible = false
