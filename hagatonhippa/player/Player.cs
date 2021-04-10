using Godot;

public class Player : KinematicBody2D
{
	[Export] public int BaseWalkForce = 600;
	[Export] public int BaseMaxSpeed = 100;
	[Export] public int BaseStopForce = 1600;
	[Export] public int JumpSpeed = 300;
	[Export] public string JumpAction;
	[Export] public string MoveRightAction;
	[Export] public string MoveLeftAction;
	[Export] public GameState.hippa HippaID;

	private bool _hasHaste = false;
	private bool _hasInvisibility = false;
	private bool _hasDoubleJump = false;
	private float _hasteTimer = 0;
	private float _invisibilityTimer = 0;
	private float _doubleJumpTimer = 0;
	private bool _doubleJumpReady = false;
	private Vector2 _velocity;
	private int _gravity;
	private GameState _gameState;

	private AnimatedSprite _animatedSprite;
	private Light2D _light;

	public override void _Ready()
	{
		_gravity = (int)ProjectSettings.GetSetting("physics/2d/default_gravity");
		_gameState = GetNode<GameState>("../GameState");
		_animatedSprite = GetNode<AnimatedSprite>("AnimatedSprite");
		_light = GetNode<Light2D>("Light2D");
	}

	public override void _PhysicsProcess(float delta)
	{
		HandleMovement(delta);
		HandleCollision();
		HandleAnimation(delta);
		DecrementPowerups(delta);
	}

	private void HandleAnimation(float delta)
	{
		if (_velocity.x > 0)
		{
			_animatedSprite.FlipH = false;
			_animatedSprite.Play("run");
		} else if (_velocity.x < 0)
		{
			_animatedSprite.FlipH = true;
			_animatedSprite.Play("run");
		}
		else
		{
			_animatedSprite.Play("idle");
		}
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

	public void GiveHaste()
	{
		_hasHaste = true;
		_hasteTimer = 7;
	}
	
	public void GiveInvisibility()
	{
		_animatedSprite.Hide();
		_light.Hide();
		_hasInvisibility = true;
		_invisibilityTimer = 5;
	}
		
	public void GiveDoubleJump()
	{
		_hasDoubleJump = true;
		_doubleJumpTimer = 12;
	}

	private void HandleMovement(float delta)
	{
		// Player is the new hippa and is freezed.
		if (_gameState.hippaPlayer == HippaID && _gameState.isHippaFreeze)
		{
			return;
		}
		float maxSpeed = _hasHaste ? BaseMaxSpeed * 2 : BaseMaxSpeed;
		float walkForce = _hasHaste ? BaseWalkForce * 2 : BaseWalkForce;
		float stopForce = _hasHaste ? BaseStopForce * 2 : BaseStopForce;
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
		} else if (_doubleJumpReady && _hasDoubleJump && Input.IsActionJustPressed(JumpAction))
		{
			_velocity.y = -JumpSpeed;
			_doubleJumpReady = false;
		}
		
		if (IsOnFloor())
		{
			_doubleJumpReady = true;
		}
	}
	
	private void DecrementPowerups(float delta)
	{
		_hasteTimer -= delta;
		_invisibilityTimer -= delta;
		_doubleJumpTimer -= delta;
		
		if (_hasteTimer <= 0)
		{
			_hasHaste = false;
			_hasteTimer = 0;
		}
		
		if (_invisibilityTimer <= 0)
		{
			_hasInvisibility = false;
			_animatedSprite.Show();
			_light.Show();
			_invisibilityTimer = 0;
		}
		
		if (_doubleJumpTimer <= 0)
		{
			_hasDoubleJump = false;
			_doubleJumpTimer = 0;
		}
	}
}
