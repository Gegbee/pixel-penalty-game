extends Node2D

var goal_height : int = 0.0
var inside_net : bool = false
var cur_swing : float = 0.01
var new_swing : float = 0.0

signal goal
signal no_goal
var ball_in_goal = false

func _ready():
	goal_height = -$Bar.position.y
	
func _process(_delta):
	
	cur_swing = lerp(cur_swing, 0.01, 0.02)
	$BackNet.material.set_shader_param("amplitude", cur_swing)
	var ball_height = get_parent().get_parent().get_node('Ball').height
	var ball_pos = get_parent().get_parent().get_node('Ball').global_position
	var ball_vel = get_parent().get_parent().get_node('Ball').vel
	$Lines.position.y = -ball_height
	if ball_height > goal_height and inside_net == false:
		if ball_height < goal_height + 2:
			$Bar/Bar.disabled = false
		else:
			$Bar/Bar.disabled = true
		$GoalTop.z_index = 0
		disable_back(true)
	else:
		$Bar/Bar.disabled = true
		$GoalTop.z_index = 2
		disable_back(false)
	if !inside_net and (ball_vel.y > 0 or ball_pos.y < global_position.y - 12):
		emit_signal("no_goal")
		
func _on_Front_body_entered(body):
	if body.is_in_group('ball'):
		inside_net = not inside_net
		if inside_net:
			emit_signal("goal")

func disable_back(what : bool):
	$Lines/Back/Back.disabled = what
	$Lines/Front/GoalLine.disabled = what
	$Lines/Posts/PostLeft.disabled = what
	$Lines/Posts/PostRight.disabled = what
	
func jiggle(power : float):
	cur_swing = power
	$BackNet.material.set_shader_param("amplitude", cur_swing)

func reset():
	inside_net = false
	ball_in_goal = false
