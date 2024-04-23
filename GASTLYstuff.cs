using Godot;
using System;

public partial class GASTLYstuff : AnimatableBody2D
{
	private AnimationPlayer animationPlayer;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		animationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
		animationPlayer.Play("move");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	
}
