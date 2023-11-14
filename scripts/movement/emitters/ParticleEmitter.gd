extends GPUParticles2D


func _on_player_input_started():
	emitting = true


func _on_player_input_ended():
	emitting = false
