extends Node2D

@onready var bg_music = $bg_music
@onready var boss_music = $boss_music
@onready var boss_died = $boss_died
var boss_dead = false
# Called when the node enters the scene tree for the first time.
func _ready():
	bg_music.play()
	SignalBus.connect("lock", bossfight)
	SignalBus.connect("boss_died", endbossfight)
	SignalBus.connect("unlock", unlock)
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func bossfight():
	bg_music.stop()
	boss_music.play()
	
func endbossfight():
	if !boss_dead:
		boss_music.stop()
		boss_died.play()
		boss_dead = true

func unlock():
	bg_music.play()
