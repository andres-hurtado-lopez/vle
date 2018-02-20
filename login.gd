extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var global = null
var db = null

func _ready():
    # Called every time the node is added to the scene.
    # Initialization here
    db = get_node('/root/db')
    global = get_node('/root/global')
    set_process(false)

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass


func _on_login_pressed():
    $Loading.popup()
    $RequestLogin.request('https://'+global.system+'.simpleagri.com/index.php',
                          PoolStringArray([
                                            'user: '+ $user.text,
                                            'password: '+$password.text,
                                            'language: eng',
                                            'type: W'
                                       ]),
                          false,
                        HTTPClient.METHOD_POST)


func _on_RequestLogin_request_completed( result, response_code, headers, body ):
    var json_result = null

    if response_code == 200:
        json_result = JSON.parse(body.get_string_from_ascii())
        if json_result.error == OK:

            global.logged = true
            global.sess = json_result.result['sess']
            global.lang = json_result.result['lang']
            global.sess_type = json_result.result['sess_type']
            global.user = $user.text
            global.store_config()

            self.global.request_load_scene('res://home.tscn')
            $Timer.start()
        else:
            $Error.popup()
    elif response_code == 401:
        $Loading.hide()
        $IncorrectUserPassword.popup()
    else:
        $Loading.hide()
        $Error/message.text = tr(global.http_errors[result])
        $Error.popup()


func _on_Timer_timeout():
    var poll_result = 0
    if self.global.ril.get_stage() < self.global.ril.get_stage_count() - 1:
        poll_result = self.global.ril.poll()
        var progress = float(self.global.ril.get_stage()) / float(self.global.ril.get_stage_count()) * 100
        $Loading/ProgressBar.value = progress
    else:

        self.global.ril.poll()

        if self.global.ril.get_stage() == self.global.ril.get_stage_count() - 1:
            $Timer.stop()
            self.global.load_scene()


func _on_user_focus_entered():
    $user/user_placeholder.visible = false


func _on_user_focus_exited():
    if $user.text == "" :
        $user/user_placeholder.visible = true


func _on_password_focus_entered():
    $password/password_placeholder.visible = false

func _on_password_focus_exited():
    if $password.text == "":
        $password/password_placeholder.visible = true


func _on_set_system_pressed():
    get_tree().change_scene('res://set_system.tscn')
