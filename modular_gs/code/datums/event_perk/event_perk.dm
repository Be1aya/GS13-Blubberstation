#define EVENT_PERK_JSON_FOLDER	"data/event_perks/"

GLOBAL_LIST_EMPTY_TYPED(event_perk_instances, /datum/event_perk)
GLOBAL_DATUM(event_perk_tgui_holder, /datum/event_perk)

/datum/event_perk
	// abstract_type = /datum/event_perk
	var/name = ""
	var/description = ""
	/// list of items delivered to the player, and their amount
	var/list/items = list()
	/// list of ckeys that can redeem this particular perk. also stores if any particular ckey can redeem a perk this round
	var/list/ckeys = list()
	/// date when the perk expires. String in a DDMMYYYY format
	var/expiry_date = 0
	/// string used to send data to the TGUI. Set automatically, DON'T MODIFY IT
	var/expiry_date_string = ""
	///has the perk expired yet
	var/expired = FALSE

/datum/event_perk/proc/redeem()
	ckeys[usr.ckey] = FALSE
	for (var/item in items)
		var/amount = items[item]
		for(var/i in 1 to amount)
			var/obj/item/selected_item = item
			new selected_item (usr.drop_location())

/datum/event_perk/proc/check_expiry_date(day, month, year)
	var/perk_day = text2num(copytext(expiry_date, 1, 3))
	var/perk_month = text2num(copytext(expiry_date, 3, 5))
	var/perk_year = text2num(copytext(expiry_date, 5, 9))
	expiry_date_string = "[perk_day].[perk_month].[perk_year]"

	if (perk_year > year)
		expired = FALSE
		return
	if (perk_year < year)
		expired = TRUE
		return
	
	if (perk_month > month)
		expired = FALSE
		return
	if (perk_month < month)
		expired = TRUE
		return
	
	if (perk_day > day)
		expired = FALSE
		return
	if (perk_day < day)
		expired = TRUE
		return
	
	expired = TRUE

/datum/event_perk/proc/load_from_json(file_path)
	if(!fexists(file_path))
		message_admins("Attempted to load an interaction from json and the file does not exist")
		qdel(src)
		return FALSE
	
	var/file = file(file_path)
	var/list/json = json_load(file)

	var/list/_items = list()

	name = sanitize_text(json["name"])
	description = sanitize_text(json["description"])
	_items = sanitize_islist(json["items"], list())
	ckeys = sanitize_islist(json["ckeys"], list())
	expiry_date = sanitize_text(json["expiry_date"])

	for (var/item in _items)
		var/item_path_string = item[1]
		var/item_path = text2path(item_path_string)
		var/item_amount = item[item_path_string]
		src.items[item_path] = item_amount

	for (var/ckey in ckeys)
		ckeys[ckey] = TRUE

	return TRUE

/datum/event_perk/ui_state(mob/user)
	return GLOB.always_state

/datum/event_perk/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EventPerkRedeemer")
		ui.open()

/datum/event_perk/ui_static_data(mob/user)
	var/list/data = list()
	data["available_perks"] = list()
	var/ckey = user.ckey


	for (var/i = 1, i <= GLOB.event_perk_instances.len, i++)
		var/datum/event_perk/selected_perk = GLOB.event_perk_instances[i]
		if (selected_perk.expired)
			continue
		
		if (selected_perk.ckeys.Find(ckey))
			var/list/perk_data = list(
				"name" = selected_perk.name,
				"description" = selected_perk.description,
				"items" = "",
				"expiry_date" = selected_perk.expiry_date_string,
				"available" = selected_perk.ckeys[ckey],
				)
			
			for (var/item in selected_perk.items)
				var/obj/item/current_item = new item
				perk_data["items"] += "[current_item.name] x[selected_perk.items[item]], "	// this is, understandably, a dogshit horrible way of doing this. but tgui is forcing my hand

			perk_data["items"] = copytext(perk_data["items"], 1, length(perk_data["items"]) - 2)
			UNTYPED_LIST_ADD(data["available_perks"], perk_data)

	return data

/datum/event_perk/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if (.)
		return .

	switch(action)
		if ("redeem_perk")
			var/name = params["name"]
			for (var/i = 1, i <= GLOB.event_perk_instances.len, i++)
				var/datum/event_perk/perk = GLOB.event_perk_instances[i]
				if (perk.name == name)
					perk.redeem()

	update_static_data(usr)

/proc/populate_event_perks()
	GLOB.event_perk_tgui_holder = new /datum/event_perk
	for (var/perk in subtypesof(/datum/event_perk))
		GLOB.event_perk_instances.Add(new perk)
	
	populate_event_perk_jsons()

	var/date_string = time2text(world.realtime, "DDMMYYYY")
	var/day = text2num(copytext(date_string, 1, 3))
	var/month = text2num(copytext(date_string, 3, 5))
	var/year = text2num(copytext(date_string, 5, 9))

	for (var/i = 1, i <= GLOB.event_perk_instances.len, i++)
		GLOB.event_perk_instances[i].check_expiry_date(day, month, year)
	

/proc/populate_event_perk_jsons()
	var/directory = EVENT_PERK_JSON_FOLDER
	for(var/file in flist(directory))
		var/file_path = directory + file
		if (!findlasttext(file_path, ".json"))
			continue
		
		var/datum/event_perk/new_perk = new()
		if (new_perk.load_from_json(file_path))
			GLOB.event_perk_instances.Add(new_perk)
		else 
			message_admins("Error loading event perk from file: '[file_path]'. Inform coders. And provide them with plenty of info.")

/mob/living/verb/redeem_event_perk()
	set category = "OOC"
	set name = "Redeem event perk"
	set desc = "Redeem an event perk for an event you participated in."

	GLOB.event_perk_tgui_holder.ui_interact(src)
