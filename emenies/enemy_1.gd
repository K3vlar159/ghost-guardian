extends CharacterBody2D


@onready var damageable_node : Node = $Damageable
@onready var animated_sprite : AnimatedSprite2D = $Sprite2D
@onready var melee_area : CollisionShape2D =$Enemy1Melee/Hitbox
@onready var audio_attack : AudioStreamPlayer =$audio_attack
@onready var audio_death : AudioStreamPlayer =$audio_death


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var knockback_velocity = Vector2(200,0)
@export var direction = Vector2(-1,0)
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
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if(damageable_node.health <= 0):
		if !dead:
			dead = true
			audio_death.play()
		animation_locked = true
		animated_sprite.play("die")
		velocity.x = 0
	if is_on_wall():
		direction.x = -direction.x
	if direction.x != 0 and !dead and !hit:
		velocity.x = direction.x * speed
	update_facing_direction()
	move_and_slide()
	update_animation()
	


func _on_sprite_2d_animation_finished():
	if(["die"].has(animated_sprite.animation)):
		queue_free()
	elif(["attack"].has(animated_sprite.animation)):
		animation_locked = false

func knockback(node: Node, direction):
	if node == self:
		hit = true
		velocity = direction * knockback_velocity
		await(get_tree().create_timer(0.1).timeout)
		hit = false;

func update_animation():
	if !animation_locked:
		if direction.x != 0:
			animated_sprite.play("walk")
		else:
			animated_sprite.play("idle")
			
func update_facing_direction():
	if direction.x > 0:
		attackDirection = Vector2(1,0)
		animated_sprite.flip_h = true
	elif direction.x < 0:
		animated_sprite.flip_h = false
		attackDirection = Vector2(-1,0)
	#SignalBus.emit_signal("E1attack_direction_changed",animated_sprite.flip_h)
	if(animated_sprite.flip_h):
		melee_area.position = melee_area.facing_right_pos
	else:
		melee_area.position = melee_area.facing_left_pos

func attack_player():
	audio_attack.play()
	animation_locked = true
	animated_sprite.play("attack")
