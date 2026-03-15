/obj/vore_belly
	/// Do we want to show prey's fatness
	var/use_fat_hiders = FALSE
	var/use_flat_fat_hiders = FALSE

/// Sets the amount of fatness that's added from held prey. `use_flat_fatness` toggles between using adding the raw fatness from prey or having the amount of fatness they add be based on their actual value in pounds.
/obj/vore_belly/proc/fat_hide()
	var/mob/living/carbon/carbon_pred = owner.parent
	if(!use_fat_hiders || !istype(carbon_pred)) // If we can't hide fatness, then don't even bother.
		return FALSE

	var/total_prey_value_adjusted = 0
	var/total_prey_value_fatness = 0

	for(var/mob/living/prey in src)
		var/mob/living/carbon/carbon_prey = prey
		if(!istype(carbon_prey))
			if(!prey.digestion_fat_yield)
				continue //They ain't got no meat on their bones!

			total_prey_value_fatness += prey.digestion_fat_yield
			total_prey_value_adjusted += prey.digestion_fat_yield
			continue

		total_prey_value_fatness += carbon_prey.calculate_total_weight_in_bfi()
		total_prey_value_adjusted += carbon_prey.calculate_adjusted_total_weight_in_bfi()

	if(use_flat_fat_hiders)
		return total_prey_value_fatness

	total_prey_value_adjusted = (total_prey_value_adjusted * carbon_pred.calculate_weight_scale()) // Combine the total adjusted fatness with the pred's weight ratio.

	return total_prey_value_adjusted



