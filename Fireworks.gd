extends CPUParticles2D

func play():
	restart()
	emitting = true
	$Yay.play()
