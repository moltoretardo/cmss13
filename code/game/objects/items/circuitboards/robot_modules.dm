/obj/item/circuitboard/robot_module
	name = "robot module"
	icon_state = "std_mod"
	flags_atom = FPRINT|CONDUCT
	var/channels = list()
	var/list/modules = list()
	var/obj/item/emag = null
	var/obj/item/robot/upgrade/jetpack = null
	var/list/stacktypes

/obj/item/circuitboard/robot_module/emp_act(severity)
	if(modules)
		for(var/obj/O in modules)
			O.emp_act(severity)
	if(emag)
		emag.emp_act(severity)
	..()
	return


/obj/item/circuitboard/robot_module/Initialize()
	. = ..()
// src.modules += new /obj/item/device/flashlight(src) // Replaced by verb and integrated light which uses power.
	src.modules += new /obj/item/device/flash(src)
	src.emag = new /obj/item/toy/sword(src)
	src.emag.name = "Placeholder Emag Item"
// src.jetpack = new /obj/item/toy/sword(src)
// src.jetpack.name = "Placeholder Upgrade Item"

/obj/item/circuitboard/robot_module/Destroy()
	. = ..()
	QDEL_NULL(emag)
	QDEL_NULL(jetpack)

/obj/item/circuitboard/robot_module/proc/respawn_consumable(mob/living/silicon/robot/R)

	if(!stacktypes || !stacktypes.len) return

	for(var/T in stacktypes)
		var/O = locate(T) in src.modules
		var/obj/item/stack/S = O

		if(!S)
			src.modules -= null
			S = new T(src)
			src.modules += S
			S.amount = 1

		if(S && S.amount < stacktypes[T])
			S.amount++

/obj/item/circuitboard/robot_module/proc/rebuild()//Rebuilds the list so it's possible to add/remove items from the module
	var/list/temp_list = modules
	modules = list()
	for(var/obj/O in temp_list)
		if(O)
			modules += O

/obj/item/circuitboard/robot_module/proc/add_languages(mob/living/silicon/robot/R)
	//full set of languages
	R.add_language(LANGUAGE_RUSSIAN, 1)
	R.add_language(LANGUAGE_JAPANESE, 1)


/obj/item/circuitboard/robot_module/standard
	name = "standard robot module"

/obj/item/circuitboard/robot_module/standard/New()
	src.modules += new /obj/item/device/flashlight(src)
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/tool/extinguisher(src)
	src.modules += new /obj/item/tool/wrench(src)
	src.modules += new /obj/item/tool/crowbar(src)
	src.modules += new /obj/item/device/healthanalyzer(src)
	src.modules += new /obj/item/robot/stun(src)
	src.emag = new /obj/item/weapon/energy/sword(src)
	return

/obj/item/circuitboard/robot_module/surgeon
	name = "surgeon robot module"
	stacktypes = list(
		/obj/item/stack/medical/advanced/bruise_pack = 5,
		/obj/item/stack/nanopaste = 5,
	)

/obj/item/circuitboard/robot_module/surgeon/Initialize()
	. = ..()
	src.modules += new /obj/item/device/flashlight(src)
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/device/healthanalyzer(src)
	src.modules += new /obj/item/reagent_container/borghypo(src)
	src.modules += new /obj/item/tool/surgery/scalpel(src)
	src.modules += new /obj/item/tool/surgery/hemostat(src)
	src.modules += new /obj/item/tool/surgery/retractor(src)
	src.modules += new /obj/item/tool/surgery/cautery(src)
	src.modules += new /obj/item/tool/surgery/bonegel(src)
	src.modules += new /obj/item/tool/surgery/FixOVein(src)
	src.modules += new /obj/item/tool/surgery/bonesetter(src)
	src.modules += new /obj/item/tool/surgery/circular_saw(src)
	src.modules += new /obj/item/tool/surgery/surgicaldrill(src)
	src.modules += new /obj/item/tool/extinguisher/mini(src)
	src.modules += new /obj/item/stack/medical/advanced/bruise_pack(src)
	src.modules += new /obj/item/stack/nanopaste(src)
	src.modules += new /obj/item/tool/weldingtool/largetank(src)
	src.modules += new /obj/item/tool/crowbar(src)
	src.modules += new /obj/item/robot/stun(src)

	src.emag = new /obj/item/reagent_container/spray(src)

	src.emag.reagents.add_reagent("pacid", 250)
	src.emag.name = "Polyacid spray"

/obj/item/circuitboard/robot_module/surgeon/respawn_consumable(mob/living/silicon/robot/R)
	if(src.emag)
		var/obj/item/reagent_container/spray/PS = src.emag
		PS.reagents.add_reagent("pacid", 2)
	..()

/obj/item/circuitboard/robot_module/medic
	name = "medic robot module"
	stacktypes = list(
		/obj/item/stack/medical/ointment = 15,
		/obj/item/stack/medical/advanced/bruise_pack = 15,
		/obj/item/stack/medical/splint = 15,
	)

