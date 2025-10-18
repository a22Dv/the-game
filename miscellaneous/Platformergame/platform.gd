extends Sprite2D

@onready var prompt = $RichTextLabel
@onready var prompt_text = prompt.get_parsed_text()


func get_prompt() -> String:
	return prompt_text
