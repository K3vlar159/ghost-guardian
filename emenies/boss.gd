extends CharacterBody2D


@onready var damageable_node : Node = $DamageableBoss
@onready var animated_sprite : AnimatedSprite2D = $Sprite2D
@onready var melee_area : CollisionShape2D =$bossMelee/Hitbox
@onready var move_anim = $MovementAnim2
@onready var charge_anim : AnimationPlayer = $ChargeAnim2
@onready var charge_timer = $Timer
const bullet_scene = preload('res://xd/bullet_boss.tscn')
@onready var muzzle : Marker2D =$Marker2D
var can_shoot = false
@export var shoot_cooldown = 0.8
@onready var shoot_audio= $shoot
@onready var appear_audio= $appear
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var knockback_velocity = Vector2(0,0)
var direction = Vector2(1,0)
var speed = 0
var dead = false:
	get:
		return dead
var hit = false
var animation_locked = false
var attackDirection = Vector2(1,0) :
	get:
		return attackDirection

var charging = false
var can_charge = false
var charge_speed = 200
var charge_time
var random = RandomNumberGenerator.new()
var appearing = false
func _ready():
	SignalBus.connect("on_hit", knockback)
	SignalBus.connect("startBoss", start)
	randomize()
	charge_time = randf_range(1.5, 4)
	charge_timer.start(charge_time)
	animated_sprite.visible = false

func _physics_process(delta):
	# Add the gravity.
	if(damageable_node.health <= 0):
		can_shoot = false
		animation_locked = true
		move_anim.pause()
		charge_anim.pause()
		SignalBus.emit_signal("boss_died")
		animated_sprite.play("die")
		dead = true
		velocity.x = 0

	if can_shoot:
		shoot()
	update_animation()
	update_facing_direction()


func _on_sprite_2d_animation_finished():
	if(["die"].has(animated_sprite.animation)):
		SignalBus.emit_signal("unlock")
		queue_free()
	elif(["attack"].has(animated_sprite.animation)):
		animation_locked = false
	if(["appear"].has(animated_sprite.animation)):
		can_shoot = true
		can_charge = true
		animated_sprite.play("idle")
		appearing = false
		move_anim.play("new_animation")

func knockback(node: Node, direction):
	if node == self:
		hit = true
		velocity = direction * knockback_velocity
		await(get_tree().create_timer(0.1).timeout)
		hit = false;

func update_animation():
	if !animation_locked:
		if !charging and !appearing:
			animated_sprite.play("idle")
			
func update_facing_direction():
	if direction.x > 0:
		attackDirection = Vector2(1,0)
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true
		attackDirection = Vector2(-1,0)
	SignalBus.emit_signal("E1attack_direction_changed",animated_sprite.flip_h)

	
func shoot():
	if !charging:
		shoot_audio.play()
		shoot_cooldown = randf_range(0.8, 2)
		animation_locked = true
		animated_sprite.play("attack")
		var bullet = bullet_scene.instantiate()
		get_parent().add_child(bullet)
		#shoot anim
		if attackDirection == Vector2(1,0):
			bullet.global_position = muzzle.global_position
		elif attackDirection == Vector2(-1,0):
			bullet.global_position = muzzle.global_position
		bullet.set_direction(attackDirection)
		can_shoot = false
		await(get_tree().create_timer(shoot_cooldown).timeout)
		can_shoot = true

func charge():
	if (!charging and can_charge):
		move_anim.pause()
		charge_anim.play("new_animation")
		animated_sprite.play("charge")
		charging = true
		can_charge = false



func _on_timer_timeout():
	if !charging and !dead:
		charge()
	charge_time = randf_range(1, 4)
	charge_timer.start(charge_time)
	


func _on_charge_anim_2_animation_finished(anim_name):
	if anim_name == "new_animation":
		charging = false
		can_charge = true
		move_anim.play("new_animation")

func start():
	appear_audio.play()
	appearing = true
	animated_sprite.visible = true
	animated_sprite.play("appear")
	SignalBus.emit_signal("lock")
