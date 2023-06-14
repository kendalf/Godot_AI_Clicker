extends CPUParticles2D

func play():
	if emitting:
		emitting = false
	emitting = true
	$Yay.play()
