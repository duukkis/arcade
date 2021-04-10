using Godot;
using System;

public class Haste : Area2D
{
	private void _on_Haste_body_entered(PhysicsBody2D body)
	{
		if ((body as Node2D).Name == "Player1" || (body as Node2D).Name == "Player2")
		{
			(body as Player).GiveHaste();
		}
		QueueFree();
	}
}
