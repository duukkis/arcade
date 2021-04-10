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
	[Export] public GameState.hippa HippaID;
	private Vector2 _velocity;
	private int _gravity;
	private GameState _gameState;

	public override void _Ready()
	{
		_gravity = (int)ProjectSettings.GetSetting("physics/2d/default_gravity");
		_gameState = GetNode<GameState>("../GameState");
	}

	public override void _PhysicsProcess(float delta)
	{
		HandleMovement(delta);
		HandleCollision();
	}
	
	private void HandleCollision() {
		for (int i =0; i < GetSlideCount(); i++) {
			KinematicCollision2D collision = GetSlideCollision(i);			
			if (collision.GetCollider() is Player)	
			{
				_gameState.changeHippa();
			}
		}
	}

	private void HandleMovement(float delta)
	{
		// Player is the new hippa and is freezed.
		if (_gameState.hippaPlayer == HippaID && _gameState.isHippaFreeze)
		{
			return;
		}
		
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
		}
	}
}
