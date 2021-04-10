using Godot;
using System;

public class ProgressBar : Godot.ProgressBar
{
	// Declare member variables here. Examples:
	// private int a = 2;
	// private string b = "text";

	private GameState gameState;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		gameState = GetNode<GameState>("../../GameState");
	}

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
   public override void _Process(float delta)
	{
  		Value = (gameState.progress + gameState.maxProgress) / (gameState.maxProgress * 2 / 100); 
	}
}
