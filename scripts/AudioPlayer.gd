extends Node
class_name AudioPlayer
## Port of original class `a` (a.java).
##
## Original: wrapped a single javax.microedition.media.Player built from a byte-range
## slice of the concatenated "sa" resource (5 BGM tracks back-to-back, selected via
## the static index f.var_byte_f / f.byte_g). Here the 5 tracks are already split into
## separate files (assets/audio/bgm/bgm_0.ogg .. bgm_4.ogg), so we just point an
## AudioStreamPlayer at the right stream instead of slicing bytes.
##
## Player states mirrored from javax.microedition.media.Player:
##   UNREALIZED=100 REALIZED=200 PREFETCHED=300 STARTED=400 CLOSED=0

const STATE_CLOSED := 0
const STATE_UNREALIZED := 100
const STATE_REALIZED := 200
const STATE_PREFETCHED := 300
const STATE_STARTED := 400

const BGM_PATHS := [
	"res://assets/audio/bgm/bgm_0.ogg",
	"res://assets/audio/bgm/bgm_1.ogg",
	"res://assets/audio/bgm/bgm_2.ogg",
	"res://assets/audio/bgm/bgm_3.ogg",
	"res://assets/audio/bgm/bgm_4.ogg",
]

var _player: AudioStreamPlayer
var _state: int = STATE_CLOSED
var _track_index: int = -1

func _init(track_index: int = 0) -> void:
	_track_index = track_index
	_player = AudioStreamPlayer.new()
	_player.bus = "Music"

func _ready() -> void:
	add_child(_player)
	_player.finished.connect(_on_finished)
	var stream := load(BGM_PATHS[_track_index]) as AudioStream
	if stream:
		_player.stream = stream
		_state = STATE_PREFETCHED # equivalent to realize()+prefetch() succeeding

## private void c() in original — (re)start playback if not already playing.
func _start() -> void:
	if _player == null or _player.stream == null:
		return
	if _state == STATE_PREFETCHED:
		_on_resume_hint()
	if _state != STATE_STARTED:
		_player.play()
		_state = STATE_STARTED

## final void void_a() in original — stop and rewind to time 0.
func stop_and_rewind() -> void:
	if _player == null:
		return
	if _state == STATE_STARTED:
		_player.stop()
		_state = STATE_PREFETCHED

## final int int_a() in original — current player state.
func get_state() -> int:
	if _player == null:
		return -1
	return _state

## final void b() in original — release/close the player.
func close() -> void:
	if _player == null:
		return
	if _state != STATE_CLOSED:
		_player.stop()
		_state = STATE_CLOSED

## final void a(int n) in original — set volume (0-10 like MIDP VolumeControl 0-100 step 10)
## and play, or stop if n == 0.
func set_volume_level(n: int) -> void:
	if _player == null:
		return
	if n != 0:
		# MIDP: setLevel(n * 20) on a 0-100 scale -> normalize to Godot's 0..1 linear volume.
		var linear: float = clamp(float(n * 20) / 100.0, 0.0, 1.0)
		_player.volume_db = linear_to_db(max(linear, 0.0001))
		if _state != STATE_STARTED:
			_start()
	else:
		stop_and_rewind()

func _on_resume_hint() -> void:
	pass

func _on_finished() -> void:
	# Original relied on PlayerListener "deviceUnavailable"/"deviceAvailable" events for
	# device interruption, not track-end looping. Callers (f.gd) decide whether to loop.
	_state = STATE_PREFETCHED
