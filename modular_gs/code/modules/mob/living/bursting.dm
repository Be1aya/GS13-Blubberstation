#define BURSTING_FULLNESS_MIN_THRESHOLD FULLNESS_LEVEL_BLOATED //Minimum fullness threshold for doing any fullness related messages or code
#define BURSTING_FATNESS_MIN_THRESHOLD 0.4 //Percentage of the total fatness capacity needed before doing messages or code
#define BURSTING_FLAVOR_PROB_MAX 0.2 //Maximum message frequency at 100% capacity
#define BURSTING_FLAVOR_PROB_MIN 0.05 //Minimum message frequency at 0% capacity

#define BURSTING_ABOUT_TO_BURST "near_bursting" //Trait used for checking if they're about to burst
#define BURSTING_DELAY_BURST_SECONDS 160 //How long to delay if we delay bursting
#define BURSTING_CONFIRM "Burst Now!" //Button text
#define BURSTING_DENY "Delay" //Button text
#define BURSTING_ANIMATE_TIME 6 //How long in seconds the animation in seconds for bursting should play

//Prefs
#define BURSTING_PREF_DISABLED 0
#define BURSTING_PREF_SAFE 1
#define BURSTING_PREF_FATAL 2
#define BURSTING_PREF_PERMA_FATAL 3

//Sounds
#define BURSTING_SOUND_RATIO 0.3 //The relative ratio between fatness and fullness between eachother for sounds to play
#define BURSTING_SOUND_VOLUME 45
#define BURSTING_CRESCENDO "modular_gs/sound/effects/inflation/pop/bursting_crescendo.ogg"
#define BURSTING_CRESCENDO_DELAY "modular_gs/sound/effects/inflation/berryloop.ogg"
#define BURSTING_BURST "modular_gs/sound/effects/inflation/pop/burst_thump.ogg"
#define BURSTING_GURGLE_SOUNDS list(\
	'modular_gs/sound/voice/gurgle1.ogg',\
	'modular_gs/sound/voice/gurgle2.ogg',\
	'modular_gs/sound/voice/gurgle3.ogg'\
)

//These are just being used as placeholders for now
#define BURSTING_FAT_SLOSH_SOUNDS list(\
	'modular_gs/sound/effects/inflation/sloshing/slosh_1.ogg',\
	'modular_gs/sound/effects/inflation/sloshing/slosh_2.ogg',\
	'modular_gs/sound/effects/inflation/sloshing/slosh_3.ogg'\
)

#define BURSTING_FLAVOR_FULL list(\
	"Phew... I'm stuffed...",\
	"Feeling pretty full...",\
	"So stuffed...",\
	"Oof... so full...",\
	"You feel a slight heft in your stomach..."\
)

#define BURSTING_FLAVOR_STUFFED list(\
	"Ough... So much...",\
	"I feel so full...",\
	"I couldn't eat another bite...",\
	"Too... full...",\
	"You feel your stomach groan with fullness",\
	"Your stomach sloshes with fullness as you move",\
	"You feel extremely full",\
	"Your belly bloats to make room"\
)

#define BURSTING_FLAVOR_OVERSTUFFED list(\
	"Can't... hold... any... more...",\
	"Too... much...",\
	"Ugh... getting too... full...",\
	"Can't... eat... any more...",\
	"Your belly swells with pressure",\
	"Your stomach rumbles with fullness",\
	"You feel immensely full",\
	"You feel your belly churn and gurgle with fullness"\
)

#define BURSTING_FLAVOR_NEARBURST list(\
	"Too... full... gonna... burst...",\
	"Can't hold it...",\
	"Too much...! I'm gonna... burst...",\
	"My stomach's... Too... full...",\
	"You feel like your stomach is way too full!",\
	"Your stomach rumbles and groans, you're way too full!",\
	"You feel your belly stretch and creak as it struggles to make room"\
)

#define BURSTING_FLAVOR_VERYFAT list(\
	"I'm so heavy...",\
	"So soft...",\
	"I feel so soft...",\
	"My body's so jiggly...",\
	"You're feeling quite heavy"\
)

