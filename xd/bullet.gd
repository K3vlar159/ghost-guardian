extends Area2D

@export var speed: float = 400
@export var damage: float = 8
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
	for child in body.get_children():
		if child is Damageable:
			child.hit(damage,direction.x)
			queue_free()
		elif child is DamageableBoss:
			child.hit(damage,direction.x)
			queue_free()
		elif child is Damageable2:
			child.hit(damage,direction.x)
			queue_free()
		elif child.get_name() == "boss":
			child.hit(damage,direction.x)
			queue_free()
