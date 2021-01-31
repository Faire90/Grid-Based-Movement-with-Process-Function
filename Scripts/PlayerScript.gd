extends Area2D

#Tile size.  Assumes square tiles.  The tiles used here are 16x16 for example
var tile_size = 16

#Input dictionary used in the move function below and in animations if used
var inputs = {"ui_right": Vector2.RIGHT,
			"ui_left": Vector2.LEFT,
			"ui_up": Vector2.UP,
			"ui_down": Vector2.DOWN}
onready var ray = $RayCast2D
onready var tween = $Tween

#speed variable is used in tween function
export var speed = 5

onready var animationplayer = $AnimationPlayer

#Ensures that the player is snapped to the center of a tile at the start.
func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2

#Checks for input every frame, but only responds if the player isn't currently moving between tiles.
func _process(delta):
	if Input.is_action_pressed("ui_right"):
		if tween.is_active():
			return
		move("ui_right")
	elif Input.is_action_pressed("ui_left"):
		if tween.is_active():
			return
		move("ui_left")
	elif Input.is_action_pressed("ui_up"):
		if tween.is_active():
			return
		move("ui_up")
	elif Input.is_action_pressed("ui_down"):
		if tween.is_active():
			return
		move("ui_down")
	pass

#gets the input from the inputs dictionary and then moves the player one tile in distance.
func move(dir):
	ray.cast_to = inputs[dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		move_tween(dir)
		#play_animation(dir)
	else:
		#play_animation(dir)
		pass

#tween controls player movement speed
func move_tween(dir):
	tween.interpolate_property(self, "position",
		position, position + inputs[dir] * tile_size,
		1.0/speed, Tween.TRANS_LINEAR)
	tween.start()

#Unused animation.  There's currently no input that would trigger "idle".
#The commented out animation calls in the move function will use these animations.
func play_animation(dir):
	if inputs[dir] == Vector2.RIGHT:
		animationplayer.play("Walk Right")
	elif inputs[dir] == Vector2.LEFT:
		animationplayer.play("Walk Left")
	elif inputs[dir] == Vector2.DOWN:
		animationplayer.play("Walk Down")
	elif inputs[dir] == Vector2.UP:
		animationplayer.play("Walk Up")
	else:
		animationplayer.play("Idle")



