extends GPUParticles2D


func _on_input_component_input_started(input):
	emitting = true


func _on_input_component_input_ended():
	emitting = false
