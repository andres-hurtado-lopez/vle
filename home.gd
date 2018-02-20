extends Node

var global
var contador_transporte;
var contador_mecanico;
var contador_servicio;
var contador_combustible;
var contador_descanso;
var contador_actividad;

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
    db = get_node('/root/db')
    global = get_node('/root/global')
    $VGastos/concepto_gasto.populate(['Peaje','Combustible'])
    $VActvidad/herramienta.populate(db.read_key('herramientas'))
    $VActvidad/actividad.populate(db.read_key('actividades'))
    $VActvidad/terreno.populate(db.read_key('terrenos'))
#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass


func _on_fin_turno_pressed():
    global.logged = false
    global.store_config()
    get_tree().change_scene('res://login.tscn')


func _on_transporte_pressed():
    $MoveScreens.play("go_transporte")
    contador_transporte = 0
    $VTransporte/timer_transporte.start()



func _on_mecanico_pressed():
    $MoveScreens.play("go_mecanico")
    contador_mecanico = 0
    $VMecanico/timer_mecanico.start()


func _on_combustible_pressed():
    $VCombustible/timer_combustible.start()
    $VCombustible/tiempo_cambustible.text = '00:00:00'
    contador_combustible = 0
    $MoveScreens.play("go_combustible")


func _on_actividades_pressed():
    contador_actividad = 0
    $VActvidad/timer_actividad.start()
    $MoveScreens.play("go_actividad")


func _on_descanso_pressed():
    $VDescanso/timer_descanso.start()
    contador_descanso = 0
    $VDescanso/tiempo_descanso.text = '00:00:00'
    $MoveScreens.play("go_descanso")


func _on_gastos_pressed():
    $MoveScreens.play("go_gastos")


func _on_detener_transporte_pressed():
    $VTransporte/timer_transporte.stop()
    $MoveScreens.play("back_transporte")
    $VTransporte/tiempo_transporte.text = "00:00:00"



func _on_timer_transporte_timeout():
    contador_transporte += 1
    var horas = floor(contador_transporte/3600);
    var minutos = floor((contador_transporte % 3600 ) / 60);
    var segundos = (contador_transporte % 3600 ) % 60;
    $VTransporte/tiempo_transporte.text = String(horas).pad_zeros(2)+":"+String(minutos).pad_zeros(2)+":"+String(segundos).pad_zeros(2)




func _on_timer_mecanico_timeout():
    contador_mecanico += 1
    var horas = floor(contador_mecanico/3600);
    var minutos = floor((contador_mecanico % 3600 ) / 60);
    var segundos = (contador_mecanico % 3600 ) % 60;
    $VMecanico/tiempo_espera_mecanico.text = String(horas).pad_zeros(2)+":"+String(minutos).pad_zeros(2)+":"+String(segundos).pad_zeros(2)



func _on_regresar_mecanico_pressed():
    $VMecanico/timer_mecanico.stop()
    $MoveScreens.play("back_mecanico")
    $VMecanico/tiempo_espera_mecanico.text = "00:00:00"



func _on_llegada_mecanico_pressed():
    $MoveScreens.play('go_servicio')
    contador_servicio = 0
    $VMecanico/timer_mecanico.stop()
    $VServicioMecanico/timer_servicio.start()
    $VServicioMecanico/tiempo_servicio.text = "00:00:00"


func _on_detener_servicio_pressed():
    $VServicioMecanico/timer_servicio.stop()
    $MoveScreens.play('back_servicio')


func _on_Fin_Tanqueo_pressed():
    $VCombustible/timer_combustible.stop()
    $MoveScreens.play('back_combustible')


func _on_detener_descanso_pressed():
    $VDescanso/timer_descanso.stop()
    $MoveScreens.play('back_descanso')


func _on_regresar_gastos_pressed():
    $MoveScreens.play('back_gastos')


func _on_registrar_gasto_pressed():
    $MoveScreens.play('back_gastos')


func _on_timer_servicio_timeout():
    contador_servicio += 1
    var horas = floor(contador_servicio/3600);
    var minutos = floor((contador_servicio % 3600 ) / 60);
    var segundos = (contador_servicio % 3600 ) % 60;
    $VServicioMecanico/tiempo_servicio.text = String(horas).pad_zeros(2)+":"+String(minutos).pad_zeros(2)+":"+String(segundos).pad_zeros(2)


func _on_timer_combustible_timeout():
    contador_combustible += 1
    var horas = floor(contador_combustible/3600);
    var minutos = floor((contador_combustible % 3600 ) / 60);
    var segundos = (contador_combustible % 3600 ) % 60;
    $VCombustible/tiempo_cambustible.text = String(horas).pad_zeros(2)+":"+String(minutos).pad_zeros(2)+":"+String(segundos).pad_zeros(2)



func _on_timer_descanso_timeout():
    contador_descanso += 1
    var horas = floor(contador_descanso/3600);
    var minutos = floor((contador_descanso % 3600 ) / 60);
    var segundos = (contador_descanso % 3600 ) % 60;
    $VDescanso/tiempo_descanso.text = String(horas).pad_zeros(2)+":"+String(minutos).pad_zeros(2)+":"+String(segundos).pad_zeros(2)



func _on_regresar_actividad_pressed():
    $VActvidad/timer_actividad.stop()
    $VActvidad/tiempo_actividad.text = '00:00:00'
    $MoveScreens.play('back_actividad')


func _on_detener_actividad_pressed():
    $VActvidad/timer_actividad.stop()
    $VActvidad/tiempo_actividad.text = '00:00:00'
    $MoveScreens.play('back_actividad')


func _on_timer_actividad_timeout():
    contador_actividad += 1
    var horas = floor(contador_actividad/3600);
    var minutos = floor((contador_actividad % 3600 ) / 60);
    var segundos = (contador_actividad % 3600 ) % 60;
    $VActvidad/tiempo_actividad.text = String(horas).pad_zeros(2)+":"+String(minutos).pad_zeros(2)+":"+String(segundos).pad_zeros(2)

