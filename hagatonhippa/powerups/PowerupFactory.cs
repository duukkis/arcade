using Godot;
using System;

public class PowerupFactory : Node
{
	[Export] public float SpawnRate = 15;
	private float _timer;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
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
		
	}
}
