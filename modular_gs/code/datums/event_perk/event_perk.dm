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

/datum/event_perk/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EventPerkRedeemer")
		ui.open()

/datum/event_perk/ui_static_data(mob/user)
	. = ..()
	.["available_perks"] = list()

	var/ckey = user.ckey

	for (var/perk in subtypesof(/datum/event_perk))
		var/datum/event_perk/selected_perk = new perk
		if (selected_perk.ckeys.Find(ckey))
			var/list/perk_data = list(
				"name" = selected_perk.name,
				"desc" = selected_perk.description,
				"items" = selected_perk.items,
				)
			.["available_perks"].Add(perk_data)

/proc/populate_event_perks()

/mob/living/verb/redeem_event_perk()
	set category = "OOC"
	set name = "Redeem event perk"
	set desc = "Redeem an event perk for an event you participated in."

	var/list/datum/event_perk/our_perks = list()

	for (var/perk in subtypesof(/datum/event_perk))
		var/datum/event_perk/selected_perk = new perk
		if (selected_perk.ckeys.Find(src.ckey))
			our_perks.Add(selected_perk)

	for (var/perk in our_perks)
		var/datum/event_perk/selected_perk = perk
		for (var/item in selected_perk.items)
			var/amount = selected_perk.items[item]
			for(var/i in 1 to amount)
				var/obj/item/selected_item = item
				new selected_item (drop_location())
	
	/datum/event_perk.ui_interact(usr)

/datum/event_perk/testing_perk
	name = "testing_perk"
	description = "this is a testing perk"
	items = list(/obj/item/screwdriver = 1)
	ckeys = list("absolutelyfree" = TRUE)


