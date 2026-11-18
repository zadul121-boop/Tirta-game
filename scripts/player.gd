extends CharacterBody2D

const SPEED         := 220.0
const ACCEL         := 1800.0
const FRICTION      := 2200.0
const JUMP_VELOCITY := -420.0
const GRAVITY       := 1200.0
const MAX_FALL      := 900.0
const DASH_SPEED    := 520.0
const DASH_TIME     := 0.18
const DASH_COOLDOWN := 0.6

var _dash_timer := 0.0
var _dash_cd    := 0.0
var _dash_dir   := 1.0
var _facing     := 1
var has_dash    := true   # true untuk testing; nanti di-unlock di Level 2

func _physics_process(delta: float) -> void:
	_dash_cd = max(_dash_cd - delta, 0.0)

	if _dash_timer > 0.0:
		_dash_timer -= delta
		velocity.x = _dash_dir * DASH_SPEED
		velocity.y = 0.0
		move_and_slide()
		return

	if not is_on_floor():
		velocity.y = min(velocity.y + GRAVITY * delta, MAX_FALL)

	var dir := Input.get_axis("move_left", "move_right")
	if dir != 0.0:
		velocity.x = move_toward(velocity.x, dir * SPEED, ACCEL * delta)
		_facing = sign(dir)
	else:
		velocity.x = move_toward(velocity.x, 0.0, FRICTION * delta)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y *= 0.45

	if has_dash and Input.is_action_just_pressed("dash") and _dash_cd <= 0.0:
		_dash_dir = float(_facing)
		_dash_timer = DASH_TIME
		_dash_cd = DASH_COOLDOWN

	move_and_slide()
