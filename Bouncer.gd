extends Node2D

onready var bouncerScene = preload("res://Bouncer.tscn")
signal clicked
var clickable = false

func _ready() -> void:
	$Bouncer/Sprite.self_modulate = "00ffffff"
	$Bouncer.mode = RigidBody2D.MODE_STATIC


func start():
	clickable = true
	$AnimationPlayer.play("pulse")
	$Bouncer.mode = RigidBody2D.MODE_RIGID
	var rand = [Vector2(300, 0), Vector2(-300, 0), Vector2(0, 300), Vector2(0, -300)]
	$Bouncer.linear_velocity = rand[rand_range(0,3)]


func stop():
	clickable = false
	$Blop.play()
	$AnimationPlayer.play("fadeQuick")
	$Bouncer.mode = RigidBody2D.MODE_STATIC


func _physics_process(_delta: float) -> void:
	#when the window gets resized it can get stuck off screen
	if $Bouncer.position.distance_to(Vector2.ZERO) > 1000:
		reset()
		start()


func reset():
		var oldBouncer = $Bouncer
		oldBouncer.name = "oldBouncer"
		oldBouncer.queue_free()
		var newBouncer = bouncerScene.instance()
		newBouncer.set_name("Bouncer")
		self.add_child(newBouncer, true)
		newBouncer.connect("input_event", self, "_on_Bouncer_input_event")


func _on_Bouncer_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton \
		and event.button_index == BUTTON_LEFT and event.pressed:
			if clickable:
				stop()
				emit_signal("clicked", [$Bouncer/Sprite.scale])
