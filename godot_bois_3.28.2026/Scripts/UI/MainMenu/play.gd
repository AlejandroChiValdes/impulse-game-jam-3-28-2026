extends Button
var LEVEL_1_TUTORIAL_SCENE_UID : String = "uid://etlpsrwvd2rf"
func _pressed():
	get_tree().change_scene_to_packed(load(LEVEL_1_TUTORIAL_SCENE_UID))
