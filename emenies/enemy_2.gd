extends CharacterBody2D


@onready var damageable_node : Node = $Damageable2
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_death : AudioStreamPlayer = $death

@export var damage : int = 1
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var knockback_velocity = Vector2(200,0)
var direction = Vector2(-1,0)
var speed = 50
var dead = false:
	get:
		return dead
var hit = false
var animation_locked = false
var attackDirection = Vector2(-1,0) :
	get:
		return attackDirection

var can_attack = true

func _ready():
	SignalBus.connect("on_hit", knockback)

func _physics_process(delta):
	
	if(damageable_node.health <= 0):
		if !dead:
			dead = true
			audio_death.play()
		animation_locked = true
		can_attack = false
		animated_sprite.play("die")
		dead = true
		velocity.x = 0


func knockback(node: Node, direction):
	if node == self:
		hit = true
		velocity = direction * knockback_velocity
		await(get_tree().create_timer(0.1).timeout)
		hit = false;



func _on_area_2d_body_entered(body):
	print(body)
	if body is Player and !dead and can_attack:
			can_attack = false
			body.hurt(damage,Vector2.ZERO)
			await(get_tree().create_timer(0.3).timeout)
			can_attack= true


func _on_animated_sprite_2d_animation_finished():
	if(["die"].has(animated_sprite.animation)):
		queue_free()
