extends Spatial

const max_courses = 7

var cur_course = 1

func transition_to_next_course():
	get_tree().create_timer(2.0).connect("timeout", self, "switch_course_scene")

func switch_course_scene():
	get_node(str("Course", cur_course)).queue_free()
	cur_course += 1
	var cur_course_node = load(str("res://Course", cur_course, ".tscn")).instance()
	add_child(cur_course_node)
	cur_course_node.connect("next_hole", self, "transition_to_next_course")
	if cur_course > max_courses:
		get_tree().change_scene("res://WinScreen.tscn")