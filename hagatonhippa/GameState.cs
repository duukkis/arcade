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
	private const double maxProgress = 120;
	private const double progressPerSec = 4;
	enum hippa : int 
	{
		player1 = 1,
		nobody = 0,
		player2 = -1	
	}
	
	private hippa hippaPlayer = (hippa)1;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		GD.Print("Start Game Engine");
		progress = 0;
	}

	public override void _Process(float delta)
	{
		progress += delta * progressPerSec * (int)hippaPlayer;
		GD.Print("Progress:" + progress);
	}
}
