extends Node

var global = null

func _ready():
    global = get_node('/root/global')
    $HBoxContainer/system.text = global.system

func _on_TextureButton_pressed():
    var config = ConfigFile.new()
    global.system = $HBoxContainer/system.text
    config.set_value('general','system', global.system)
    var err = config.save('user://settings.cfg')
    if err != OK:
        $error_guardar_config.popup()
    else:
        get_tree().change_scene('res://login.tscn')


func _on_popup_TextureButton_pressed():
    $error_guardar_config.hide()

func _on_Button_pressed():
    var config = ConfigFile.new()
    global.system = $HBoxContainer/system.text
    config.set_value('general','system', global.system)
    var err = config.save('user://settings.cfg')
    if err != OK:
        $error_guardar_config.popup()
    else:
        get_tree().change_scene('res://login.tscn')
