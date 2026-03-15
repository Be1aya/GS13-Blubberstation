/obj/vore_belly
	/// How much fatness is left before we get to the previous weight stage?
	var/fatness_left_to_absorb
	/// How many ticks do we need to take in total to absorb this weight stage?
	var/ticks_needed_to_absorb_weight_stage
	/// How many ticks do we have left before the current weight stage is absorbed?
	var/ticks_left_in_stage

/// Handles weight gain (in fatness) from absorbing mobs
/obj/vore_belly/proc/absorb_fatness(mob/living/pred, mob/living/carbon/prey)
	if(!istype(prey) && prey?.fatness_real) // No fatness to grab
		return FALSE

	if(ticks_left_in_stage) //Move onto the next stage
		var/fat_transfer_amount = (fatness_left_to_absorb / ticks_needed_to_absorb_weight_stage)
		pred.handle_weight_from_vore(fat_transfer_amount, prey)
		prey.adjust_fatness(-fat_transfer_amount, FATTENING_TYPE_ALMIGHTY, TRUE) // You are losing this weight >:(
		ticks_left_in_stage -= 1

		return TRUE

	fatness_left_to_absorb = get_weight_delta_negative(prey.fatness_real)
	if(!fatness_left_to_absorb) // This bitch empty.
		return FALSE

	// get the amount of ticks we need to get to the next stage.
	if(fatness_left_to_absorb < ABSORB_WEIGHT_AMOUNT_SMALL)
		ticks_needed_to_absorb_weight_stage = ABSORB_TICKS_PER_STAGE_SMALL

	else if(fatness_left_to_absorb < ABSORB_WEIGHT_AMOUNT_MEDIUM)
		ticks_needed_to_absorb_weight_stage = ABSORB_TICKS_PER_STAGE_MEDIUM

	else if(fatness_left_to_absorb < ABSORB_WEIGHT_AMOUNT_LARGE)
		ticks_needed_to_absorb_weight_stage = ABSORB_TICKS_PER_STAGE_LARGE

	else if(fatness_left_to_absorb < ABSORB_WEIGHT_AMOUNT_EXCESS)
		ticks_needed_to_absorb_weight_stage = ABSORB_TICKS_PER_STAGE_EXCESS

	else
		ticks_needed_to_absorb_weight_stage = ABSORB_TICKS_PER_STAGE_EXTREME


	ticks_left_in_stage = ticks_needed_to_absorb_weight_stage
	return TRUE
