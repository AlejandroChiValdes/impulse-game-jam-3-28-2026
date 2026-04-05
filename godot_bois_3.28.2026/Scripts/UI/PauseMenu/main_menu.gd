extends Button

var MAIN_MENU_SCENE_UID : String = "uid://dwuhmxt5045b2"
func _pressed():
	get_tree().change_scene_to_packed(load(MAIN_MENU_SCENE_UID))
