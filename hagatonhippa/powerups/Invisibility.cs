using Godot;
using System;

public class Invisibility : Area2D
{
	private AnimatedSprite _animatedSprite;

	public override void _Ready()
	{
		_animatedSprite = GetNode<AnimatedSprite>("AnimatedSprite");
		_animatedSprite.Play("spin");
	}

	private void _on_Invisibility_body_entered(PhysicsBody2D body)
	{
		if ((body as Node2D).Name == "Player1" || (body as Node2D).Name == "Player2")
		{
			(body as Player).GiveInvisibility();
		}
		QueueFree();
	}
}
