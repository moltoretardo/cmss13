/obj/item/device/cotablet
	icon = 'icons/obj/items/devices.dmi'
	name = "command tablet"
	desc = "A portable command interface used by top brass, capable of issuing commands over long ranges to their linked computer. Built to withstand a nuclear bomb."
	suffix = "\[3\]"
	icon_state = "Cotablet"
	item_state = "Cotablet"
	unacidable = TRUE
	indestructible = TRUE
	req_access = list(ACCESS_MARINE_COMMANDER)
	var/on = TRUE // 0 for off
	var/mob/living/carbon/human/current_mapviewer
	var/cooldown_between_messages = COOLDOWN_COMM_MESSAGE

	var/tablet_name = "Commanding Officer's Tablet"

	var/announcement_title = COMMAND_ANNOUNCE
	var/announcement_faction = FACTION_MARINE
	var/add_pmcs = TRUE

	var/tacmap_type = TACMAP_DEFAULT
	var/tacmap_base_type = TACMAP_BASE_OCCLUDED
	var/tacmap_additional_parameter = null
	var/minimap_name = "Marine Minimap"
	COOLDOWN_DECLARE(announcement_cooldown)
	COOLDOWN_DECLARE(distress_cooldown)

/obj/item/device/cotablet/Initialize()
	if(SSticker.mode && (MODE_HAS_FLAG(MODE_FACTION_CLASH) || MODE_HAS_FLAG(MODE_CLF_HIJACK)))
		add_pmcs = FALSE
	else if(SSticker.current_state < GAME_STATE_PLAYING)
		RegisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP, .proc/disable_pmc)
	return ..()

/obj/item/device/cotablet/proc/disable_pmc()
	if(MODE_HAS_FLAG(MODE_FACTION_CLASH) || MODE_HAS_FLAG(MODE_CLF_HIJACK))
		add_pmcs = FALSE
	UnregisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP)

/obj/item/device/cotablet/attack_self(mob/user as mob)
	..()

	if(src.allowed(user))
		tgui_interact(user)
	else
		to_chat(user, SPAN_DANGER("Access denied."))

/obj/item/device/cotablet/ui_static_data(mob/user)
	var/list/data = list()

	data["faction"] = announcement_faction
	data["cooldown_message"] = cooldown_between_messages

	return data

/obj/item/device/cotablet/ui_data(mob/user)
	var/list/data = list()

	data["alert_level"] = security_level
	data["evac_status"] = EvacuationAuthority.evac_status
	data["endtime"] = announcement_cooldown
	data["distresstime"] = distress_cooldown
	data["distresstimelock"] = DISTRESS_TIME_LOCK
	data["worldtime"] = world.time

	return data

/obj/item/device/cotablet/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(!allowed(user))
		return UI_UPDATE
	if(!on)
		return UI_DISABLED

/obj/item/device/cotablet/ui_state(mob/user)
	return GLOB.inventory_state

