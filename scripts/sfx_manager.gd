extends Node

# Preload or load your SFX here
@onready var click = preload("res://assets/sfx/click.mp3")
@onready var paper = preload("res://assets/sfx/paper.mp3")
@onready var tear = preload("res://assets/sfx/tear.mp3")
@onready var hiss = preload("res://assets/sfx/hiss.mp3")
@onready var phone = preload("res://assets/sfx/phone.mp3")
@onready var pop = preload("res://assets/sfx/pop.mp3")
@onready var rain = preload("res://assets/sfx/rain.ogg")
@onready var pillows = [
	preload("res://assets/sfx/pillow_1.mp3"),
	preload("res://assets/sfx/pillow_2.mp3")
]
@onready var meows = [
	#preload("res://assets/sfx/meow_1.mp3"),
	preload("res://assets/sfx/meow_2.mp3"),
	preload("res://assets/sfx/meow_3.mp3"),
	preload("res://assets/sfx/meow_4.mp3"),
	preload("res://assets/sfx/meow_5.mp3"),
	preload("res://assets/sfx/meow_6.mp3"),
	preload("res://assets/sfx/meow_7.mp3")
]

var _last_meow_indices: Array = []

var rain_player: AudioStreamPlayer = null

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	# No need for a single player now — each sound will use its own temporary AudioStreamPlayer
	pass

# Play any sound (creates a temporary player that deletes itself)
func play(sound: AudioStream):
	if not sound:
		return
	var p = AudioStreamPlayer.new()
	add_child(p)
	p.stream = sound
	p.bus = "SFX"
	p.play()
	
	# Automatically free the player after the sound ends
	p.finished.connect(func(): p.queue_free())

# Return a random sound from an array
func get_random_sfx(array: Array) -> AudioStream:
	if array.is_empty():
		return null
	return array[randi() % array.size()]

# Play a random meow (won’t repeat the last two)
func play_random_meow():
	if meows.is_empty():
		return
	
	var new_index = randi() % meows.size()
	var tries = 0
	
	while new_index in _last_meow_indices and tries < 10:
		new_index = randi() % meows.size()
		tries += 1
	
	_last_meow_indices.append(new_index)
	if _last_meow_indices.size() > 2:
		_last_meow_indices.pop_front()
	
	play(meows[new_index])


func play_fade_in(sound: AudioStream, duration := 1.0) -> AudioStreamPlayer:
	if not sound:
		return null

	var p = AudioStreamPlayer.new()
	add_child(p)
	p.stream = sound
	p.bus = "SFX"
	p.volume_db = -40.0    # start silent
	p.play()

	var tween = get_tree().create_tween()
	tween.tween_property(p, "volume_db", 0.0, duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)

	return p

func fade_out_and_stop(player: AudioStreamPlayer, duration := 1.0):
	if not player or !is_instance_valid(player):
		return

	var tween = get_tree().create_tween()

	tween.tween_property(player, "volume_db", -40.0, duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)

	tween.finished.connect(func():
		if is_instance_valid(player):
			player.stop()
			player.queue_free()
	)
	
	
