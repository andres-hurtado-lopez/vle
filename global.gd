extends Node

var system = ""
var user = ""
var logged = ""
var sess = ""
var sess_type =""
var lang = ""
var ril = null

func _ready():

    TranslationServer.set_locale(OS.get_locale().left(2))
    #TranslationServer.set_locale("en")

    var config = ConfigFile.new()
    var err = config.load('user://settings.cfg')
    if err == OK:
        self.system = config.get_value('general', 'system',"")

        self.logged = config.get_value('session', 'logged',false)
        self.sess = config.get_value('session','sess','')
        self.user = config.get_value('session', 'user','')
        self.sess_type = config.get_value('session','sess_type','')
        self.lang = config.get_value('session','lang','')


        if self.logged == false:
            get_tree().change_scene('res://login.tscn')
        else:
            get_tree().change_scene('res://home.tscn')

    else:
        get_tree().change_scene('res://set_system.tscn')

func store_config():
    var config = ConfigFile.new()

    config.set_value('general', 'system',self.system)
    config.set_value('session', 'logged',self.logged)
    config.set_value('session','sess',self.sess)
    config.set_value('session', 'user',self.user )
    config.set_value('session','sess_type',self.sess_type)
    config.set_value('session','lang',self.lang)

    return config.save('user://settings.cfg')

func request_load_scene(scene_path):
    self.ril = ResourceLoader.load_interactive(scene_path)

func load_scene():
    call_deferred('_deferred_load_scene')

func _deferred_load_scene():

    var root = get_tree().get_root()
    var current_scene = root.get_child(root.get_child_count() -1)
    current_scene.queue_free()

    var scene_resource = self.ril.get_resource()

    var scene = scene_resource.instance()

    root.add_child(scene)
    get_tree().set_current_scene( scene )