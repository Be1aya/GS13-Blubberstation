
//Some temporary placeholder values to be replaced later with individually checked prefs!
#define PLACEHOLDER_THRESHOLD_FULLNESS FULLNESS_LEVEL_NOMOREPLZ
#define PLACEHOLDER_THRESHOLD_FATNESS FATNESS_LEVEL_EXTREMELY_OBESE
#define PLACEHOLDER_BURST_FULLNESS TRUE
#define PLACEHOLDER_BURST_FATNESS TRUE

#define BURSTING_FULLNESS_MIN_THRESHOLD FULLNESS_LEVEL_BLOATED //Minimum fullness threshold for doing any fullness related messages or code
#define BURSTING_FATNESS_MIN_THRESHOLD 0.5 //Percentage of the total fatness capacity needed before doing messages or code
#define BURSTING_FLAVOR_PROB_MAX 0.2 //Maximum message frequency at 100% capacity
#define BURSTING_FLAVOR_PROB_MIN 0.05 //Minimum message frequency at 0% capacity

#define BURSTING_ABOUT_TO_BURST "near_bursting" //Trait used for checking if they're about to burst
#define BURSTING_DELAY_BURST_SECONDS 160 //How long to delay if we delay bursting
#define BURSTING_CONFIRM "Burst Now!" //Button text
#define BURSTING_DENY "Delay" //Button text
#define BURSTING_ANIMATE_TIME 10 //How long the animation for bursting should play

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
	"There's too much... fat... I'm getting too... big",\
	"Your extremely fat body wobbles as fat begins to overwhelm you!",\
	"You feel like you're about to burst, your body is getting too fat!",\
	"You feel your body creak and rumble as your fat body swells",\
	"Your rolls squeeze together and creak as growing fat swells them tight"\
)
//Handles bursting for either eating too much or too high of a BFI
/mob/living/carbon/human/proc/handle_bursting()

	//Adjust the thresholds to be relative to our minimum values so that the code doesn't run below a certain point
	var/relativeFullnessThreshold = max(PLACEHOLDER_THRESHOLD_FULLNESS - BURSTING_FULLNESS_MIN_THRESHOLD, BURSTING_FULLNESS_MIN_THRESHOLD)
	var/relativeFatnessThreshold = PLACEHOLDER_THRESHOLD_FATNESS * BURSTING_FATNESS_MIN_THRESHOLD
	var/relativeFullness = max(src.get_fullness() - BURSTING_FULLNESS_MIN_THRESHOLD, 0)
	var/relativeFatness = max(src.fatness - relativeFatnessThreshold, 0)

	var/capacityFullness = PLACEHOLDER_BURST_FULLNESS ? relativeFullness / relativeFullnessThreshold  : -1 //Our glutton's fullness percentage, -1 flag if disabled
	var/capacityFatness = PLACEHOLDER_BURST_FATNESS ? relativeFatness / relativeFatnessThreshold : -1 //Our glutton's fatness percentage, -1 flag if disabled
	var/capacityPercentage = max(capacityFullness, capacityFatness) //Use the greater percentage to determine if our glutton should burst, -1 if bursting types are disabled

	var/burstTypeFullness = capacityFullness >= capacityFatness
	var/safeBurstingDisabled = !client?.prefs?.read_preference(/datum/preference/toggle/safe_bursting)

	usr << capacityPercentage

	if (capacityPercentage <= 0)
		return FALSE

	var/flavorMessageChance = (BURSTING_FLAVOR_PROB_MAX - BURSTING_FLAVOR_PROB_MIN) * capacityPercentage + BURSTING_FLAVOR_PROB_MIN
	if (flavorMessageChance > rand())


		//Handles the random messages
		var/messageContent = ""
		var/messageStage = clamp(round(capacityPercentage * 3.5 + 1), 1, 4)

		if (burstTypeFullness)
			messageContent = pick(list(
				BURSTING_FLAVOR_FULL,
				BURSTING_FLAVOR_STUFFED,
				BURSTING_FLAVOR_OVERSTUFFED,
				BURSTING_FLAVOR_NEARBURST
			)[messageStage])
		else
			messageContent = pick(list(
				BURSTING_FLAVOR_VERYFAT,
				BURSTING_FLAVOR_SUPEROBESE,
				BURSTING_FLAVOR_EXTREMELYDOUGHY,
				BURSTING_FLAVOR_OVERWHELMINGFATNESS
			)[messageStage])

		to_chat(src, "<span class='warning'>[messageContent]</span>")

	//Trigger the burst
	if (capacityPercentage > 1 && !HAS_TRAIT(src, BURSTING_ABOUT_TO_BURST))
		trigger_glutton_burst(burstTypeFullness, safeBurstingDisabled)
		return TRUE
	return FALSE

