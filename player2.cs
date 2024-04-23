using Godot;
using System;

public partial class player2 : CharacterBody2D
{
	public const float Speed = 100.0f;
	public const float JumpVelocity = -300.0f;

	// Get the gravity from the project settings to be synced with RigidBody nodes.
	public float gravity = ProjectSettings.GetSetting("physics/2d/default_gravity").AsSingle();
	
	// Reference to the AnimationPlayer node
	private AnimationPlayer animationPlayer;

	public override void _Ready()
	{
		animationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
	}
	

	public override void _PhysicsProcess(double delta)
	{
		Vector2 velocity = Velocity;

		// Add the gravity.
		if (!IsOnFloor())
			velocity.Y += gravity * (float)delta;

		// Handle Jump.
		if (Input.IsActionJustPressed("ui_accept") && IsOnFloor())
			velocity.Y = JumpVelocity;

		// Get the input direction and handle the movement/deceleration.
		// As good practice, you should replace UI actions with custom gameplay actions.
		Vector2 direction = Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down");
		if (direction != Vector2.Zero)
		{
			velocity.X = direction.X * Speed;

			// Set the appropriate animation based on the direction
			if (direction.X > 0)
				animationPlayer.Play("RunRight");
				
			else
				animationPlayer.Play("RunLeft");
			
		}
		else
		{
			velocity.X = Mathf.MoveToward(Velocity.X, 0, Speed);
			GD.Print("Move!");
		}

		Velocity = velocity;
		MoveAndSlide();
	}
	public void _on_area_2d_area_entered(Area2D area)
{
	if (area.IsInGroup("Portal"))
	{
		Node2D secondFloor = GetParent().GetNode<Node2D>("secondfloor");
		if (secondFloor != null && secondFloor.IsInGroup("Portal2"))
		{
			// CharacterBody2D player = GetTree().GetRoot().GetNode<Area2D>("Pikaplatformer"); // Replace "path_to_player_node" with the actual path to the player node
			// if (player != null)
			{
				// player.Position = secondFloor.Position;
			}
		}
	}
}

}



