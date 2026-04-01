/// Calculates how much fatness_to_calculate would be in pounds.
/mob/living/carbon/proc/calculate_fatness_weight_in_pounds(fatness_to_calculate)
	var/tauric_weight_multiplier = ((dna.mutant_bodyparts[FEATURE_TAUR] && dna.mutant_bodyparts[FEATURE_TAUR][MUTANT_INDEX_NAME] != "None") ? 2.5 : 1)
	return round((fatness_to_calculate*FATNESS_TO_WEIGHT_RATIO) * (dna.current_body_size ** 2) *tauric_weight_multiplier)

/// Returns the weight of all of the mob's fatness in pounds.
/mob/living/carbon/proc/calculate_total_fatness_weight_in_pounds()
	var/tauric_weight_multiplier = ((dna.mutant_bodyparts[FEATURE_TAUR] && dna.mutant_bodyparts[FEATURE_TAUR][MUTANT_INDEX_NAME] != "None") ? 2.5 : 1)
	return round((fatness*FATNESS_TO_WEIGHT_RATIO) * (dna.current_body_size ** 2) *tauric_weight_multiplier)	// huff, being bigger really does raise the number on that scale by quite a bit huh~?
	//return round((140 + (fatness*FATNESS_TO_WEIGHT_RATIO))*(size_multiplier**2)*((dna.features["taur"] != "None") ? 2.5: 1))

/// Calculates how much muscle_to_calculate would be in pounds.
/mob/living/carbon/proc/calculate_muscle_weight_in_pounds(muscle_to_calculate)
	var/tauric_weight_multiplier = ((dna.mutant_bodyparts[FEATURE_TAUR] && dna.mutant_bodyparts[FEATURE_TAUR][MUTANT_INDEX_NAME] != "None") ? 2.5 : 1)
	return round((muscle_to_calculate*MUSCLE_TO_WEIGHT_RATIO) * (dna.current_body_size ** 2) *tauric_weight_multiplier)

/// Returns the weight of all of the mob's muscles in pounds.
/mob/living/carbon/proc/calculate_total_muscle_weight_in_pounds()
	var/tauric_weight_multiplier = ((dna.mutant_bodyparts[FEATURE_TAUR] && dna.mutant_bodyparts[FEATURE_TAUR][MUTANT_INDEX_NAME] != "None") ? 2.5 : 1)
	return round((muscle*MUSCLE_TO_WEIGHT_RATIO) * (dna.current_body_size ** 2) *tauric_weight_multiplier)

/mob/living/carbon/proc/calculate_weight_in_pounds()
	var/fatness_and_muscle_weight = (calculate_total_fatness_weight_in_pounds() + calculate_total_muscle_weight_in_pounds())
	var/tauric_weight_multiplier = ((dna.mutant_bodyparts[FEATURE_TAUR] && dna.mutant_bodyparts[FEATURE_TAUR][MUTANT_INDEX_NAME] != "None") ? 2.5 : 1)
	var/base_body_weight = (BASE_WEIGHT_VALUE * (dna.current_body_size ** 2) * tauric_weight_multiplier)
	return fatness_and_muscle_weight + base_body_weight

/// Returns the mob's raw combined weight for muscle and fatness in BFI.
/mob/living/carbon/proc/calculate_total_weight_in_bfi()
	return (muscle * MUSCLE_TO_FATNESS_RATIO) + fatness

/// Returns how much weight is scaled on the parent mob. Used for weight calculations. For example, a mob with 200% sprite size will return 4.
/mob/living/carbon/proc/calculate_weight_scale()
	// Add taur support here later so that we can further reduce code.
	return (dna.current_body_size ** 2)

/// Get a mob's total weight in fatness adjusted for their body size
/mob/living/carbon/proc/calculate_adjusted_total_weight_in_bfi()
	return (calculate_total_weight_in_bfi() * calculate_weight_scale())