/obj/item/device/cotablet/tgui_interact(mob/user, datum/tgui/ui, datum/ui_state/state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CommandTablet", "Command Tablet")
		ui.open()

/obj/item/device/cotablet/ui_close(mob/user)
	. = ..()
	if(current_mapviewer)
		close_browser(current_mapviewer, "marineminimap")
		current_mapviewer = null
		return

/obj/item/device/cotablet/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("announce")
			if(!COOLDOWN_FINISHED(src, announcement_cooldown))
				to_chat(usr, SPAN_WARNING("Please wait [COOLDOWN_TIMELEFT(src, announcement_cooldown)/10] second\s before making your next announcement."))
				return FALSE

			var/input = stripped_multiline_input(usr, "Please write a message to announce to the [MAIN_SHIP_NAME]'s crew and all groundside personnel.", "Priority Announcement", "")
			if(!input || !COOLDOWN_FINISHED(src, announcement_cooldown) || !(usr in view(1, src)))
				return FALSE

			var/signed = null
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				var/obj/item/card/id/id = H.wear_id
				if(istype(id))
					var/paygrade = get_paygrades(id.paygrade, FALSE, H.gender)
					signed = "[paygrade] [id.registered_name]"

			marine_announcement(input, announcement_title, faction_to_display = announcement_faction, add_PMCs = add_pmcs, signature = signed)
			message_staff("[key_name(usr)] has made a command announcement.")
			log_announcement("[key_name(usr)] has announced the following: [input]")
			COOLDOWN_START(src, announcement_cooldown, cooldown_between_messages)
			. = TRUE

		if("award")
			if(announcement_faction != FACTION_MARINE)
				return
			print_medal(usr, src)
			. = TRUE

		if("mapview")
			if(current_mapviewer)
				update_mapview(TRUE)
				. = TRUE
				return
			current_mapviewer = usr
			update_mapview()
			. = TRUE

		if("evacuation_start")
			if(announcement_faction != FACTION_MARINE)
				return

			if(security_level < SEC_LEVEL_RED)
				to_chat(usr, SPAN_WARNING("The ship must be under red alert in order to enact evacuation procedures."))
				return FALSE

			if(EvacuationAuthority.flags_scuttle & FLAGS_EVACUATION_DENY)
				to_chat(usr, SPAN_WARNING("The USCM has placed a lock on deploying the evacuation pods."))
				return FALSE

			if(!EvacuationAuthority.initiate_evacuation())
				to_chat(usr, SPAN_WARNING("You are unable to initiate an evacuation procedure right now!"))
				return FALSE

			log_game("[key_name(usr)] has called for an emergency evacuation.")
			message_staff("[key_name_admin(usr)] has called for an emergency evacuation.")
			. = TRUE

		if("distress")
			if(!SSticker.mode)
				return FALSE //Not a game mode?

			if(security_level == SEC_LEVEL_DELTA)
				to_chat(usr, SPAN_WARNING("The ship is already undergoing self destruct procedures!"))
				return FALSE

			for(var/client/C in GLOB.admins)
				if((R_ADMIN|R_MOD) & C.admin_holder.rights)
					playsound_client(C,'sound/effects/sos-morse-code.ogg',10)
			message_staff("[key_name(usr)] has requested a Distress Beacon! (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];ccmark=\ref[usr]'>Mark</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];distress=\ref[usr]'>SEND</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];ccdeny=\ref[usr]'>DENY</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservejump=\ref[usr]'>JMP</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];CentcommReply=\ref[usr]'>RPLY</A>)")
			to_chat(usr, SPAN_NOTICE("A distress beacon request has been sent to USCM Central Command."))
			COOLDOWN_START(src, distress_cooldown, COOLDOWN_COMM_REQUEST)
			return TRUE

/obj/item/device/cotablet/proc/update_mapview(var/close = 0)
	if (close || !current_mapviewer || !Adjacent(current_mapviewer))
		close_browser(current_mapviewer, "marineminimap")
		current_mapviewer = null
		return

	var/icon/O = overlay_tacmap(tacmap_type, tacmap_base_type, tacmap_additional_parameter)
	if(O)
		current_mapviewer << browse_rsc(O, "marine_minimap.png")
		show_browser(current_mapviewer, "<img src=marine_minimap.png>", minimap_name, "marineminimap", "size=[(map_sizes[1]*2)+50]x[(map_sizes[2]*2)+50]", closeref = src)

/obj/item/device/cotablet/pmc
	desc = "A special device used by corporate PMC directors."

	tablet_name = "Site Director's Tablet"

	announcement_title = PMC_COMMAND_ANNOUNCE
	announcement_faction = FACTION_PMC

	tacmap_type = TACMAP_FACTION
	tacmap_base_type = TACMAP_BASE_OPEN
	tacmap_additional_parameter = FACTION_PMC
	minimap_name = "PMC Minimap"

/obj/item/device/cotablet/clf
	desc = "An old tablet used by CLF, probably stolen."

	tablet_name = "CLF Cell Tablet"

	announcement_title = CLF_COMMAND_ANNOUNCE
	announcement_faction = FACTION_CLF

	tacmap_type = TACMAP_FACTION
	tacmap_base_type = TACMAP_BASE_OPEN
	tacmap_additional_parameter = FACTION_CLF
	minimap_name = "CLF Minimap"

	//this is all the airdrop thingies
	#define NUKEDROP 1
	#define AADROP 2
	#define ARMORYDROP 3
	#define TACMAPDROP 4

	var/payload = null
	var/nukeAmount = 1
	var/aaAmount = 2
	var/armoryAmount = 5
	var/tacmapAmount = 1


/obj/item/device/cotablet/clf/tgui_interact(mob/user, datum/tgui/ui, datum/ui_state/state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ClfTablet", "CLF Tablet")
		ui.open()

/obj/item/device/cotablet/clf/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("announceCLF")
			if(!COOLDOWN_FINISHED(src, announcement_cooldown))
				to_chat(usr, SPAN_WARNING("Please wait [COOLDOWN_TIMELEFT(src, announcement_cooldown)/10] second\s before making your next announcement."))
				return FALSE

			var/input = stripped_multiline_input(usr, "Please write a message to announce to all CLF within sensor range.", "Priority Announcement", "")
			if(!input || !COOLDOWN_FINISHED(src, announcement_cooldown) || !(usr in view(1, src)))
				return FALSE

			var/signed = null
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				var/obj/item/card/id/id = H.wear_id
				if(istype(id))
					var/paygrade = get_paygrades(id.paygrade, FALSE, H.gender)
					signed = "[paygrade] [id.registered_name]"

			marine_announcement(input, announcement_title, faction_to_display = announcement_faction, add_PMCs = add_pmcs, signature = signed)
			message_staff("[key_name(usr)] has made a command announcement.")
			log_announcement("[key_name(usr)] has announced the following: [input]")
			COOLDOWN_START(src, announcement_cooldown, cooldown_between_messages)
			. = TRUE

		if("mapview")
			if(current_mapviewer)
				update_mapview(TRUE)
				. = TRUE
				return
			current_mapviewer = usr
			update_mapview()
			. = TRUE

		if("nukespawn")
			handle_airdrop(src,NUKEDROP)
			. = TRUE

		if("antiairstrikespawn")
			handle_airdrop(src,AADROP)
			. = TRUE

		if("armoryspawn")
			handle_airdrop(src,ARMORYDROP)
			. = TRUE

		if("tacmapspawn")
			handle_airdrop(src,TACMAPDROP)
			. = TRUE

/obj/item/device/cotablet/clf/proc/handle_airdrop(var/mob/user,droptype) //this handle the drop duh
	SHOULD_NOT_SLEEP(TRUE) // <-- I have no idea what it does I stole it
	var/x_coord = user.loc.x
	var/y_coord = user.loc.y
	var/z_coord = SSmapping.levels_by_trait(ZTRAIT_GROUND)

	if(length(z_coord))
		z_coord = z_coord[1]
	else
		z_coord = 1 // fuck it we ball

	var/turf/target = locate(x_coord, y_coord, z_coord)
	if(!target)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Error, invalid coordinates.")]")
		return

	if(istype(target, /turf/open/space) || target.density)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("The landing zone appears to be obstructed or out of bounds. Package would be lost on drop.")]")
		return

	var/obj/structure/droppod/container/pod = new()
	pod.should_recall = TRUE
	pod.can_be_opened = FALSE
	pod.density = TRUE
	pod.return_time = 10 SECONDS
	pod.close_on_recall = FALSE

	switch(droptype)
		if(1)
			var/obj/structure/machinery/nuclearbomb/clf/payload = /obj/structure/machinery/nuclearbomb/clf
			payload = new()
			payload.forceMove(pod)
			pod.launch(target)
		if(2)
			var/obj/item/weapon/melee/twohanded/dualsaber/payload = /obj/item/weapon/melee/twohanded/dualsaber
			payload = new()
			payload.forceMove(pod)
			pod.launch(target)
		if(3)
			var/obj/structure/machinery/cm_vending/gear/antag/payload = /obj/structure/machinery/cm_vending/gear/antag
			payload = new()
			payload.forceMove(pod)
			pod.launch(target)
		if(4)
			var/obj/structure/machinery/prop/almayer/CICmap/clf/payload = /obj/structure/machinery/prop/almayer/CICmap/clf
			payload = new()
			payload.forceMove(pod)
			pod.launch(target)
		else
			return()


