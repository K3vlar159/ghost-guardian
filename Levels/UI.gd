extends CanvasLayer


@onready var hp1=$HP1
@onready var hp2=$HP2
@onready var hp3=$HP3
@onready var player=$"../player"
@onready var restartButton=$restart
@onready var menuButton=$menu
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null:
		if player.health == 3:
			hp1.visible = true
			hp2.visible = true
			hp3.visible = true
		elif player.health == 2:
			hp1.visible = true
			hp2.visible = true
			hp3.visible = false
		elif player.health == 1:
			hp1.visible = true
			hp2.visible = false
			hp3.visible = false
		elif player.health <=0:
			hp1.visible = false
			hp2.visible = false
			hp3.visible = false
			restartButton.visible = true
			menuButton.visible = true

func _on_menu_button_up():
	get_tree().change_scene_to_file("res://Menu/main_menu.tscn")


func _on_restart_button_up():
	get_tree().reload_current_scene()
