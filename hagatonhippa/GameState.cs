using Godot;	
using System;

public class GameState : Node2D
{	
	[Export] public double freezeTime;
	[Export] public double maxProgress;
	
	public double progress {private set; get;}
	private double freezeTimer;
	
	private const double progressPerSec = 4;
		
	public enum hippa : int 
	{
		player1 = 1,
		nobody = 0,
		player2 = -1	
	}
	
	public hippa hippaPlayer {get; private set;}
	
	public void changeHippa() {
		if (!isHippaFreeze) {
			freezeTimer = freezeTime;
			hippaPlayer = (hippa)((int)hippaPlayer*-1);
		}
	}
	
	public bool isHippaFreeze {get {
		return (freezeTimer > 0);
	}}
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		progress = 0;
		// for testing
		hippaPlayer = hippa.player1;
	}

	public override void _Process(float delta)
	{
		if (isHippaFreeze) {
			freezeTimer -= delta;
		}
		progress += delta * progressPerSec * (int)hippaPlayer;
	}
}
