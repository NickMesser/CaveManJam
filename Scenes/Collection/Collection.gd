extends Control

func _ready():
	for item in $Panel/GridContainer.get_children():
		item.get_node("Sprite").frame = int(item.name)

func reveal_item(id):
	var entry = $Panel/GridContainer.get_node(String(id))
	entry.remove_shader()
