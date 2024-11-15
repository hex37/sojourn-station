/*
 * Contains
 * /obj/item/rig_module/stealth_field
 * /obj/item/rig_module/teleporter
 * /obj/item/rig_module/fabricator/energy_net
 * /obj/item/rig_module/self_destruct
 */

/obj/item/rig_module/stealth_field

	name = "active camouflage module"
	desc = "A robust hardsuit-integrated stealth module."
	icon_state = "cloak"

	toggleable = 1
	disruptable = 1
	disruptive = 0
	price_tag = 5000

	use_power_cost = 50
	active_power_cost = 10
	passive_power_cost = 0
	module_cooldown = 30

	activate_string = "Enable Cloak"
	deactivate_string = "Disable Cloak"

	interface_name = "integrated stealth system"
	interface_desc = "An integrated active camouflage system."

	suit_overlay_active =   "stealth_active"
	suit_overlay_inactive = "stealth_inactive"

/obj/item/rig_module/stealth_field/activate()

	if(!..())
		return 0

	var/mob/living/carbon/human/H = holder.wearer

	/* if(FALSE) //TODO: INSERT NINJA FULL SKILL CHECK HERE
		to_chat(H, "<font color='blue'><b>You are now invisible to normal detection.</b></font>")
		H.invisibility = INVISIBILITY_LEVEL_TWO
		H.alpha = 64
	else if(FALSE) //TODO: INSERT NINJA NOVICE SKILL CHECK HERE
		to_chat(H, "<font color='blue'<b>You are now cloaked to most observation.</b></font>")
		H.invisibility = INVISIBILITY_WEAK
		H.alpha = 8
	else */
	to_chat(H, "<font color='blue'<b>You are now blending into your surroundings.</b></font>") //if this is ever fixed, turn this invisibility to weak, indent
	H.invisibility = INVISIBILITY_LEVEL_TWO
	H.alpha = 32

	anim(get_turf(H), H, 'icons/effects/effects.dmi', "electricity",null,20,null)

	H.visible_message("[H.name] melds into the shadows!",1)

/obj/item/rig_module/stealth_field/deactivate()

	if(!..())
		return 0

	var/mob/living/carbon/human/H = holder.wearer

	to_chat(H, SPAN_DANGER("You are now visible."))
	H.invisibility = 0
	H.alpha = 255

	anim(get_turf(H), H,'icons/mob/mob.dmi',,"uncloak",,H.dir)
	anim(get_turf(H), H, 'icons/effects/effects.dmi', "electricity",null,20,null)

	for(var/mob/O in oviewers(H))
		O.show_message("[H.name] appears from thin air!",1)
	playsound(get_turf(H), 'sound/effects/stealthoff.ogg', 75, 1)



/obj/item/rig_module/teleporter

	name = "teleportation module"
	desc = "A complex, sleek-looking, hardsuit-integrated teleportation module."
	icon_state = "teleporter"
	use_power_cost = 40
	redundant = 1
	usable = 1
	selectable = 1

	price_tag = 3500

	var/realign_time = 0 //Used for skill-less teleports.

	engage_string = "Emergency Leap"

	interface_name = "VOID-shift phase projector"
	interface_desc = "An advanced teleportation system. It is capable of pinpoint precision or random leaps forward."

/obj/item/rig_module/teleporter/proc/phase_in(var/mob/M,var/turf/T)

	if(!M || !T)
		return


	holder.spark_system.start()
	playsound(T, 'sound/effects/phasein.ogg', 25, 1)
	playsound(T, 'sound/effects/sparks2.ogg', 50, 1)
	anim(T,M,'icons/mob/mob.dmi',,"phasein",,M.dir)

	new /obj/item/bluespace_dust(T)

/obj/item/rig_module/teleporter/proc/phase_out(var/mob/M,var/turf/T)

	if(!M || !T)
		return

	if (do_after(M, 10, src))
		visible_message(SPAN_WARNING("\the [src] begins to spool up!"))
		playsound(T, "sparks", 50, 1)
		anim(T,M,'icons/mob/mob.dmi',,"phaseout",,M.dir)

		new /obj/item/bluespace_dust(T)