/obj/item/circuitboard/robot_module/medic/Initialize()
	. = ..()
	src.modules += new /obj/item/device/flashlight(src)
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/robot/sight/hud/med(src)
	src.modules += new /obj/item/device/healthanalyzer(src)
	src.modules += new /obj/item/device/reagent_scanner/adv(src)
	src.modules += new /obj/item/roller_holder(src)
	src.modules += new /obj/item/stack/medical/ointment(src)
	src.modules += new /obj/item/stack/medical/advanced/bruise_pack(src)
	src.modules += new /obj/item/stack/medical/splint(src)
	src.modules += new /obj/item/reagent_container/borghypo(src)
	src.modules += new /obj/item/reagent_container/glass/beaker/large(src)
	src.modules += new /obj/item/reagent_container/robodropper(src)
	src.modules += new /obj/item/reagent_container/syringe(src)
	src.modules += new /obj/item/tool/extinguisher/mini(src)
	src.modules += new /obj/item/reagent_container/spray/cleaner(src)
	src.modules += new /obj/item/tool/weldingtool/largetank(src)
	src.modules += new /obj/item/tool/crowbar(src)
	src.modules += new /obj/item/robot/stun(src)

	src.emag = new /obj/item/reagent_container/spray(src)

	src.emag.reagents.add_reagent("pacid", 250)
	src.emag.name = "Polyacid spray"

