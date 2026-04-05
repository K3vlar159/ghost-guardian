extends Area2D

@export var speed: float = 300

@export var damage: float = 1
@onready var animated_sprite : Sprite2D = $Sprite2D
var direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if direction != Vector2.ZERO:
		var attack_direction_sign = sign(direction.x)
		if(attack_direction_sign > 0):
			animated_sprite.flip_h = false
		elif(attack_direction_sign < 0):
			animated_sprite.flip_h = true
		var velocity = direction.x * speed
		global_position.x += velocity * delta

func set_direction(dir: Vector2):
	self.direction = dir

func _on_body_entered(body):
	if body is TileMap:
		queue_free()
	if body is Player:
		if body.dead == false:
			var attack_direction_sign = sign(get_parent().get_node("boss").attackDirection.x)
			if(attack_direction_sign > 0):
				body.hurt(damage,Vector2.RIGHT)
				queue_free()
			elif(attack_direction_sign < 0):
				body.hurt(damage,Vector2.LEFT)
				queue_free()
			else:
				body.hurt(damage,Vector2.ZERO)
				queue_free()
			SignalBus.emit_signal("blink")
