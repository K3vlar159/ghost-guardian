extends CharacterBody2D

class_name Player

const bullet_scene = preload('res://xd/bullet.tscn')
signal bullet_shot(bullet, location)


@export var speed : float = 250.0
@export var dash_speed : float = 500
@export var dash_time : float = 0.15
@export var dash_cooldown : float = 1
@export var shoot_cooldown : float = 0.60
@export var jump_velocity : float = -350
@export var double_jump_velocity : float = -350
@export var shooting_enabled : bool = true
@export var melee_enabled : bool = false
@export var health : float = 3 :
	get:
		return health
	set(value):
		health = value



@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var standing_collider : CollisionShape2D = $StandingCollider
@onready var crouching_collider : CollisionShape2D =$CrouchingCollider
@onready var muzzle_right : Marker2D =$MuzzleR
@onready var muzzle_left : Marker2D =$MuzzleL
@onready var melee_area : CollisionShape2D =$Melee/MeleeHitbox


@onready var audio_jump : AudioStreamPlayer =$audio_jump
@onready var audio_shoot : AudioStreamPlayer =$shoot
@onready var audio_hurt : AudioStreamPlayer =$hurt
@onready var audio_death : AudioStreamPlayer =$death
@onready var audio_dash : AudioStreamPlayer =$dash



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jumped : bool = false
var animation_locked : bool = false
var direction : Vector2 = Vector2.ZERO
var was_in_air : bool = false
var dashing = false
var can_dash = true
var can_shoot = true
var dashDirection = Vector2(-1,0)
var attackDirection = Vector2(-1,0) :
	get:
		return attackDirection
var dead = false :
	get:
		return dead
var is_crouching = false
var hit = false
var knockback_velocity = Vector2(200,0)

var can_hurt = true

func _ready():
	SignalBus.connect("on_hit", knockback)
	SignalBus.connect("heal", heal)
	
func _physics_process(delta):
	
	if(health <= 0):
		audio_death.play()
		animation_locked = true
		animated_sprite.play("die")
		dead = true
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		was_in_air = true;
	else:
		has_double_jumped = false
		
		if was_in_air:
			land()

	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor(): #normal jump
			jump()
		elif not has_double_jumped:
			double_jump()
			
	if Input.is_action_just_pressed("dash"):
		dash()
		
	if Input.is_action_pressed("crouch"):
		is_crouching = true
		crouching_collider.set_disabled(true)
	else:
		if is_crouching and is_on_floor():
			self.global_position.y -= crouching_collider.shape.get_length()
		is_crouching = false
		crouching_collider.set_disabled(false)

	if Input.is_action_just_pressed("attack"):
		if shooting_enabled and can_shoot:
			shoot()
		if melee_enabled:
			melee()
	
	
	
	direction = Input.get_vector("left", "right","up","down")
	if !dashing and !hit:
		if direction.x != 0 :
			velocity.x = direction.x * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
	update_animation()
	update_facing_direction()
	
func update_animation():
	if not animation_locked:
		if is_on_floor(): #vratit na not
			#animated_sprite.play("jump_loop")

		#else:
			if direction.x != 0:
				animated_sprite.play("run")
			else:
				animated_sprite.play("idle")

func update_facing_direction():
	if direction.x > 0:
		attackDirection = Vector2(1,0)
		animated_sprite.flip_h = true
	elif direction.x < 0:
		animated_sprite.flip_h = false
		attackDirection = Vector2(-1,0)
	SignalBus.emit_signal("attack_direction_changed",animated_sprite.flip_h)

func jump():
	velocity.y = jump_velocity
	audio_jump.play()
	#animated_sprite.play("jump_start")
	#animation_locked = true
	
func double_jump():
	audio_jump.play()
	velocity.y = double_jump_velocity
	#animated_sprite.play("jump_double")
	animation_locked = true
	has_double_jumped = true

func land():
	#animated_sprite.play("jump_end")
	was_in_air = false

func dash():
	if (!dashing and can_dash and direction.x != 0):
		audio_dash.play()
		var dash_direction = Input.get_vector("left", "right","down","up")
		velocity.x = dash_direction.x * dash_speed
		dashing = true
		can_dash = false
		await(get_tree().create_timer(dash_time).timeout)
		dashing = false
		await(get_tree().create_timer(dash_cooldown).timeout)
		can_dash = true
		
	
func _on_animated_sprite_2d_animation_finished():
	if(["attack"].has(animated_sprite.animation)):
		animation_locked = false
	if(["hit"].has(animated_sprite.animation)):
		animation_locked = false
		can_hurt = true
	if(["die"].has(animated_sprite.animation)):
		queue_free()

func shoot():
	var bullet = bullet_scene.instantiate()
	audio_shoot.play()
	get_parent().add_child(bullet)
	animation_locked = true
	animated_sprite.play("attack")
	if attackDirection == Vector2(1,0):
		bullet.global_position = muzzle_right.global_position
	elif attackDirection == Vector2(-1,0):
		bullet.global_position = muzzle_left.global_position
	bullet.set_direction(attackDirection)
	can_shoot = false
	await(get_tree().create_timer(shoot_cooldown).timeout)
	can_shoot = true

func melee():
	animation_locked = true
	animated_sprite.play("attack")
	melee_area.disabled = false
	await(get_tree().create_timer(0.1).timeout)
	melee_area.disabled = true

func hurt(damage : int, knockback_direction):
	health -= damage
	audio_hurt.play()
	SignalBus.emit_signal("on_hit", self, knockback_direction)
	animation_locked = true
	animated_sprite.play("hit")
	can_hurt = false

func knockback(node: Node, direction):
	if node == self:
		hit = true
		velocity = direction * knockback_velocity
		await(get_tree().create_timer(0.1).timeout)
		hit = false;
		
func heal():
	if health != 3:
		health += 1
