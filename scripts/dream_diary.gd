extends Control

onready var counter_label = $counter_label

onready var vbox = $scrollbox/vbox
onready var list_item = preload("res://nodes/diary_item.tscn")

var max_items = 256

func _ready():
	_make_list()

func _make_list():
	var dreams_data = save_manager.game_data["dreams"]
	if !dreams_data.empty():
		for section in dreams_data.keys():
			var dream_title = dreams_data[section]["title"]
			var dream_seed = dreams_data[section]["seed"]
			_add_item(dream_title, dream_seed)
	_update_counter()

func _add_item(dream_title, dream_seed):
	if vbox.get_child_count() < max_items:
		var new_item = list_item.instance()
		vbox.add_child(new_item)
		new_item._set_info(dream_title, dream_seed)
		new_item.connect("selected", self, "_on_item_selected")

func _reset_list():
	for item in vbox.get_children():
		vbox.remove_child(item)
		item.queue_free()
	_make_list()

func _save_list():
	var data = {}
	var item_id = 0
	for item in vbox.get_children():
		item_id += 1
		data[str(item_id)] = {
			"title" : item._get_title(),
			"seed" : item._get_seed()
		}
	save_manager.game_data["dreams"] = data
	save_manager._save_data()
	_update_counter()

func _update_counter():
	counter_label.text = str(vbox.get_child_count()) + "/" + str(max_items) + " entries"
