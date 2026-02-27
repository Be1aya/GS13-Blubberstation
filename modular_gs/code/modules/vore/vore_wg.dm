/// Handles weight gain from vore.
/obj/vore_belly/proc/handle_vore_weight_gain(mob/living/carbon/pred, mob/living/prey)
	if(!istype(pred))
		return FALSE // No fatness, no dice.

	var/prey_weight_value = prey.digestion_fat_yield
	var/mob/living/carbon/carbon_prey = prey
	if(istype(carbon_prey))
		prey_weight_value = carbon_prey.fatness_real //Use actual fatness if it's present

	if(prey_weight_value < 1) // Too low calorie.
		return FALSE

	pred.adjust_fatness(prey_weight_value * FATNESS_FROM_VORE, FATTENING_TYPE_FOOD)
	pred.carbons_digested += 1

	return TRUE