/mob/living/carbon/human/proc/trigger_glutton_burst(burstType, safeBurstingDisabled)
	//Add self removing trait so that bursting doesn't repeatedly trigger, dual purpose as our delay
	ADD_TRAIT(src, BURSTING_ABOUT_TO_BURST, TRAUMA_TRAIT)
	addtimer(TRAIT_CALLBACK_REMOVE(src, BURSTING_ABOUT_TO_BURST, TRAUMA_TRAIT), BURSTING_DELAY_BURST_SECONDS SECONDS)

	//TGUI popup to confirm bursting
	var/burstChoice = tgui_alert(
		src,
		"You've exceeded your capacity and gotten too [burstType ? "full" : "fat"]. You're now on the verge of bursting, but you might be able to hold together a bit longer...If you click [BURSTING_CONFIRM] if you wish to burst and you will explode after a short delay[safeBurstingDisabled ? ", which will kill you since you have safe bursting disabled." : "."]Otherwise, click [BURSTING_DENY] which will delay bursting for bit if you're still over capacity.",
		"You're about to burst!",
		list(BURSTING_CONFIRM, BURSTING_DENY)
	)

	//Start the burst if confirm is clicked
	if (burstChoice == BURSTING_CONFIRM)
		visible_message("<span class='warning'>[src] begins to swell as they're overwhelmed by their [burstType ? "fullness" : "fatness"]!</span>", "<span class='warning'>Your body begins to swell as your [burstType ? "fullness" : "fatness"] overwhelms you!</span>")
		addtimer(CALLBACK(src, PROC_REF(burst_glutton), safeBurstingDisabled, src.transform), BURSTING_ANIMATE_TIME SECONDS) //Bursts the
		var/matrix/scaleTransform = matrix()
		scaleTransform.Scale(1.8, 1.1)
		animate(src, time = BURSTING_ANIMATE_TIME SECONDS, transform = src.transform * scaleTransform, easing = SINE_EASING)

//Makes our glutton explode
/mob/living/carbon/human/proc/burst_glutton(safeBurstingDisabled, matrix/originalTransform)
	if (safeBurstingDisabled)
		gib(DROP_ALL_REMAINS)
	else
		//Make smoke if we safe burst
		var/datum/effect_system/fluid_spread/smoke/burstSmoke/burstingSmoke = new
		burstingSmoke.set_up(2, holder = src, location = src)
		burstingSmoke.start()

		//Animate and return our transform back to normal
		animate(src, time = 0.1, transform = originalTransform, easing = SINE_EASING)

		//Clear reagents and fatness
		src?:organs_slot["stomach"]?:reagents?:reagent_list = list()
		src.reagents.reagent_list = list()
		src.fatness_real = 0
		src.fatness_perma = 0

//Bursting smoke
/obj/effect/particle_effect/fluid/smoke/burstSmoke
	name = "Bursting Smoke"
	color = COLOR_LIGHT_GRAYISH_RED
	lifetime = 1 SECONDS

/datum/effect_system/fluid_spread/smoke/burstSmoke
	effect_type = /obj/effect/particle_effect/fluid/smoke/burstSmoke

#undef PLACEHOLDER_THRESHOLD_FULLNESS
#undef PLACEHOLDER_THRESHOLD_FATNESS
#undef PLACEHOLDER_BURST_FULLNESS
#undef PLACEHOLDER_BURST_FATNESS

#undef BURSTING_FULLNESS_MIN_THRESHOLD
#undef BURSTING_FATNESS_MIN_THRESHOLD
#undef BURSTING_FLAVOR_PROB_MAX
#undef BURSTING_FLAVOR_PROB_MIN

#undef BURSTING_ABOUT_TO_BURST
#undef BURSTING_DELAY_BURST_SECONDS
#undef BURSTING_CONFIRM
#undef BURSTING_DENY
#undef BURSTING_ANIMATE_TIME

#undef BURSTING_FLAVOR_FULL
#undef BURSTING_FLAVOR_STUFFED
#undef BURSTING_FLAVOR_OVERSTUFFED
#undef BURSTING_FLAVOR_NEARBURST

#undef BURSTING_FLAVOR_VERYFAT
#undef BURSTING_FLAVOR_SUPEROBESE
#undef BURSTING_FLAVOR_EXTREMELYDOUGHY
#undef BURSTING_FLAVOR_OVERWHELMINGFATNESS
