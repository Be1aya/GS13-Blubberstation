
/obj/item/choice_beacon/psychologist_or_dietician
	name = "job specialization beacon"
	desc = "This little beacon pad allows you to specialize in being a Psychologist or a Dietician. Make sure your job title reflects it too!"
	icon_state = "sb_delivery"
	inhand_icon_state = "sb_delivery"
	company_source = "GATO Health & Wellbeing Division"
	company_message = span_bold("GATO Health & Wellbeing Division wishes you a safe and productive shift!")
	w_class = WEIGHT_CLASS_TINY

/obj/item/choice_beacon/psychologist_or_dietician/generate_display_names()
	var/static/list/pillchoice
	if(!pillchoice)
		pillchoice = list()
		var/list/psychologist_or_dietician = list(
			/obj/item/storage/box/dietician_pills,
			/obj/item/storage/box/psychologist_pills,
		)
		for(var/obj/item/storage/box/box as anything in psychologist_or_dietician)
			pillchoice[initial(box.name)] = box

	return pillchoice
