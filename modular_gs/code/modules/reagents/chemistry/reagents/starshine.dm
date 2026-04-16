//The minimum value the range of the light cast by a starshine drinker can have
#define LIGHT_RANGE_MINIMUM 3
//The minimum value for the power of the light cast by a starshine drinker
#define LIGHT_POWER_MINIMUM 0.7
//The value by which the volume of chemical is multiplied for the purpose of hiders calculations
#define CHEM_TO_WEIGHT_MULTIPLIER 124


/datum/reagent/consumable/starshine
	name = "Starshine Nova"
	description = "A popular brand of soft drinks, this one is its classic strawberry flavor."
	color = "#FFB6B6"
	taste_description = "liquid stars"
	quality = DRINK_GOOD
	process_flags = REAGENT_ORGANIC | REAGENT_SYNTHETIC | REAGENT_PROTEAN
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_MEDIUM
	nutriment_factor = 3
	/// The current light cast by the reagent's drinker. Stored to more easily modify its values and delete it
	var/obj/effect/light_holder

/datum/glass_style/drinking_glass/starshine_red
	required_drink_type = /datum/reagent/consumable/starshine
	name = "starshine nova"
	desc = "The only drink that makes you shine!"
	icon = 'modular_gs/icons/obj/starshine.dmi'
	icon_state = "starshine_r"

/datum/reagent/consumable/starshine
	nutriment_factor = 5
	quality = DRINK_VERYGOOD

/datum/chemical_reaction/drink/starshine
	results = list(/datum/reagent/consumable/starshine = 3)
	required_reagents = list(/datum/reagent/consumable/berryjuice = 1, /datum/reagent/consumable/sodawater = 1, /datum/reagent/consumable/sugar = 1)

/datum/reagent/consumable/starshine/on_mob_metabolize(mob/living/drinker)
	. = ..()
	to_chat(drinker, span_notice("You feel like a shining star!"))
	light_holder = new(drinker)
	light_holder.set_light(LIGHT_RANGE_MINIMUM, LIGHT_POWER_MINIMUM, color)

/datum/reagent/consumable/starshine/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	if(QDELETED(light_holder))
		holder.del_reagent(type) //If we lost our light object somehow, remove the reagent
		return
	else if(light_holder.loc != drinker)
		light_holder.forceMove(drinker)

	light_holder.set_light(LIGHT_RANGE_MINIMUM + (volume*0.007), LIGHT_POWER_MINIMUM + (volume*0.003), color) //Update light strength and rage based on volume
	return ..()

/datum/reagent/consumable/starshine/on_mob_end_metabolize(mob/living/drinker)
	. = ..()
	to_chat(drinker, span_notice("The shining fades..."))
	QDEL_NULL(light_holder)

/datum/reagent/consumable/starshine/yellow
	name = "Starshine Yellow Dwarf"
	description = "The popular Starshine soft drink, now lemon-flavored."
	color = "#FFFDAA"

/datum/glass_style/drinking_glass/starshine_yellow
	required_drink_type = /datum/reagent/consumable/starshine/yellow
	name = "starshine yellow dwarf"
	desc = "The only drink that makes you shine!"
	icon = 'modular_gs/icons/obj/starshine.dmi'
	icon_state = "starshine_y"

/datum/reagent/consumable/starshine/yellow
	nutriment_factor = 5
	quality = DRINK_VERYGOOD

/datum/chemical_reaction/drink/starshine_yellow
	results = list(/datum/reagent/consumable/starshine/yellow = 3)
	required_reagents = list(/datum/reagent/consumable/lemonjuice = 1, /datum/reagent/consumable/sodawater = 1, /datum/reagent/consumable/sugar = 1)

/datum/reagent/consumable/starshine/orange
	name = "Starshine Orange Giant"
	description = "Expand your taste buds with this orange-flavored Starshine."
	color = "#FFDAB3"

/datum/glass_style/drinking_glass/starshine_orange
	required_drink_type = /datum/reagent/consumable/starshine/orange
	name = "starshine orange giant"
	desc = "The only drink that makes you shine!"
	icon = 'modular_gs/icons/obj/starshine.dmi'
	icon_state = "starshine_o"

/datum/chemical_reaction/drink/starshine_orange
	results = list(/datum/reagent/consumable/starshine/orange = 3)
	required_reagents = list(/datum/reagent/consumable/orangejuice = 1, /datum/reagent/consumable/sodawater = 1, /datum/reagent/consumable/sugar = 1)

/datum/reagent/consumable/starshine/blue
	name = "Starshine Neutron"
	description = "A new horizon of Starshine flavor with neutron."
	color = "#6EFFFF"
	quality = DRINK_FANTASTIC
	glass_price = DRINK_PRICE_HIGH
	nutriment_factor = 5
	overdose_threshold = 100
	addiction_types = list(/datum/addiction/starshine_blue = 15)

/datum/addiction/starshine_blue
	name = "starshine neutron"
	withdrawal_stage_messages = list("I feel... dim.", "I miss neutron, I miss shining!'", "The light, need to shine, want to glow bright!!")

