using Godot;
using System;

public class Player : KinematicBody2D
{
	[Export] public int WALK_FORCE = 600;
	[Export] public int WALK_MAX_SPEED = 200;
	[Export] public int STOP_FORCE = 2000;
	[Export] public int JUMP_SPEED = 200;
	public Vector2 velocity = new Vector2();
	private int gravity;

	public override void _Ready()
	{
		gravity = (int)ProjectSettings.GetSetting("physics/2d/default_gravity");
	}

	public override void _PhysicsProcess(float delta)
	{
		HandleMovement(delta);
	}

	private void HandleMovement(float delta)
	{
		float walk = WALK_FORCE * (Input.GetActionStrength("move_right") - Input.GetActionStrength("move_left"));
		if (Mathf.Abs(walk) < WALK_FORCE * 0.2)
		{
			velocity.x = Mathf.MoveToward(velocity.x, 0, STOP_FORCE * delta);
		}
		else
		{
			velocity.x += walk * delta;
		}

		velocity.x = Mathf.Clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED);

		velocity.y += gravity * delta;

		velocity = MoveAndSlideWithSnap(velocity, Vector2.Down, Vector2.Up);

		if (IsOnFloor() && Input.IsActionJustPressed("jump"))
		{
			velocity.y = -JUMP_SPEED;
		}
	}
}
