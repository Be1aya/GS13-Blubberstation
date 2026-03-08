#define EVENT_PERK_JSON_FOLDER	"data/event_perks/"

#define CAN_REDEEM TRUE
#define CAN_NOT_REDEEM FALSE

GLOBAL_LIST_EMPTY_TYPED(event_perk_instances, /datum/event_perk)
GLOBAL_DATUM(event_perk_tgui_holder, /datum/event_perk)

/datum/event_perk
	// abstract_type = /datum/event_perk
	var/name = ""
	var/description = ""
	/// list of items delivered to the player, and their amount
	var/list/items = list()
	/// list of ckeys that can redeem this particular perk. also stores if any particular ckey can redeem a perk this round - TRUE means it can be redeemed, FALSE means it can't
	var/list/ckeys = list()
	/// date when the perk expires. String in a DDMMYYYY format
	var/expiry_date = 0
	/// string used to send data to the TGUI. Set automatically, DON'T MODIFY IT
	var/expiry_date_string = ""
	///has the perk expired yet
	var/expired = FALSE

/datum/event_perk/proc/redeem()
	ckeys[usr.ckey] = CAN_NOT_REDEEM
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
		message_admins("Attempted to load an event perk from json and the file does not exist")
		qdel(src)
		return FALSE
	
	var/datum/json_savefile/json_file = new /datum/json_savefile(file_path)

	var/list/_items = list()

	name = json_file.get_entry("name")
	description = json_file.get_entry("description")
	_items = json_file.get_entry("items")
	ckeys = json_file.get_entry("ckeys")
	expiry_date = json_file.get_entry("expiry_date")

	for (var/item in _items)
		var/item_path_string = item
		var/item_path = text2path(item_path_string)
		var/item_amount = _items[item]
		src.items[item_path] = item_amount

	for (var/ckey in ckeys)
		ckeys[ckey] = CAN_REDEEM

	qdel(json_file)
	return TRUE

/datum/event_perk/proc/save_to_json(directory_path = EVENT_PERK_JSON_FOLDER)
	var/file_name = name
	var/file_path = directory_path + file_name + ".json"

	var/datum/json_savefile/json_file = new /datum/json_savefile(file_path)

	json_file.set_entry("name", name)
	json_file.set_entry("description", description)
	json_file.set_entry("items", items)
	json_file.set_entry("ckeys", ckeys)
	json_file.set_entry("expiry_date", expiry_date)

	json_file.save()
	qdel(json_file)

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
				qdel(current_item)

			perk_data["items"] = copytext(perk_data["items"], 1, length(perk_data["items"]) - 1)
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

// -----------------------ADMIN SHIT--------------------------------

/datum/admins
	var/datum/event_perk_maker/event_perk_maker

ADMIN_VERB(event_perk_maker, R_ADMIN, "Event Perk Maker", "Create a new Event Perk (TGUI).", ADMIN_CATEGORY_EVENTS)
	var/datum/event_perk_maker/panel = user.holder.event_perk_maker
	if(!panel)
		panel = new()
		user.holder.event_perk_maker = panel
	panel.ui_interact(user.mob)
	BLACKBOX_LOG_ADMIN_VERB("Event Perk Maker")

/datum/event_perk_maker
	var/list/items = list()
	var/list/ckeys = list()

/datum/event_perk_maker/proc/create_perk(name, description, expiry_date)
	var/datum/event_perk/new_perk = new()

	new_perk.name = name
	new_perk.description = description
	new_perk.items = src.items.Copy()
	new_perk.ckeys = src.ckeys.Copy(src.ckeys)
	new_perk.expiry_date = expiry_date

	GLOB.event_perk_instances.Add(new_perk)

	new_perk.save_to_json()

	src.items.RemoveAll(items)
	src.ckeys.RemoveAll(ckeys)

/datum/event_perk_maker/proc/format_item_list(items)
	var/list/items_list = list()
	return items_list

/datum/event_perk_maker/proc/format_ckey_list(ckeys)
	var/list/ckeys_list = list()
	return ckeys_list

/datum/event_perk_maker/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EventPerkMaker")
		ui.open()

/datum/event_perk_maker/ui_state(mob/user)
	return GLOB.always_state

/datum/event_perk_maker/ui_static_data(mob/user)
	. = ..()

	var/list/data = list()
	data["items"] = list()
	data["ckeys"] = list()

	for (var/item in items)
		var/obj/item/current_item = new item
		var/item_string = "[current_item.name] x[items[item]]"
		UNTYPED_LIST_ADD(data["items"], item_string)
		qdel(current_item)

	for (var/ckey in ckeys)
		UNTYPED_LIST_ADD(data["ckeys"], ckey)

	return data

/datum/event_perk_maker/ui_close(mob/user)
	. = ..()
	items.RemoveAll(items)
	ckeys.RemoveAll(ckeys)

/datum/event_perk_maker/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if (.)
		return .

	switch(action)
		if ("create_perk")
			var/name = params["name"]
			var/description = params["description"]
			var/expiry_date = params["expiry_date"]
			create_perk(name, description, expiry_date)
		if ("add_item")
			var/item = text2path(params["item"])
			var/amount = text2num(params["item_amount"])
			if (isnull(item) || isnull(amount))
				return
			items[item] = amount
		if ("add_ckey")
			var/ckey = ckey(params["ckey"])
			ckeys[ckey] = CAN_REDEEM

	update_static_data(usr)

#undef CAN_REDEEM
#undef CAN_NOT_REDEEM
