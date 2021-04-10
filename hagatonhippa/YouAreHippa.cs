using Godot;
using System;

public class YouAreHippa : Label
{
	private GameState _gameState;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
			_gameState = GetNode<GameState>("../../GameState");
	}

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
  	public override void _Process(float delta)
  	{
			 Visible = _gameState.isHippaFreeze;
	}
}
