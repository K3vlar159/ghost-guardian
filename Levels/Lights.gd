extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("blink", blink)
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func blink():
	for child in get_children():
		var random_blink = randi_range(0, 1)
		if(random_blink == 1):
			child.visible = false
	await(get_tree().create_timer(0.4).timeout)
	for child in get_children():
		child.visible = true
	for child in get_children():
		var random_blink = randi_range(0, 1)
		if(random_blink == 1):
			child.visible = false
	await(get_tree().create_timer(0.4).timeout)
	for child in get_children():
		child.visible = true
