extends Spatial

signal next_hole

export (NodePath) var course_data_path

onready var course_data = get_node(course_data_path)

func _ready():
	course_data.get_node("Hole/HoleArea").connect("body_entered", self, "something_in_hole")

func something_in_hole(body):
	if body.is_in_group("ball"):
		emit_signal("next_hole")