/datum/glass_style/drinking_glass/starshine_blue
	required_drink_type = /datum/reagent/consumable/starshine/blue
	name = "starshine neutron"
	desc = "The only drink that makes you shine!\nWARNING: Do not consume more than one bottle of Starshine Neutron a day!"
	icon = 'modular_gs/icons/obj/starshine.dmi'
	icon_state = "starshine_b"

/datum/chemical_reaction/drink/starshine_blue
	results = list(/datum/reagent/consumable/starshine/blue = 3)
	required_reagents = list(/datum/reagent/bluespace = 1, /datum/reagent/consumable/sodawater = 1, /datum/reagent/consumable/sugar = 1)

/datum/reagent/consumable/starshine/blue/proc/fat_hide()
	return (CHEM_TO_WEIGHT_MULTIPLIER * (volume * volume))/1000

/datum/reagent/consumable/starshine/blue/on_mob_add(mob/living/carbon/holder, amount)
	if(!istype(holder))
		return
	var/mob/living/carbon/affected_mob = holder
	affected_mob.hider_add(src)
	..()

/datum/reagent/consumable/starshine/blue/on_mob_delete(mob/living/carbon/holder)
	if(!istype(holder))
		return

	holder.hider_remove(src)
	return ..()

/datum/reagent/consumable/starshine/blue/overdose_start(mob/living/carbon/human/human)
	if(!istype(human))
		return
	var/mob/living/carbon/human/drinker = human
	to_chat(drinker, "<span class='userdanger'>You drank too much [name]! Something about your body has shifted!</span>")

	var/obj/item/organ/genital/breasts/breasts = drinker.get_organ_slot(ORGAN_SLOT_BREASTS)
	if(breasts)
		breasts.lactates = TRUE
		breasts.internal_fluid_datum = /datum/reagent/consumable/starshine/blue
	var/obj/item/organ/genital/testicles/testes = drinker.get_organ_slot(ORGAN_SLOT_TESTICLES)
	if(testes)
		testes.internal_fluid_datum = /datum/reagent/consumable/starshine/blue
	var/obj/item/organ/genital/vagina = drinker.get_organ_slot(ORGAN_SLOT_VAGINA)
	if(vagina)
		vagina.internal_fluid_datum = /datum/reagent/consumable/starshine/blue

/obj/machinery/vending/starshine
	name = "Starshine Vending Machine"
	desc = "Starshine's cola machine, for drinks that will make you glow!"
	icon = 'modular_gs/icons/obj/vending.dmi'
	icon_state = "starshine"
	product_slogans = "Shine like a star, with Starshine!"
	vend_reply = "Shine on, little star!"
	products = list(
				/obj/item/reagent_containers/cup/glass/drinkingglass/filled/starshine = 30,
				/obj/item/reagent_containers/cup/glass/drinkingglass/filled/starshine/yellow = 30,
				/obj/item/reagent_containers/cup/glass/drinkingglass/filled/starshine/orange = 30,
				)
	contraband = list(
				///obj/item/reagent_containers/cup/glass/drinkingglass/filled/starshine_blue = 30,
				)
	premium = list(
				/obj/item/reagent_containers/cup/glass/drinkingglass/filled/starshine/blue = 10,
				)

	refill_canister = /obj/item/vending_refill/starshine

/obj/item/vending_refill/starshine
	machine_name = "Starshine Vendor"
	icon = 'modular_gs/icons/obj/vending_restock.dmi'
	icon_state = "refill_starshine"

/obj/item/reagent_containers/cup/glass/drinkingglass/filled/starshine
	name = "Starshine Red Giant"
	icon = 'modular_gs/icons/obj/starshine.dmi'
	icon_state = "starshine_r"
	list_reagents = list(/datum/reagent/consumable/starshine = 50)

/obj/item/reagent_containers/cup/glass/drinkingglass/filled/starshine/yellow
	name = "Starshine Yellow Dwarf"
	icon_state = "starshine_y"
	list_reagents = list(/datum/reagent/consumable/starshine/yellow = 50)

/obj/item/reagent_containers/cup/glass/drinkingglass/filled/starshine/orange
	name = "Starshine Orange Giant"
	icon_state = "starshine_o"
	list_reagents = list(/datum/reagent/consumable/starshine/orange = 50)

/obj/item/reagent_containers/cup/glass/drinkingglass/filled/starshine/blue
	name = "Starshine Neutron"
	icon_state = "starshine_b"
	list_reagents = list(/datum/reagent/consumable/starshine/blue = 50)

/obj/machinery/chem_dispenser/drinks/Initialize(mapload)
	. = ..()
	dispensable_reagents.Add(/datum/reagent/consumable/starshine)

/obj/machinery/plumbing/synthesizer/soda/Initialize(mapload, bolt, layer)
	. = ..()
	dispensable_reagents.Add(/datum/reagent/consumable/starshine)

/datum/supply_pack/vending/starshine
	name = "Starshine Vendor Supply Crate"
	desc = "Ran out of soda? We got you covered! No worries and drink plenty!"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/starshine)
	crate_name = "starshine vendor supply crate"

#undef LIGHT_RANGE_MINIMUM
#undef LIGHT_POWER_MINIMUM
#undef CHEM_TO_WEIGHT_MULTIPLIER