#define BURSTING_FLAVOR_SUPEROBESE list(\
	"Getting so big...",\
	"I'm getting so... fat...",\
	"So heavy... so squishy...",\
	"hff... I'm so fat... so wobbly...",\
	"You feel your body wobble with fat",\
	"Fat swells your body even bigger",\
	"Your body feels quite heavy",\
	"You feel your rolls of fat swell bigger"\
)

#define BURSTING_FLAVOR_EXTREMELYDOUGHY list(\
	"Getting... too... huge...",\
	"hff... too much... fat..",\
	"So much fat... I can't...",\
	"I'm getting so... heavy... So doughy...",\
	"Your rolls swell together as your fat swells larger",\
	"Your body stetches as your fat swells inside you!",\
	"You feel extremely heavy",\
	"Your massive body wobbles as fat swells you bigger",\
)

#define BURSTING_FLAVOR_OVERWHELMINGFATNESS list(\
	"Getting... way too... massive...",\
	"Too... fat... gonna... burst...",\
	"Too much fat... Can't... hold it...! I'm gonna burst!",\
	"There's too much fat... I'm getting too... big",\
	"Your extremely fat body wobbles as fat begins to overwhelm you!",\
	"You feel like you're about to burst, your body is getting too fat!",\
	"You feel your body creak and rumble as your fat body swells",\
	"Your rolls squeeze together and creak as growing fat swells them tight"\
)

#define BURSTING_MACRO_CHECK_THRESHOLD(percentageA, percentageB) (percentageA > percentageB * BURSTING_SOUND_RATIO)

///Gets the players bursting type pref, returns a number coresponding to said pref
/mob/living/carbon/human/proc/get_bursting_pref()
	switch(client?.prefs?.read_preference(/datum/preference/choiced/glutton_bursting_type))
		if ("Safe")
			return BURSTING_PREF_SAFE

		if ("Fatal")
			return BURSTING_PREF_FATAL

		if ("Permanent Fatal")
			return BURSTING_PREF_PERMA_FATAL

		else
			return BURSTING_PREF_DISABLED

///Handles bursting for either eating too much or too high of a BFI, returns a bool for whether or not the character burst or is in the process of doing so
/mob/living/carbon/human/proc/handle_bursting()

	//Get prefs
	var/fullness_bursting_pref = client?.prefs?.read_preference(/datum/preference/numeric/helplessness/glutton_fullness_before_burst)
	var/fatness_bursting_pref = client?.prefs?.read_preference(/datum/preference/numeric/helplessness/glutton_fatness_before_burst)
	var/bursting_type_pref = get_bursting_pref()



	if (!client?.prefs?.read_preference(/datum/preference/toggle/glutton_see_bursting)) //Check if the person can even see bursting, no sense in running any of this if that's the case
		return FALSE

	//Adjust the thresholds to be relative to our minimum values so that the code doesn't run below a certain point
	var/relative_fullness_threshold = max(fullness_bursting_pref - BURSTING_FULLNESS_MIN_THRESHOLD, BURSTING_FULLNESS_MIN_THRESHOLD)
	var/relative_fatness_threshold = fatness_bursting_pref * BURSTING_FATNESS_MIN_THRESHOLD
	var/relative_fullness = max(get_fullness() - BURSTING_FULLNESS_MIN_THRESHOLD, 0)
	var/relative_fatness = max(fatness - fatness_bursting_pref  * (1 - BURSTING_FATNESS_MIN_THRESHOLD), 0)

	var/capacity_fullness = fullness_bursting_pref != 0 ? relative_fullness / relative_fullness_threshold  : -1 //Our glutton's fullness percentage, -1 flag if disabled
	var/capacity_fatness = fatness_bursting_pref != 0 ? relative_fatness / relative_fatness_threshold : -1 //Our glutton's fatness percentage, -1 flag if disabled
	var/capacity_percentage = max(capacity_fullness, capacity_fatness) //Use the greater percentage to determine if our glutton should burst, -1 if bursting types are disabled

	var/burst_type_fullness = capacity_fullness >= capacity_fatness


	if (capacity_percentage <= 0)
		return FALSE

	var/flavor_message_chance = clamp((BURSTING_FLAVOR_PROB_MAX - BURSTING_FLAVOR_PROB_MIN) * capacity_percentage + BURSTING_FLAVOR_PROB_MIN, BURSTING_FLAVOR_PROB_MIN, BURSTING_FLAVOR_PROB_MAX)
	if (prob(flavor_message_chance * 100))


		//Handles the random messages, picking based on the stage of capacity we're at
		var/message_content = ""
		var/message_stage = clamp(round(capacity_percentage * 3.5 + 1), 1, 4) //Takes the capacity percentage and converts it into four equaly sized whole number 'stages' to be used as an index for selecting messages

		if (burst_type_fullness)
			message_content = pick(list(
				BURSTING_FLAVOR_FULL,
				BURSTING_FLAVOR_STUFFED,
				BURSTING_FLAVOR_OVERSTUFFED,
				BURSTING_FLAVOR_NEARBURST
			)[message_stage])
		else
			message_content = pick(list(
				BURSTING_FLAVOR_VERYFAT,
				BURSTING_FLAVOR_SUPEROBESE,
				BURSTING_FLAVOR_EXTREMELYDOUGHY,
				BURSTING_FLAVOR_OVERWHELMINGFATNESS
			)[message_stage])

		if (BURSTING_MACRO_CHECK_THRESHOLD(capacity_fullness, capacity_fatness))
			playsound(src.loc, pick(BURSTING_GURGLE_SOUNDS), BURSTING_SOUND_VOLUME, 1, 1, 1.2, ignore_walls = FALSE)

		if (BURSTING_MACRO_CHECK_THRESHOLD(capacity_fatness, capacity_fullness))
			playsound(src.loc, pick(BURSTING_FAT_SLOSH_SOUNDS), BURSTING_SOUND_VOLUME, 1, 1, 1.2, ignore_walls = FALSE)

		to_chat(src, span_warning(message_content))

	//Trigger the burst
	if (bursting_type_pref != BURSTING_PREF_DISABLED && capacity_percentage > 1 && !HAS_TRAIT(src, BURSTING_ABOUT_TO_BURST))
		trigger_glutton_burst(burst_type_fullness, bursting_type_pref)
		return TRUE

	return FALSE

