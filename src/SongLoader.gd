class_name SongLoader
extends Node

onready var filepath = "res://songs/bad_apple/data.txt"
onready var bad_apple_data = load("res://songs/bad_apple/bad_apple_data.tres")
var data = []


func _ready() -> void:
	load_resource()


func load_resource() -> void:
	var line_arr:PoolStringArray = bad_apple_data.raw_string_data.split("\n")
	for line in line_arr:
		parse_line(line)


func parse_line(line:String) -> void:
	if line == "":
		return
	var arr:PoolStringArray = line.split(",")
	var time = float(arr[0])
	var key = int(arr[1])
	data.append([time, key])
