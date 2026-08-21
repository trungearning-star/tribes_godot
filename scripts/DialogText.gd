extends RefCounted
class_name DialogText
## Port of original class `c` (c.java) — the game's text system: short UI strings,
## help strings, and long "scene" dialogue strings, all pipe-separated in
## assets/text/{s,t,d0}.txt (Vietnamese-only copy of the original /0/s, /0/t, /0/d0).
##
## Original drew via javax.microedition.lcdui.Graphics + Font.getFont(0,0,SIZE_SMALL).
## Here, callers pass a CanvasItem (the node currently inside a _draw() callback) and a
## Font resource; draw_outlined() uses CanvasItem.draw_string() with a 1px drop-shadow
## outline in 4 directions, matching the original drawOutlined().

const MAX_Q := 96
const MAX_LINES := 160

# Scene index -> paragraph offset within sceneText, ported verbatim from sceneBaseFor().
const SCENE_BASE := [
	0, 3, 15, 18, 20, 22, 24, 26, 28, 29, 30, 31, 33, 34, 35, 36, 44, 45, 46, 57,
	58, 59, 62, 64, 65, 67, 68, 70, 72, 77, 81, 84, 85, 86, 97, 102, 108, 109, 111, 116,
	117, 119, 123, 128, 137, 143, 145, 148, 149, 165, 167, 181, 184, 190, 197, 203, 204, 207, 208, 211,
	212, 216, 219, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234,
]

var short_text: PackedStringArray = []
var help_text: PackedStringArray = []
var scene_text: PackedStringArray = []
var scene_base: int = 0

var lines: PackedStringArray = []
var wx: int = 0
var wy: int = 0
var ww: int = 0
var wh: int = 0
var wstyle: int = 0

var q_text: Array = []
var q_x: Array = []
var q_y: Array = []
var q_align: Array = []
var q_style: Array = []
var q_count: int = 0

var font: Font
var font_size: int = 8

func _init() -> void:
	q_text.resize(MAX_Q)
	q_x.resize(MAX_Q)
	q_y.resize(MAX_Q)
	q_align.resize(MAX_Q)
	q_style.resize(MAX_Q)
	short_text = _load_parts("res://assets/text/s.txt")
	help_text = _load_parts("res://assets/text/t.txt")
	scene_text = _load_parts("res://assets/text/d0.txt")
	lines = []
	q_count = 0
	scene_base = 0
	font = ThemeDB.fallback_font
	font_size = 8

## final void a() — clear the draw queue.
func clear_queue() -> void:
	q_count = 0

## final void a(int n) — select which scene's dialogue block is active.
func set_scene(n: int) -> void:
	scene_base = _scene_base_for(n)
	if scene_text.is_empty():
		scene_text = _load_parts("res://assets/text/d0.txt")

## final void b(int n) — reload one of the three text banks (0=short,1=help,2=scene).
func reload_bank(n: int) -> void:
	if n == 0:
		short_text = _load_parts("res://assets/text/s.txt")
	elif n == 1:
		help_text = _load_parts("res://assets/text/t.txt")
	elif n == 2:
		scene_text = _load_parts("res://assets/text/d0.txt")
		scene_base = 0

## final void a(n,n2,n3,string,n4) — enqueue an already-resolved string.
func enqueue_text(x: int, y: int, align: int, text: String, style: int) -> void:
	_enqueue(x, y, align, text, style)

## final void a(n,n2,n3,n4,n5) — enqueue a short-text-table lookup.
func enqueue_short(x: int, y: int, align: int, short_id: int, style: int) -> void:
	_enqueue(x, y, align, _lookup_short(short_id), style)

## final void a(n..n7) — enqueue up to three short strings side by side, left to right.
func enqueue_short_triplet(x: int, y: int, id0: int, id1: int, id2: int, style: int) -> void:
	var cx := x
	if id0 >= 0:
		var s0 := _lookup_short(id0)
		_enqueue(cx, y, 0, s0, style)
		cx += text_width(s0) + 2
	if id1 >= 0:
		var s1 := _lookup_short(id1)
		_enqueue(cx, y, 0, s1, style)
		cx += text_width(s1) + 2
	if id2 >= 0:
		var s2 := _lookup_short(id2)
		_enqueue(cx, y, 0, s2, style)

## final void a(Graphics graphics) — flush the queue, drawing every enqueued string.
func flush_queue(canvas: CanvasItem) -> void:
	for i in range(q_count):
		_draw_outlined(canvas, q_text[i], q_x[i], q_y[i], q_align[i], q_style[i])
	q_count = 0

## final void b(n,n2,n3,n4,n5,n6,n7) — set up a wrapped text window (dialogue box).
func set_window(x: int, y: int, w: int, h: int, long_id: int, _unused: int, style: int) -> void:
	wx = x
	wy = y
	ww = w
	wh = h
	wstyle = style
	var text := _lookup_long(long_id)
	lines = _wrap_text(text, 300 if w <= 0 else w)