///Opens the tgui popup for deciding wether or not burst fullness or fattness
/mob/living/carbon/human/proc/trigger_glutton_burst(burst_type, bursting_type_pref)

	//Add self removing trait so that bursting doesn't repeatedly trigger, dual purpose as our delay if the delay button is pressed and a cooldown to delay repeated bursting
	ADD_TRAIT(src, BURSTING_ABOUT_TO_BURST, TRAUMA_TRAIT)
	addtimer(TRAIT_CALLBACK_REMOVE(src, BURSTING_ABOUT_TO_BURST, TRAUMA_TRAIT), BURSTING_DELAY_BURST_SECONDS SECONDS)

	//TGUI popup to confirm bursting
	var/burst_choice = tgui_alert(
		src,
		"You've exceeded your capacity and gotten too [burst_type ? "full" : "fat"]. You're now on the verge of bursting, but you might be able to hold together a bit longer...If you click [BURSTING_CONFIRM] if you wish to burst and you will explode after a short delay[bursting_type_pref >= BURSTING_PREF_FATAL ? ", which will kill you since you have safe bursting disabled." : "."]Otherwise, click [BURSTING_DENY] which will delay bursting for bit if you're still over capacity.",
		"You're about to burst!",
		list(BURSTING_CONFIRM, BURSTING_DENY)
	)

	//Start the burst if confirm is clicked, which will animate our character swelling and start a callback for our bursting function
	if (burst_choice == BURSTING_CONFIRM)
		visible_message(span_warning("[src] begins to swell as they're overwhelmed by their [burst_type ? "fullness" : "fatness"]!"), span_warning("Your body begins to swell as your [burst_type ? "fullness" : "fatness"] overwhelms you!"))
		addtimer(CALLBACK(src, PROC_REF(burst_glutton)), BURSTING_ANIMATE_TIME SECONDS) //Bursts the character
		var/matrix/scale_transform = matrix()
		scale_transform.Scale(1.8, 1.1)
		playsound(src.loc, BURSTING_CRESCENDO, BURSTING_SOUND_VOLUME, 1, 1, 1.2, ignore_walls = FALSE)
		animate(src, time = BURSTING_ANIMATE_TIME SECONDS, transform = transform * scale_transform, easing = SINE_EASING)



