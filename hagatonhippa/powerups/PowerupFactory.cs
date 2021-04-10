using Godot;
using System;

public class PowerupFactory : Node
{
	[Export] public float SpawnRate = 15;
	private PackedScene doubleJumpRes;
	private PackedScene hasteRes;
	private PackedScene invisibilityRes;
	private float _timer;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		doubleJumpRes = (PackedScene)GD.Load("res://powerups/DoubleJump.tscn");
		hasteRes = (PackedScene)GD.Load("res://powerups/Haste.tscn");
		invisibilityRes = (PackedScene)GD.Load("res://powerups/Invisibility.tscn");
		
		_timer = SpawnRate;
	}

	public override void _Process(float delta)
  	{
		_timer -= delta;
		
		if (_timer <= 0)
		{
			_timer = SpawnRate;
			SpawnRandomPowerup();
		}      
  	}
	
	private void SpawnRandomPowerup()
	{
		Random rnd = new Random();
		int index = rnd.Next(0, 3);
		int posX = rnd.Next(64, 544);
		int posY = rnd.Next(64, 544);
		Vector2 randomPosition = new Vector2(posX, posY);
		GD.Print("spawning");
		GD.Print(randomPosition);
		GD.Print(index);
		switch(index)
		{
			case 0:
				Node2D doublejump = (Node2D)doubleJumpRes.Instance();
				doublejump.SetPosition(randomPosition);
				AddChild(doublejump);
				break;
			case 1:
				Node2D haste = (Node2D)hasteRes.Instance();
				haste.SetPosition(randomPosition);
				AddChild(haste);
				break;
			case 2:
			default:
				Node2D invisibility = (Node2D)invisibilityRes.Instance();
				invisibility.SetPosition(randomPosition);
				AddChild(invisibility);
				break;
		}
	}
}