/obj/item/rig_module/teleporter/engage(atom/target, notify_ai)

	if(!..()) return FALSE

	var/mob/living/carbon/human/H = holder.wearer

	if(!istype(H.loc, /turf))
		to_chat(H, SPAN_WARNING("You cannot teleport out of your current location."))
		return FALSE

	var/turf/T
	var/misalignment = round((realign_time - world.time)/90)
	if(target)
		T = get_turf(target)
		//if(!FALSE) //TODO: INSERT NINJA FULL SKILL CHECK HERE
		if(misalignment > 0) //if this is ever fixed, indent this block
			var/x_misalignment = rand(misalignment*2 + 1) - misalignment
			var/y_misalignment = rand(misalignment*2 + 1) - misalignment
			if(x_misalignment || y_misalignment)
				T = locate(T.x + x_misalignment, T.y + y_misalignment, T.z)
				to_chat(H, SPAN_WARNING("Your teleporter malfunctions!"))
				if(!T)
					T = get_turf(target)
		realign_time += 30
	else
		T = get_teleport_loc(get_turf(H), H, rand(5, 9+round(misalignment/2)))


	if(!T || T.density)
		to_chat(H, SPAN_WARNING("You cannot teleport into solid walls."))
		return FALSE

	if(isAdminLevel(T.z))
		to_chat(H, SPAN_WARNING("You cannot use your teleporter on this Z-level."))
		return FALSE

	if(T.contains_dense_objects())
		to_chat(H, SPAN_WARNING("You cannot teleport to a location with solid objects."))
		return FALSE

	if(T.z != H.z || get_dist(T, get_turf(H)) > world.view)
		to_chat(H, SPAN_WARNING("You cannot teleport to such a distant object."))
		return FALSE

	phase_out(H,get_turf(H))
	H.forceMove(T)
	phase_in(H,get_turf(H))

	for(var/obj/item/grab/G in H.contents)
		if(G.affecting)
			phase_out(G.affecting,get_turf(G.affecting))
			go_to_bluespace(get_turf(H), 3, TRUE, H, T)
			phase_in(G.affecting,get_turf(G.affecting))

	realign_time = max(world.time, realign_time) + 30
	return TRUE

/obj/item/rig_module/fabricator/energy_net

	name = "net projector"
	desc = "Some kind of complex energy projector with a hardsuit mount."
	icon_state = "enet"

	interface_name = "energy net launcher"
	interface_desc = "An advanced energy-patterning projector used to capture targets."

	engage_string = "Fabricate Net"

	fabrication_type = /obj/item/energy_net
	use_power_cost = 70

/obj/item/rig_module/fabricator/energy_net/engage(atom/target)

	if(holder && holder.wearer)
		if(..(target) && target)
			holder.wearer.Beam(target,"n_beam",,10)
		return 1
	return 0

/obj/item/rig_module/self_destruct

	name = "self-destruct module"
	desc = "Oh my God, Commander. A bomb."
	icon_state = "deadman"
	usable = 1
	active = 1
	permanent = 1

	engage_string = "Detonate"

	interface_name = "dead man's switch"
	interface_desc = "An integrated self-destruct module. When the wearer dies, so does the surrounding area. Do not press this button."
	var/list/explosion_values = list(2,2,4,5)

/obj/item/rig_module/self_destruct/small
	explosion_values = list(0,0,3,4)

/obj/item/rig_module/self_destruct/activate()
	return

/obj/item/rig_module/self_destruct/deactivate()
	return

/obj/item/rig_module/self_destruct/Process()

	// Not being worn, leave it alone.
	if(!holder || !holder.wearer || !holder.wearer.wear_suit == holder)
		return 0

	//OH SHIT.
	if(holder.wearer.stat == 2)
		engage(1)

/obj/item/rig_module/self_destruct/engage(var/skip_check)
	if(!skip_check && usr && alert(usr, "Are you sure you want to push that button?", "Self-destruct", "No", "Yes") == "No")
		return
	explosion(get_turf(src), explosion_values[1], explosion_values[2], explosion_values[3], explosion_values[4])
	if(holder && holder.wearer)
		holder.wearer.drop_from_inventory(src)
		qdel(holder)
	qdel(src)
