extends Control

@onready var fullscreen_checkbox: CheckBox = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/Fullscreen/Checkbox
@onready var resolution_option: OptionButton = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/Resolution/OptionButton
@onready var music_slider: HSlider = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/Music/HSlider
@onready var sfx_slider: HSlider = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/SFX/HSlider
@onready var back: Button = $MarginContainer/VBoxContainer/Back
const RESOLUTIONS: Array = [
	#Vector2i(800, 600),   # SVGA
	#Vector2i(1024, 768),  # XGA
	Vector2i(1280, 720),  # HD (720p)
	#Vector2i(1280, 800),  # WXGA
	Vector2i(1366, 768),  # Common res
	#Vector2i(1440, 900),  # WXGA+
	Vector2i(1600, 900),  # HD+
	Vector2i(1920, 1080), # Full HD (1080p)
	#Vector2i(1920, 1200), # WUXGA
	#Vector2i(2560, 1440), # Quad HD (1440p)
	#Vector2i(2560, 1600), # WQXGA
	#Vector2i(3440, 1440), # UltraWide QHD
	#Vector2i(3840, 2160), # 4K UHD
	#Vector2i(5120, 2880), # 5K
	#Vector2i(7680, 4320)  # 8K UHD
]


func _ready():
	# Initialize settings
	fullscreen_checkbox.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
	
	# Initialize music volume slider
	var music_bus_idx = AudioServer.get_bus_index("Music")
	if music_bus_idx != -1:
		music_slider.value = AudioServer.get_bus_volume_db(music_bus_idx)
	
	# Initialize SFX volume slider
	var sfx_bus_idx = AudioServer.get_bus_index("SFX")
	if sfx_bus_idx != -1:
		sfx_slider.value = AudioServer.get_bus_volume_db(sfx_bus_idx)
	
	# Populate resolutions
	for res in RESOLUTIONS:
		resolution_option.add_item("%dx%d" % [res.x, res.y])

	var current_res = DisplayServer.window_get_size()
	var index = RESOLUTIONS.find(current_res)
	resolution_option.selected = index
	if index == -1:
		resolution_option.text = "%dx%d" % [current_res.x, current_res.y]
	
	# Connect signals
	fullscreen_checkbox.toggled.connect(_on_fullscreen_toggled)
	resolution_option.item_selected.connect(_on_resolution_selected)
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	back.button_down.connect(_on_back_pressed)
 
func _on_fullscreen_toggled(pressed):
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN if pressed else DisplayServer.WINDOW_MODE_WINDOWED)

func _on_resolution_selected(index):
	DisplayServer.window_set_size(RESOLUTIONS[index])
	center_window()

func _on_music_volume_changed(value):
	var music_bus_idx = AudioServer.get_bus_index("Music")
	if music_bus_idx != -1:
		# If slider is at minimum, mute the audio
		if value == music_slider.min_value:
			AudioServer.set_bus_volume_db(music_bus_idx, -80.0)  # -80 dB is effectively mute
		else:
			AudioServer.set_bus_volume_db(music_bus_idx, value)

func _on_sfx_volume_changed(value):
	var sfx_bus_idx = AudioServer.get_bus_index("SFX")
	if sfx_bus_idx != -1:
		# If slider is at minimum, mute the audio
		if value == sfx_slider.min_value:
			AudioServer.set_bus_volume_db(sfx_bus_idx, -80.0)  # -80 dB is effectively mute
		else:
			AudioServer.set_bus_volume_db(sfx_bus_idx, value)

func center_window():
	var screen_size = DisplayServer.screen_get_size() # Get screen resolution
	var window_size = DisplayServer.window_get_size()  # Get current window size
	if (screen_size != window_size): # if not full screen res
		var new_position = (screen_size - window_size) / 2  # Calculate center position
		DisplayServer.window_set_position(new_position)  # Move window to center
	else:
		DisplayServer.window_set_position(Vector2i(0,0)) # set to top left (windowed fullscreen)
	
func save_settings():
	var config = ConfigFile.new()
	config.set_value("display", "fullscreen", fullscreen_checkbox.button_pressed)
	config.set_value("display", "resolution", resolution_option.selected)
	config.set_value("audio", "music_volume", music_slider.value)
	config.set_value("audio", "sfx_volume", sfx_slider.value)
	config.save("user://settings.cfg")

func load_settings():
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		fullscreen_checkbox.button_pressed = config.get_value("display", "fullscreen", false)
		music_slider.value = config.get_value("audio", "music_volume", 0.0)
		sfx_slider.value = config.get_value("audio", "sfx_volume", 0.0)
		
		# Apply the loaded volumes
		var music_bus_idx = AudioServer.get_bus_index("Music")
		if music_bus_idx != -1:
			AudioServer.set_bus_volume_db(music_bus_idx, music_slider.value)
		
		var sfx_bus_idx = AudioServer.get_bus_index("SFX")
		if sfx_bus_idx != -1:
			AudioServer.set_bus_volume_db(sfx_bus_idx, sfx_slider.value)
	
func _on_back_pressed():
	if get_parent().get_parent():
		get_parent().get_parent().back_from_settings()
	self.hide()