/obj/item/circuitboard/robot_module/medic/respawn_consumable(mob/living/silicon/robot/R)
	var/obj/item/reagent_container/syringe/S = locate() in src.modules
	if(S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()

	var/obj/item/reagent_container/spray/cleaner/C = locate() in src.modules
	C.reagents.add_reagent("cleaner", C.volume)

	if(src.emag)
		var/obj/item/reagent_container/spray/PS = src.emag
		PS.reagents.add_reagent("pacid", 2)

	..()

/obj/item/circuitboard/robot_module/engineering
	name = "engineering robot module"

	stacktypes = list(
		/obj/item/stack/sheet/metal = 50,
		/obj/item/stack/sheet/glass = 50,
		/obj/item/stack/sheet/glass/reinforced = 50,
		/obj/item/stack/cable_coil = 50,
		/obj/item/stack/rods = 50,
		/obj/item/stack/tile/plasteel = 20,
	)

/obj/item/circuitboard/robot_module/engineering/Initialize()
	. = ..()
	src.modules += new /obj/item/device/flashlight(src)
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/robot/sight/meson(src)
	src.modules += new /obj/item/tool/extinguisher(src)
	src.modules += new /obj/item/device/rcd/borg(src)
	src.modules += new /obj/item/tool/weldingtool/largetank(src)
	src.modules += new /obj/item/tool/screwdriver(src)
	src.modules += new /obj/item/tool/wrench(src)
	src.modules += new /obj/item/tool/crowbar(src)
	src.modules += new /obj/item/tool/wirecutters(src)
	src.modules += new /obj/item/device/multitool(src)
	src.modules += new /obj/item/device/t_scanner(src)
	src.modules += new /obj/item/device/analyzer(src)
	src.modules += new /obj/item/device/gripper(src)
	src.modules += new /obj/item/device/matter_decompiler(src)
	src.modules += new /obj/item/device/lightreplacer(src)
	src.modules += new /obj/item/robot/stun(src)

	for(var/T in stacktypes)
		var/obj/item/stack/sheet/W = new T(src)
		W.amount = stacktypes[T]
		src.modules += W

/obj/item/circuitboard/robot_module/engineering/respawn_consumable(mob/living/silicon/robot/R)
	var/obj/item/device/lightreplacer/L = locate() in src.modules
	L.uses = L.max_uses

	..()

/obj/item/circuitboard/robot_module/security
	name = "security robot module"

/obj/item/circuitboard/robot_module/security/Initialize()
	. = ..()
	src.modules += new /obj/item/device/flashlight(src)
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/robot/sight/hud/sec(src)
	src.modules += new /obj/item/handcuffs/cyborg(src)
	src.modules += new /obj/item/robot/stun(src)
	src.modules += new /obj/item/tool/crowbar(src)
// src.modules += new /obj/item/weapon/gun/energy/taser/cyborg(src)
// src.emag = new /obj/item/weapon/gun/energy/laser/cyborg(src)

/obj/item/circuitboard/robot_module/security/respawn_consumable(mob/living/silicon/robot/R)
	var/obj/item/device/flash/F = locate() in src.modules
	if(F.broken)
		F.broken = 0
		F.flashes_stored = F.max_flashes_stored
		F.icon_state = "flash"
	else if(F.flashes_stored > F.max_flashes_stored)
		F.flashes_stored++
	// var/obj/item/weapon/gun/energy/taser/cyborg/T = locate() in src.modules
	// if(T.power_supply.charge < T.power_supply.maxcharge)
	// T.power_supply.give(T.charge_cost)
	// T.update_icon()
	// else
	// T.charge_tick = 0

/obj/item/circuitboard/robot_module/janitor
	name = "janitorial robot module"

/obj/item/circuitboard/robot_module/janitor/Initialize()
	. = ..()
	src.modules += new /obj/item/device/flashlight(src)
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/tool/soap/nanotrasen(src)
	src.modules += new /obj/item/storage/bag/trash(src)
	src.modules += new /obj/item/tool/mop(src)
	src.modules += new /obj/item/device/lightreplacer(src)
	src.modules += new /obj/item/tool/crowbar(src)
	src.modules += new /obj/item/robot/stun(src)
	src.emag = new /obj/item/reagent_container/spray(src)

	src.emag.reagents.add_reagent("cleaner", 250)
	src.emag.name = "space cleaner"

/obj/item/circuitboard/robot_module/janitor/respawn_consumable(mob/living/silicon/robot/R)
	var/obj/item/device/lightreplacer/LR = locate() in src.modules
	LR.Charge(R)
	if(src.emag)
		var/obj/item/reagent_container/spray/S = src.emag
		S.reagents.add_reagent("cleaner", 2)

/obj/item/circuitboard/robot_module/butler
	name = "service robot module"

/obj/item/circuitboard/robot_module/butler/Initialize()
	. = ..()
	src.modules += new /obj/item/device/flashlight(src)
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/reagent_container/food/drinks/cans/beer(src)
	src.modules += new /obj/item/reagent_container/food/condiment/enzyme(src)
	src.modules += new /obj/item/tool/crowbar(src)
	src.modules += new /obj/item/robot/stun(src)

	var/obj/item/device/rsf/M = new /obj/item/device/rsf(src)
	M.stored_matter = 30
	src.modules += M

	src.modules += new /obj/item/reagent_container/robodropper(src)

	var/obj/item/tool/lighter/zippo/L = new /obj/item/tool/lighter/zippo(src)
	L.heat_source = 1000
	src.modules += L

	src.modules += new /obj/item/reagent_container/food/drinks/shaker(src)

/obj/item/circuitboard/robot_module/butler/add_languages(mob/living/silicon/robot/R)
	//full set of languages
	R.add_language(LANGUAGE_JAPANESE, 1)

/obj/item/circuitboard/robot_module/butler/respawn_consumable(mob/living/silicon/robot/R)
	var/obj/item/reagent_container/food/condiment/enzyme/E = locate() in src.modules
	E.reagents.add_reagent("enzyme", 2)
	if(src.emag)
		var/obj/item/reagent_container/food/drinks/cans/beer/B = src.emag
		B.reagents.add_reagent("beer2", 2)

/obj/item/circuitboard/robot_module/syndicate
	name = "syndicate robot module"

/obj/item/circuitboard/robot_module/syndicate/Initialize()
	. = ..()
	src.modules += new /obj/item/device/flashlight(src)
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/weapon/energy/sword(src)

/obj/item/circuitboard/robot_module/drone
	name = "drone module"
	stacktypes = list(
		/obj/item/stack/sheet/wood = 1,
		/obj/item/stack/sheet/mineral/plastic = 1,
		/obj/item/stack/sheet/glass/reinforced = 5,
		/obj/item/stack/tile/wood = 5,
		/obj/item/stack/rods = 15,
		/obj/item/stack/tile/plasteel = 15,
		/obj/item/stack/sheet/metal = 20,
		/obj/item/stack/sheet/glass = 20,
		/obj/item/stack/cable_coil = 30,
	)

/obj/item/circuitboard/robot_module/drone/Initialize()
	. = ..()
	src.modules += new /obj/item/tool/weldingtool(src)
	src.modules += new /obj/item/tool/screwdriver(src)
	src.modules += new /obj/item/tool/wrench(src)
	src.modules += new /obj/item/tool/crowbar(src)
	src.modules += new /obj/item/tool/wirecutters(src)
	src.modules += new /obj/item/device/multitool(src)
	src.modules += new /obj/item/device/lightreplacer(src)
	src.modules += new /obj/item/device/gripper(src)
	src.modules += new /obj/item/device/matter_decompiler(src)
	src.modules += new /obj/item/reagent_container/spray/cleaner/drone(src)

	src.emag = new /obj/item/tool/pickaxe/plasmacutter(src)
	src.emag.name = "Plasma Cutter"

	for(var/T in stacktypes)
		var/obj/item/stack/sheet/W = new T(src)
		W.amount = stacktypes[T]
		src.modules += W

/obj/item/circuitboard/robot_module/drone/add_languages(mob/living/silicon/robot/R)
	return //not much ROM to spare in that tiny microprocessor!

/obj/item/circuitboard/robot_module/drone/respawn_consumable(mob/living/silicon/robot/R)
	var/obj/item/reagent_container/spray/cleaner/C = locate() in src.modules
	C.reagents.add_reagent("cleaner", 3)

	var/obj/item/device/lightreplacer/LR = locate() in src.modules
	LR.Charge(R)

	..()
	return

//checks whether this item is a module of the robot it is located in.
/obj/item/proc/is_robot_module()
	if (!isrobot(src.loc))
		return 0

	var/mob/living/silicon/robot/R = src.loc

	return (src in R.module.modules)