///Makes our glutton explode, using the character's original transform to restore their shape if there's safe bursting
/mob/living/carbon/human/proc/burst_glutton()
	if (!check_prefs_in_view(/datum/preference/toggle/glutton_see_bursting, src.loc)) //Check surrounding area if anyone will see them explode who would not want to
		visible_message(
			span_warning("[src] makes a loud creak as the swelling stops on the verge of bursting, the seem to be holding together for now... (People with bursting prefs disabled are in view!)"),
			span_warning("You make a loud creak as the swelling momentarily stops as you struggle to hold together... (Someone with bursting prefs disabled are in view!)")
		)
		playsound(src.loc, BURSTING_CRESCENDO_DELAY, BURSTING_SOUND_VOLUME, 1, 1, 1.2, ignore_walls = FALSE)
		addtimer(CALLBACK(src, PROC_REF(burst_glutton)), 8 SECONDS) //Delay for the duration of the sound
		return


	//Continue with the burst
	playsound(src.loc, BURSTING_BURST, BURSTING_SOUND_VOLUME, 1, 1, 1.2, ignore_walls = FALSE)
	visible_message(span_warning("[src]'s body lets out a final creak before bursting!"), span_warning("You feel your body let out a creak as the pressure becomes too much and then bursts!"))

	//Set fatness before using the blueberry gib since that cryos you
	fatness_real = fatness_real/4
	fatness_perma = fatness_perma/2

	switch(get_bursting_pref()) //Get the bursting pref again incase the person changes their mind
		if (BURSTING_PREF_FATAL)
			blueberry_gib(client?.prefs?.read_preference(/datum/preference/toggle/glutton_leave_gibs))
			return

		if (BURSTING_PREF_PERMA_FATAL)
			gib(DROP_ALL_REMAINS)
			return

		if (BURSTING_PREF_SAFE)
			var/datum/effect_system/fluid_spread/smoke/burst_smoke/bursting_smoke = new
			bursting_smoke.set_up(2, holder = src, location = src)
			bursting_smoke.start()

			//Animate and return our transform back to normal
			var/matrix/original_transform = matrix(dna.current_body_size, 0, 0, 0, dna.current_body_size, 16 * dna.current_body_size - 16)
			animate(src, time = 0.1, transform = original_transform, easing = SINE_EASING)


			//Clear reagents
			organs_slot["stomach"]?:reagents?:reagent_list = list()
			reagents.reagent_list = list()
			return

		else
			return


//Bursting smoke
/obj/effect/particle_effect/fluid/smoke/burst_smoke
	name = "Bursting Smoke"
	color = COLOR_LIGHT_GRAYISH_RED
	lifetime = 1 SECONDS

/datum/effect_system/fluid_spread/smoke/burst_smoke
	effect_type = /obj/effect/particle_effect/fluid/smoke/burst_smoke

#undef BURSTING_FULLNESS_MIN_THRESHOLD
#undef BURSTING_FATNESS_MIN_THRESHOLD
#undef BURSTING_FLAVOR_PROB_MAX
#undef BURSTING_FLAVOR_PROB_MIN

#undef BURSTING_ABOUT_TO_BURST
#undef BURSTING_DELAY_BURST_SECONDS
#undef BURSTING_CONFIRM
#undef BURSTING_DENY
#undef BURSTING_ANIMATE_TIME
#undef BURSTING_SOUND_VOLUME

#undef BURSTING_PREF_DISABLED
#undef BURSTING_PREF_SAFE
#undef BURSTING_PREF_FATAL
#undef BURSTING_PREF_PERMA_FATAL

#undef BURSTING_CRESCENDO
#undef BURSTING_CRESCENDO_DELAY
#undef BURSTING_BURST
#undef BURSTING_GURGLE_SOUNDS
#undef BURSTING_FAT_SLOSH_SOUNDS

#undef BURSTING_FLAVOR_FULL
#undef BURSTING_FLAVOR_STUFFED
#undef BURSTING_FLAVOR_OVERSTUFFED
#undef BURSTING_FLAVOR_NEARBURST

#undef BURSTING_FLAVOR_VERYFAT
#undef BURSTING_FLAVOR_SUPEROBESE
#undef BURSTING_FLAVOR_EXTREMELYDOUGHY
#undef BURSTING_FLAVOR_OVERWHELMINGFATNESS

#undef BURSTING_MACRO_CHECK_THRESHOLD
