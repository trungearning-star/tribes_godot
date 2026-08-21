extends Node
## Port of original class `tribes` (tribes.java), the MIDlet entry point.
## Original startApp()/run() sequence: show splash stages 0/0/1/2 with waits,
## then construct the game engine (class `f`) and hand off rendering to it.
##
## Class `f` (f.java, 6630 lines) and its world/simulation collaborator `b`
## (b.java, 5813 lines) are the core game engine and have NOT been ported yet —
## this is the next phase of the project. GameEngineStub currently stands in
## for `f` so the boot sequence is runnable and testable end-to-end today.

const SplashScene := preload("res://scenes/Splash.tscn")
const GameEngineStub := preload("res://scenes/GameEngineStub.tscn")

func _ready() -> void:
	_run()

func _run() -> void:
	var splash: Node2D = SplashScene.instantiate()
	add_child(splash)
	await splash.play_sequence()
	splash.queue_free()

	var game := GameEngineStub.instantiate()
	add_child(game)
