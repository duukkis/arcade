using Godot;

public class Player : KinematicBody2D
{
	[Export] public int BaseWalkForce = 600;
	[Export] public int BaseMaxSpeed = 100;
	[Export] public int BaseStopForce = 1600;
	[Export] public int JumpSpeed = 200;
	[Export] public string JumpAction;
	[Export] public string MoveRightAction;
	[Export] public string MoveLeftAction;
	public bool HasHaste = false;
	public bool HasInvisibility = false;
	private float _hasteTimer = 0;
	private float _invisibilityTimer = 0;
	private Vector2 _velocity;
	private int _gravity;

	public override void _Ready()
	{
		_gravity = (int)ProjectSettings.GetSetting("physics/2d/default_gravity");
	}

	public override void _PhysicsProcess(float delta)
	{
		HandleMovement(delta);
		DecrementPowerups(delta);
	}
	
	public void GiveHaste()
	{
		HasHaste = true;
		_hasteTimer = 5;
	}
	
	public void GiveInvisibility()
	{
		(FindNode("Sprite") as Sprite).Hide();
		(FindNode("Light2D") as Light2D).Hide();
		HasInvisibility = true;
		_invisibilityTimer = 5;
	}

	private void HandleMovement(float delta)
	{
		float maxSpeed = HasHaste ? BaseMaxSpeed * 2 : BaseMaxSpeed;
		float walkForce = HasHaste ? BaseWalkForce * 2 : BaseWalkForce;
		float stopForce = HasHaste ? BaseStopForce * 2 : BaseStopForce;
		float walk = walkForce * (Input.GetActionStrength(MoveRightAction) - Input.GetActionStrength(MoveLeftAction));
		if (Mathf.Abs(walk) < walkForce * 0.2)
		{
			_velocity.x = Mathf.MoveToward(_velocity.x, 0, stopForce * delta);
		}
		else
		{
			_velocity.x += walk * delta;
		}

		_velocity.x = Mathf.Clamp(_velocity.x, -maxSpeed, maxSpeed);

		_velocity.y += _gravity * delta;

		_velocity = MoveAndSlideWithSnap(_velocity, Vector2.Down, Vector2.Up);

		if (IsOnFloor() && Input.IsActionJustPressed(JumpAction))
		{
			_velocity.y = -JumpSpeed;
			GD.Print("här");
		}
	}
	
	private void DecrementPowerups(float delta)
	{
		_hasteTimer -= delta;
		_invisibilityTimer -= delta;
		
		if (_hasteTimer <= 0)
		{
			HasHaste = false;
			_hasteTimer = 0;
		}
		
		if (_invisibilityTimer <= 0)
		{
			HasInvisibility = false;
			(FindNode("Sprite") as Sprite).Show();
			(FindNode("Light2D") as Light2D).Show();
			_invisibilityTimer = 0;
		}
	}
}
