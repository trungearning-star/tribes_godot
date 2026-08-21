extends Node2D
## Placeholder for the future port of class `f` (f.java, main Canvas/game loop)
## and class `b` (b.java, world/tribe simulation) — the two large classes that
## still need to be ported. This just proves the asset pipeline (sprites, audio,
## text) works end-to-end inside Godot.

func _ready() -> void:
	var label := Label.new()
	label.text = "Splash OK. Core engine (f.java / b.java) not ported yet."
	label.position = Vector2(8, 8)
	add_child(label)

	var sprite := Sprite2D.new()
	sprite.texture = load("res://assets/sprites/pi0/pi0_000.png")
	sprite.position = Vector2(160, 140)
	add_child(sprite)

	var bgm := AudioPlayer.new(0)
	add_child(bgm)
	bgm.set_volume_level(6)
