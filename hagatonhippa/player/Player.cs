using Godot;

public class Player : KinematicBody2D
{
	[Export] public int WalkForce = 600;
	[Export] public int WalkMaxSpeed = 200;
	[Export] public int StopForce = 2000;
	[Export] public int JumpSpeed = 200;
	[Export] public string JumpAction;
	[Export] public string MoveRightAction;
	[Export] public string MoveLeftAction;
	private Vector2 _velocity;
	private int _gravity;

	public override void _Ready()
	{
		_gravity = (int)ProjectSettings.GetSetting("physics/2d/default_gravity");
	}

	public override void _PhysicsProcess(float delta)
	{
		HandleMovement(delta);
	}

	private void HandleMovement(float delta)
	{
		float walk = WalkForce * (Input.GetActionStrength(MoveRightAction) - Input.GetActionStrength(MoveLeftAction));
		if (Mathf.Abs(walk) < WalkForce * 0.2)
		{
			_velocity.x = Mathf.MoveToward(_velocity.x, 0, StopForce * delta);
		}
		else
		{
			_velocity.x += walk * delta;
		}

		_velocity.x = Mathf.Clamp(_velocity.x, -WalkMaxSpeed, WalkMaxSpeed);

		_velocity.y += _gravity * delta;

		_velocity = MoveAndSlideWithSnap(_velocity, Vector2.Down, Vector2.Up);

		if (IsOnFloor() && Input.IsActionJustPressed(JumpAction))
		{
			_velocity.y = -JumpSpeed;
			GD.Print("här");
		}
	}
}
