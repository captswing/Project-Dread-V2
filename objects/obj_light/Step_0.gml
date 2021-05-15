/// @description Handle Flickering and Lifespans for Temporary Light's Lifespan

if (lifespan > 0){ // Handling timer for a temporary light's lifespan
	lifespan -= global.deltaTime;
	if (lifespan <= 0) {instance_destroy(self);}
}

if (flickerMaxRate > 0 && flickerMinRate > 0){ // Handling timer for flicker effect
	flickerTimer -= global.deltaTime;
	if (flickerTimer <= 0){ // Randomize the timer before the next flicker and the light's intensity during said flicker
		flickerTimer = random_range(flickerMinRate, flickerMaxRate);
		strength = random_range(flickerIntensityMin, flickerIntensityMax);
	}
}