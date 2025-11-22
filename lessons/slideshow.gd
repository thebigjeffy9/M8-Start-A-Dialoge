extends Control

@export var dialogue_items: Array[SlideShowEntry] = []
var current_item_index := 0

## UI element that shows the texts
@onready var rich_text_label: RichTextLabel = %RichTextLabel
## UI element that progresses to the next text
@onready var next_button: Button = %NextButton
## Audio player that plays voice sounds while text is being written
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
## The character
@onready var body: TextureRect = %Body
#
@onready var expression: TextureRect = %Expression


func _ready() -> void:
	show_text()
	next_button.pressed.connect(advance)

#
func show_text() -> void:
	
	var current_item := dialogue_items[current_item_index]
	
	rich_text_label.text = current_item.text
	expression.texture = current_item.expression
	body.texture = current_item.character
	
	rich_text_label.visible_ratio = 0.0
	
	var tween := create_tween()
	
	var text_appearing_duration := (current_item["text"] as String).length() / 30.0
	
	tween.tween_property(rich_text_label, "visible_ratio", 1.0, text_appearing_duration)
	
	var sound_max_offset := audio_stream_player.stream.get_length() - text_appearing_duration
	
	var sound_start_position := randf() * sound_max_offset
	
	audio_stream_player.play(sound_start_position)
	
	tween.finished.connect(audio_stream_player.stop)
	slide_in()


## P
func advance() -> void:
	
	current_item_index += 1
	if current_item_index == dialogue_items.size():
		
		get_tree().quit()
	else:
		
		show_text()



func slide_in() -> void:
	var slide_tween := create_tween()
	slide_tween.set_ease(Tween.EASE_OUT)
	body.position.x = get_viewport_rect().size.x / 7
	slide_tween.tween_property(body, "position:x", 0, 0.3)
	body.modulate.a = 0
	slide_tween.parallel().tween_property(body, "modulate:a", 1, 0.2)
