/// Handles weight gain from vore.
/obj/vore_belly/proc/handle_vore_weight_gain(mob/living/pred, mob/living/prey)
	if(!istype(pred))
		return FALSE

	var/prey_weight_value = prey.digestion_fat_yield
	var/permafat_from_prey = 0
	var/calorite_poisoning_from_prey = 0

	var/mob/living/carbon/carbon_prey = prey
	if(istype(carbon_prey))
		prey_weight_value = carbon_prey.fatness_real //Use actual fatness if it's present
		prey_weight_value += carbon_prey.muscle_real * MUSCLE_TO_FATNESS_RATIO_VORE // Muscle can be broken down into a lot of calories because it's hot.
		permafat_from_prey = carbon_prey.fatness_perma * VORE_TRANSFER_PERMAFAT
		calorite_poisoning_from_prey = carbon_prey.micro_calorite_poisoning * VORE_TRANSFER_CALORITE_POISONING

	var/mob/living/carbon/carbon_pred = pred
	if(istype(carbon_pred))
		// We don't need to worry about checking prefs here because the procs already do it
		if(permafat_from_prey && carbon_pred.adjust_perma(permafat_from_prey, FATTENING_TYPE_FOOD, TRUE))
			carbon_prey.adjust_perma(-permafat_from_prey, FATTENING_TYPE_ALMIGHTY, TRUE)

		if(calorite_poisoning_from_prey && carbon_pred.adjust_calorite_poisoning(calorite_poisoning_from_prey))
			carbon_prey.adjust_calorite_poisoning(-calorite_poisoning_from_prey)

	if(prey_weight_value < 1) // Too low calorie.
		return FALSE

	return pred.handle_weight_from_vore(prey_weight_value, prey, TRUE)

/// How is the weight from vore added to the pred?
/mob/living/proc/handle_weight_from_vore(weight_gain_amount, mob/living/prey, prey_digested = FALSE, modifier = FATNESS_FROM_VORE)
	return FALSE

/mob/living/carbon/handle_weight_from_vore(weight_gain_amount, mob/living/prey, prey_digested = FALSE, modifier = FATNESS_FROM_VORE)
	if(!weight_gain_amount)
		return FALSE

	adjust_fatness(weight_gain_amount * modifier, FATTENING_TYPE_FOOD)
	if(prey_digested && iscarbon(prey))
		carbons_digested += 1

	return TRUE
