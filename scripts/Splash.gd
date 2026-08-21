extends Node2D
## Port of original class `d` (d.java) — the splash/loading screen shown while
## the MIDlet's heavy asset init (class `e`, run from inside `f`'s constructor)
## was happening. MIDP drew centered images l0/l1/l2 on a white 320x240 canvas;
## here a single TextureRect is swapped and the canvas is just the viewport.

const IMAGES := [
	"res://assets/sprites/l0.png",
	"res://assets/sprites/l1.png",
	"res://assets/sprites/l2.png",
]

@onready var _bg: ColorRect = $Background
@onready var _image: TextureRect = $Image

var stage: int = 0

func _ready() -> void:
	_bg.color = Color.WHITE
	_show_stage(0)

func _show_stage(n: int) -> void:
	stage = n
	if n < 0 or n >= IMAGES.size():
		_image.texture = null
		return
	var tex := load(IMAGES[n]) as Texture2D
	_image.texture = tex
	if tex:
		# LCDUI drawImage(img, 160, 120, HCENTER|VCENTER) -> centered on the 320x240 canvas.
		_image.size = tex.get_size()
		_image.position = Vector2(160, 120) - tex.get_size() / 2.0

## Mirrors tribes.run()'s splash sequence timing exactly (1s, then 2s, then 2s).
func play_sequence() -> void:
	_show_stage(0)
	await get_tree().create_timer(1.0).timeout
	_show_stage(0)
	await get_tree().create_timer(2.0).timeout
	_show_stage(1)
	await get_tree().create_timer(2.0).timeout
	_show_stage(2)
	# Stage 2 (l2) stays on screen — in the original this is where `f`'s constructor
	# (asset loading via class `e`) ran synchronously before the game canvas took over.
