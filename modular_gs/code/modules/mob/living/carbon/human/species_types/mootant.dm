//temporarily commented out to add the parts back in
/*
/mob/living/carbon/human/species/mammal/mootant
	race = /datum/species/mammal/mootant

/datum/species/mammal/mootant //WIP species
	name = "Mootant"
	id = SPECIES_MOOTANT
	default_color = "FFFFFF"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,HAIR,HORNCOLOR,WINGCOLOR,HAS_FLESH,HAS_BONE)
	inherent_traits = list(TRAIT_CHUNKYFINGERS, TRAIT_VORACIOUS, TRAIT_LIPOLICIDE_TOLERANCE, TRAIT_PACIFISM, TRAIT_MILKY, TRAIT_HEAT) //chunky fingers because hooves!
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BEAST
	mutant_bodyparts = list("mcolor" = "FFFFFF","mcolor2" = "FFFFFF","mcolor3" = "FFFFFF", "mam_snouts" = "Mootant ALT (Tertiary)", "mam_tail" = "Mootant", "mam_ears" = "Mootant ALT (Tertiary)", "deco_wings" = "None",
							"mam_body_markings" = list(), "taur" = "None", "horns" = "None", "legs" = "Plantigrade", "meat_type" = "Mammalian")
	attack_verb = "claw"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/food/meat/slab/human/mutant/mammal
	// mutant_organs = list(/obj/item/organ/genital/breasts) //moo
	liked_food = FRIED | DAIRY
	disliked_food = TOXIC | MEAT

	tail_type = "mam_tail"
	wagging_type = "mam_waggingtail"
	species_category = SPECIES_CATEGORY_FURRY

	allowed_limb_ids = list("mammal","aquatic","avian")
*/

//mootant body parts
//maws
/datum/sprite_accessory/snouts/mammal/mootant
	name = "Mootant"
	icon = 'modular_gs/icons/mob/markings/mam_snouts.dmi'
	icon_state = "mootant"

//ears
/datum/sprite_accessory/ears/mootant
	name = "Mootant"
	icon_state = "mootant"
	icon = 'modular_gs/icons/mob/markings/mam_ears.dmi'

/datum/sprite_accessory/ears/human/mootant
	name = "Mootant"
	icon_state = "mootant"
	icon = 'modular_gs/icons/mob/markings/mam_ears.dmi'

/datum/sprite_accessory/ears/mootant_larger
	name = "Mootant (Larger)"
	icon_state = "mootant_larger"
	icon = 'modular_gs/icons/mob/markings/mam_ears.dmi'

/datum/sprite_accessory/ears/human/mootant_larger
	name = "Mootant (Larger)"
	icon_state = "mootant_larger"
	icon = 'modular_gs/icons/mob/markings/mam_ears.dmi'

//tails
/datum/sprite_accessory/tails/human/mootant
	name = "Mootant"
	icon_state = "mootant"
	icon = 'modular_gs/icons/mob/markings/mam_tails.dmi'

/datum/sprite_accessory/tails/mammal/mootant
	name = "Mootant"
	icon_state = "mootant"
	icon = 'modular_gs/icons/mob/markings/mam_tails.dmi'

//mutation toxin
//temporarily commented out to add the parts back in
/*
/datum/reagent/mutationtoxin/mootant
	name = "Mootant Mutation Toxin"
	description = "A milk-colored toxin."
	color = "#ffffff"
	race = /datum/species/mammal/mootant
	mutationtext = "<span class='danger'>The pain subsides. You feel... milky.</span>"
	var/produced_chem = /datum/reagent/consumable/milk

/obj/item/reagent_containers/glass/beaker/mutationmootant //preset for toxin
	list_reagents = list(/datum/reagent/mutationtoxin/mootant = 50)

/obj/item/reagent_containers/pill/mutationmootant //preset for pill, used in a lavalad ruin
	name = "mootant pill"
	desc = "A strange toxin of some sorts, made for altering one's body into a weird cow-person hybrid."
	icon_state = "pill17"
	list_reagents = list(/datum/reagent/mutationtoxin/mootant = 1)

/datum/reagent/mutationtoxin/mootant/on_mob_life(mob/living/carbon/human/H)
	..()
	if(H?.client?.prefs?.transformation)
		to_chat(H, "<span class='warning'><b>You crumple in agony as your flesh wildly morphs into a new bovine form!</b></span>")
		H.visible_message("<b>[H]</b> falls to the ground and screams as [H.p_their()] their body turns more bovine!")
		H.DefaultCombatKnockdown(60)
		H.adjust_fatness(400, FATTENING_TYPE_CHEM)
		H.dna.features["breasts_producing"] = TRUE
		H.dna.features["mam_ears"] = "Mootant ALT (Tertiary)"
		H.dna.features["mam_snouts"] = "Mootant ALT (Tertiary)"
		H.dna.features["mam_tail"] = "Mootant"
		H.reagents.add_reagent(/datum/reagent/fermi/breast_enlarger, 40) //instead of adding breasts as a mutant organ, let's just make them grow some
		H.update_body()
		addtimer(CALLBACK(src, PROC_REF(mutate), H), 30)
		return

	if(!H?.client?.prefs?.transformation)
		to_chat(H, span_warning("It seems like [H] resisted the effects of the mutation toxin."))
		return FALSE
*/