## final void a(Graphics graphics, int n) — draw the wrapped window starting at line n.
func draw_window(canvas: CanvasItem, start_line: int) -> void:
	var line_h: int = _font_height() + 1
	var top_pad := 1
	var bottom_pad := 1
	var inner_h: int = wh - top_pad - bottom_pad if wh > top_pad + bottom_pad else wh
	var visible_lines: int = lines.size() if wh <= 0 else int(inner_h / line_h)
	if visible_lines < 1:
		visible_lines = 1
	var cy: int = wy + top_pad
	var i := start_line
	while i < lines.size() and i < start_line + visible_lines:
		_draw_outlined(canvas, lines[i], wx, cy, 0, wstyle)
		cy += line_h
		i += 1

func text_width(text: String) -> int:
	if font == null or text == null:
		return text.length() * 6
	return int(font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x)

# ---------------------------------------------------------------- internals --

func _enqueue(x: int, y: int, align: int, text: String, style: int) -> void:
	if text == null:
		text = ""
	text = _clean_inline(text)
	if q_count >= MAX_Q:
		return
	q_text[q_count] = text
	q_x[q_count] = x
	q_y[q_count] = y
	q_align[q_count] = align
	q_style[q_count] = style
	q_count += 1

func _lookup_short(id: int) -> String:
	if id >= 0 and id < short_text.size():
		return short_text[id]
	if id >= 0 and id < help_text.size():
		return help_text[id]
	return ""

func _lookup_long(id: int) -> String:
	if id >= 71:
		var idx: int = id - 71 + scene_base
		if idx >= 0 and not scene_text.is_empty() and idx < scene_text.size():
			return scene_text[idx]
	if id >= 0 and id < help_text.size():
		return help_text[id]
	if id >= 0 and not scene_text.is_empty() and id < scene_text.size():
		return scene_text[id]
	return ""

static func _scene_base_for(n: int) -> int:
	if n < 0:
		return 0
	if n >= SCENE_BASE.size():
		return SCENE_BASE[SCENE_BASE.size() - 1]
	return SCENE_BASE[n]

func _load_parts(path: String) -> PackedStringArray:
	if not FileAccess.file_exists(path):
		return PackedStringArray()
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return PackedStringArray()
	var text := f.get_as_text(true) # UTF-8 already, unlike original's manual 1-3 byte decoder
	f.close()
	return text.split("|")

func _font_height() -> int:
	if font == null:
		return font_size + 2
	return int(font.get_height(font_size))

func _draw_outlined(canvas: CanvasItem, text: String, x: int, y: int, align: int, style: int) -> void:
	if text == null or text.length() == 0 or font == null:
		return
	var w := text_width(text)
	var draw_x: int = x - int(w * align / 2.0)
	var baseline_y: int = y + _font_height() # LCDUI drawString(y, TOP) -> Godot draw_string baseline
	var shadow := Color(0, 0, 0)
	canvas.draw_string(font, Vector2(draw_x - 1, baseline_y), text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, shadow)
	canvas.draw_string(font, Vector2(draw_x + 1, baseline_y), text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, shadow)
	canvas.draw_string(font, Vector2(draw_x, baseline_y - 1), text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, shadow)
	canvas.draw_string(font, Vector2(draw_x, baseline_y + 1), text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, shadow)
	var fill: Color
	if style == 1:
		fill = Color8(0xFF, 0xFF, 0x00)
	elif style == 2:
		fill = Color8(0xFF, 0x80, 0x00)
	else:
		fill = Color8(0xFF, 0xFF, 0xFF)
	canvas.draw_string(font, Vector2(draw_x, baseline_y), text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, fill)

func _clean_inline(text: String) -> String:
	var out := ""
	for i in range(text.length()):
		var ch: String = text[i]
		var code := text.unicode_at(i)
		if code >= 32 and ch != "&":
			out += ch
		elif ch == "&":
			out += " "
	return out

func _wrap_text(text: String, max_width: int) -> PackedStringArray:
	text = _normalize_long(text)
	var result := PackedStringArray()
	var start := 0
	while start <= text.length() and result.size() < MAX_LINES:
		var nl := text.find("\n", start)
		if nl < 0:
			nl = text.length()
		result = _wrap_para(text.substr(start, nl - start), max_width, result)
		if nl == text.length():
			break
		if result.size() < MAX_LINES:
			result.append("")
		start = nl + 1
	return result

func _wrap_para(para: String, max_width: int, out: PackedStringArray) -> PackedStringArray:
	para = para.strip_edges()
	if para.length() == 0:
		if out.size() < MAX_LINES:
			out.append("")
		return out
	var current := ""
	var pos := 0
	while pos < para.length() and out.size() < MAX_LINES:
		while pos < para.length() and para[pos] == " ":
			pos += 1
		var word_end := pos
		while word_end < para.length() and para[word_end] != " ":
			word_end += 1
		var word := para.substr(pos, word_end - pos)
		var candidate: String = word if current.length() == 0 else current + " " + word
		if current.length() > 0 and text_width(candidate) > max_width:
			out.append(current)
			current = ""
		else:
			if current.length() > 0:
				current += " "
			current += word
			pos = word_end
		if current.length() == 0 and word.length() > 0:
			current += word
			pos = word_end
	if current.length() > 0 and out.size() < MAX_LINES:
		out.append(current)
	return out

func _normalize_long(text: String) -> String:
	var out := ""
	for i in range(text.length()):
		var ch: String = text[i]
		var code := text.unicode_at(i)
		if ch == "&":
			out += "\n"
		elif code >= 32:
			out += ch
		else:
			out += " "
	return out
