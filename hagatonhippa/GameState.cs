using Godot;
using System;

public class GameState : Node2D
{	
	/* 
	Player progress
	
	Player1 			   Player2
	120  ------  0  ------ -120
	
	*/
		
	public double progress {private set; get;}
	public const double maxProgress = 120;
	private const double progressPerSec = 4;
	
	public enum hippa : int 
	{
		player1 = 1,
		nobody = 0,
		player2 = -1	
	}
	
	public hippa hippaPlayer { get; set; }
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		GD.Print("Start Game Engine");
		progress = 0;
		// for testing
		hippaPlayer = hippa.player1;
	}

	public override void _Process(float delta)
	{
		progress += delta * progressPerSec * (int)hippaPlayer;
		GD.Print("Progress:" + progress);
	}
}
