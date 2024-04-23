using Godot;
using System;

public partial class Area2D2 : Area2D
{
	private AnimationPlayer animationPlayer;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		animationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
		animationPlayer.Play("IDLE");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
	
	public void _on_body_entered(Node2D body)
{
	// Check if the entering body is your player or any other specific type of body
	if (body is player2)
	{
		// Change scene when the player enters the area
		GetTree().ChangeSceneToFile("res://gengarscene1.tscn");
	}
	else
	{
		// Handle other types of bodies entering the area, if needed
	}
}


}

