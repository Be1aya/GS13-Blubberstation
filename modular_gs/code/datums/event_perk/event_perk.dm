#define EVENT_PERK_JSON_FOLDER	"XXX"

GLOBAL_LIST_EMPTY_TYPED(event_perk_instances, /datum/event_perk)

/datum/event_perk
	abstract_type = /datum/event_perk
	var/name = ""
	var/description = ""
	/// list of items delivered to the player, and their amount
	var/list/items = list()
	/// list of ckeys that can redeem this particular perk. also stores if any particular ckey can redeem a perk this round
	var/list/ckeys = list()
	/// date when the perk expires
	var/expiry_date = 0

/datum/event_perk_menu/ui_state(mob/user)
	return GLOB.always_state

/datum/event_perk_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EventPerkRedeemer")
		ui.open()

/datum/event_perk_menu/ui_static_data(mob/user)
	var/list/data = list()
	data["available_perks"] = list()
	var/ckey = user.ckey
	// var/list/available_perks = list()

	for (var/perk in subtypesof(/datum/event_perk))
		var/datum/event_perk/selected_perk = new perk
		if (selected_perk.ckeys.Find(ckey))
			var/list/perk_data = list(
				"name" = selected_perk.name,
				"description" = selected_perk.description,
				"items" = "",
				"expiry_date" = selected_perk.expiry_date
				)
			for (var/item in selected_perk.items)
				var/obj/item/current_item = new item
				// UNTYPED_LIST_ADD(perk_data["items"], list(current_item.name, "[selected_perk.items[item]]"))
				perk_data["items"] += "[current_item.name] x[selected_perk.items[item]],"	// this is, understandably, a dogshit horrible way of doing this. but tgui is forcing my hand
				// perk_data["items"] = list(current_item.name, selected_perk.items[item])
			// available_perks.Add(perk_data)
			UNTYPED_LIST_ADD(data["available_perks"], perk_data)
	
	// data["available_perks"] = available_perks

	return data

/proc/populate_event_perks()

/mob/living/verb/redeem_event_perk()
	set category = "OOC"
	set name = "Redeem event perk"
	set desc = "Redeem an event perk for an event you participated in."

	// var/list/datum/event_perk/our_perks = list()

	// for (var/perk in subtypesof(/datum/event_perk))
	// 	var/datum/event_perk/selected_perk = new perk
	// 	if (selected_perk.ckeys.Find(src.ckey))
	// 		our_perks.Add(selected_perk)

	// for (var/perk in our_perks)
	// 	var/datum/event_perk/selected_perk = perk
	// 	for (var/item in selected_perk.items)
	// 		var/amount = selected_perk.items[item]
	// 		for(var/i in 1 to amount)
	// 			var/obj/item/selected_item = item
	// 			new selected_item (drop_location())
	
	var/datum/event_perk_menu/event_perk_ui_holder = new /datum/event_perk_menu
	event_perk_ui_holder.ui_interact(usr)

/datum/event_perk/testing_perk
	name = "RED team Construction Relief Package"
	description = "A construction supplies perk granted to the RED team of the 07.02.2026 \"Build your own colony\" contest"
	items = list(
		/obj/item/construction/rcd/improved = 1,
		/obj/item/storage/box/rcd_ammo = 1,
		/obj/item/flatpacked_machine = 1,
		/obj/item/storage/box/engitank = 1,
		/obj/item/stack/sheet/iron = 50,
		/obj/item/stack/sheet/glass = 50,
		)
	ckeys = list("absolutelyfree" = TRUE)


