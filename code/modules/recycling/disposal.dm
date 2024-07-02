// Disposal bin
// Holds items for disposal into pipe system
// Draws air from turf, gradually charges internal reservoir
// Once full (~1 atm), uses air resv to flush items into the pipes
// Automatically recharges air (unless off), will flush when ready if pre-set
// Can hold items and human size things, no other draggables
// Toilets are a type of disposal bin for small objects only and work on magic. By magic, I mean torque rotation
#define SEND_PRESSURE (700 + ONE_ATMOSPHERE) //kPa - assume the inside of a dispoal pipe is 1 atm, so that needs to be added.
#define PRESSURE_TANK_VOLUME 150	//L
#define PUMP_MAX_FLOW_RATE 90		//L/s - 4 m/s using a 15 cm by 15 cm inlet
#define PERCENT_PER_PROCESS 0.084 // ~12 cycles = 24 seconds

#define DISPOSALS_OFF "Off"
#define DISPOSALS_CHARGING "Pressurizing"
#define DISPOSALS_CHARGED "Ready"


/obj/machinery/disposal
	name = "disposal unit"
	desc = "A pneumatic waste disposal unit."
	icon = 'icons/obj/pipes/disposal.dmi'
	icon_state = "disposal"
	anchored = TRUE
	density = TRUE
	layer = LOW_OBJ_LAYER //This allows disposal bins to be underneath tables
	var/percent_charged = 1
	var/mode = DISPOSALS_CHARGED
	var/flush = 0	// true if flush handle is pulled
	var/obj/structure/disposalpipe/trunk/trunk = null // the attached pipe trunk
	var/flushing = 0	// true if flushing in progress
	var/flush_every_ticks = 30 //Every 30 ticks it will look whether it is ready to flush
	var/flush_count = 0 //this var adds 1 once per tick. When it reaches flush_every_ticks it resets and tries to flush.
	var/last_sound = 0
	active_power_usage = 1100 // per tick, goal is 13,210 power over 12 cycles = 1100
	idle_power_usage = 100

/obj/machinery/disposal/Initialize(mapload, d)
	..()
	return INITIALIZE_HINT_LATELOAD
	
// create a new disposal
// find the attached trunk (if present) 
/obj/machinery/disposal/LateInitialize(mapload)
	. = ..()

	trunk = locate() in loc
	if(!trunk)
		mode = DISPOSALS_OFF
		flush = 0
	else
		trunk.linked = src	// link the pipe trunk to self

	update()

/obj/machinery/disposal/Destroy()
	eject()
	if(trunk)
		trunk.linked = null
	trunk = null
	return ..()

/obj/machinery/disposal/affect_grab(mob/living/user, mob/living/target)
	if(target.mob_size > MOB_MEDIUM) //We cant stuff in anything bigger then 20
		to_chat(user, SPAN_WARNING("[target] is too big to go in [src]."))
		return

	user.visible_message("[user] starts putting [target] into the disposal.")

	var/time_to_put = target.mob_size //size is perfectly suit
	if(do_after(user, time_to_put, src) && Adjacent(target))
		user.face_atom(src)
		target.forceMove(src)
		visible_message(SPAN_NOTICE("[target] has been placed in the [src] by [user]."))
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Has placed [target] ([target.ckey]) in disposals.</font>")
		target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been placed in disposals by [user.name] ([user.ckey])</font>")
		msg_admin_attack("[key_name_admin(user)] placed [key_name_admin(target)] in a disposals unit.")
		return TRUE

// attack by item places it in to disposal
/obj/machinery/disposal/attackby(obj/item/I, mob/user)
	if(stat & BROKEN || !I || !user)
		return

	add_fingerprint(user)

	var/list/usable_qualities = list()
	if(mode == DISPOSALS_OFF)
		usable_qualities.Add(QUALITY_SCREW_DRIVING)
	if(panel_open)
		usable_qualities.Add(QUALITY_WELDING)

	var/tool_type = I.get_tool_type(user, usable_qualities, src)
	switch(tool_type)
		if(QUALITY_SCREW_DRIVING)
			if(length(contents) > 0)
				to_chat(user, "Eject the items first!")
				return

			if(mode != DISPOSALS_OFF)
				to_chat(user, "Turn off the pump first!")
				return

			var/used_sound = panel_open ? 'sound/machines/Custom_screwdriverclose.ogg' : 'sound/machines/Custom_screwdriveropen.ogg'
			if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC, instant_finish_tier = 30, forced_sound = used_sound))
				to_chat(user, "You [panel_open ? "attach" : "remove"] the screws around the power connection.")
				panel_open = !panel_open
			return

		if(QUALITY_WELDING)
			if(length(contents) > 0)
				to_chat(user, "Eject the items first!")
				return

			if(!panel_open || mode != DISPOSALS_OFF)
				to_chat(user, "You cannot work on the disposal unit if it is not turned off with its power connection exposed.")
				return

			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
				to_chat(user, "You sliced the floorweld off the disposal unit.")
				var/obj/structure/disposalconstruct/C = new(loc)
				transfer_fingerprints_to(C)
				C.pipe_type = PIPE_TYPE_BIN
				C.anchored = TRUE
				C.density = TRUE
				C.update()
				qdel(src)
			return

		if(ABORT_CHECK)
			return

	if(istype(I, /obj/item/storage/bag))
		var/obj/item/storage/bag/T = I
		to_chat(user, SPAN_NOTICE("You empty [I] into [src]."))
		for(var/obj/item/O in T.contents)
			T.remove_from_storage(O,src)
		T.update_icon()
		update()
		return

	if(!I)
		return

	if(user.unEquip(I, src))
		user.visible_message(
			"[user.name] places [I] into [src].",
			"You place [I] into the [src]."
		)
		playsound(loc, 'sound/machines/vending_drop.ogg', 100, 1)
		update()

// mouse drop another mob or self
//
/obj/machinery/disposal/MouseDrop_T(atom/movable/A, mob/user)
	if(ismob(A))
		var/mob/target = A
		if(user.incapacitated(INCAPACITATION_ALL))
			return
		if(target.buckled || target.anchored || get_dist(user, src) > 1 || get_dist(user, target) > 1)
			return

		//animals cannot put mobs other than themselves into disposal
		if(isanimal(user) && target != user)
			to_chat(user, SPAN_WARNING("Animals cannot put mobs other than themselves into disposals."))
			return

		if(target.mob_size > MOB_MEDIUM) //We cant stuff in anything bigger then 20
			to_chat(user, SPAN_WARNING("[target] is too big to go in [src]."))
			return

		add_fingerprint(user)
		
		if(target == user)
			user.visible_message(SPAN_DANGER("[user] starts climbing into [src]."), SPAN_DANGER("You start climbing into [src]."))
		else
			user.visible_message(SPAN_DANGER("[user] starts stuffing [target] into [src]."), SPAN_DANGER("You start stuffing [target] into [src]."))

		var/delay = 20
		var/target_loc = target.loc
		if(!do_after(user, max(delay * user.stats.getMult(STAT_VIG, STAT_LEVEL_EXPERT), delay * 0.66), src))
			return
		if(target_loc != target.loc)
			return
		// do_after incapacitation_flags don't work yet
		if(user.incapacitated(INCAPACITATION_ALL))
			return

		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Has placed [key_name(target)]]) in disposals.</font>")
		target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been placed in disposals by [key_name(user)]</font>")
		msg_admin_attack("[key_name_admin(user)] placed [key_name_admin(target)] in a disposals unit.")

		if(target == user)
			user.visible_message(
				SPAN_DANGER("[user] climbs into [src]."),
				SPAN_DANGER("You climb into [src].")
			)
		else
			user.visible_message(
				SPAN_DANGER("[user] stuffs [target] into [src]."),
				SPAN_DANGER("You stuff [target] into [src].")
			)

		target.reset_view(src)
		target.simple_move_animation(src)
		target.forceMove(src)

		update()
		return

	else if(isitem(A))
		var/obj/item/I = A
		if(!Adjacent(user) || !I.Adjacent(user) || user.stat)
			return ..()
		if(istype(I, /obj/item/storage/bag/trash))
			var/obj/item/storage/bag/trash/T = I
			to_chat(user, SPAN_NOTICE("You empty the bag."))
			for(var/obj/item/O in T.contents)
				T.remove_from_storage(O,src)
			T.update_icon()
			update()
			return

		if(!I)
			return

		I.add_fingerprint(user)

		if(user.unEquip(I, src))
			user.visible_message(
				"[user] places [I] into [src].",
				"You place [I] into [src]."
			)
			playsound(loc, 'sound/machines/vending_drop.ogg', 100, 1)
		else
			user.visible_message(
				"[user] fails to throw away [I] into [src].",
				"You fail to throw away [I] into [src]."
			)

		update()
		return

	. = ..()

// attempt to move while inside
/obj/machinery/disposal/relaymove(mob/user)
	if(user.stat || flushing)
		return
	if(user.loc == src)
		go_out(user)

// leave the disposal
/obj/machinery/disposal/proc/go_out(mob/user)
	user.forceMove(loc)
	user.reset_view()
	update()

/obj/machinery/disposal/ui_state(mob/user)
	return GLOB.notcontained_state

/obj/machinery/disposal/ui_interact(mob/user, datum/tgui/ui)
	if(stat & BROKEN)
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DisposalUnit")
		ui.set_autoupdate(TRUE)
		ui.open()

/obj/machinery/disposal/ui_data(mob/user)
	var/list/data = list(
		"isai" = isAI(user),
		"mode" = mode,
		"handle" = flush,
		"panel" = panel_open,
		"eject" = length(contents) ? TRUE : FALSE,
	)
	return data

/obj/machinery/disposal/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return TRUE

	switch(action)
		if("toggle")
			if(params["pump"])
				mode = (mode == DISPOSALS_OFF) ? DISPOSALS_CHARGING : DISPOSALS_OFF
				update()
			else if(params["handle"])
				if(panel_open)
					return TRUE
				flush = !flush
				update()
			return TRUE

		if("eject")
			eject()
			return TRUE

// eject the contents of the disposal unit
/obj/machinery/disposal/proc/eject()
	for(var/atom/movable/AM in src)
		AM.forceMove(loc)
		AM.pipe_eject(0)
	update()

// update state to match stat and update the icon
/obj/machinery/disposal/proc/update()
	if(stat & BROKEN)
		mode = DISPOSALS_OFF
		flush = 0

	update_icon()

/obj/machinery/disposal/update_icon()
	. = ..()
	cut_overlays()

	if(stat & BROKEN)
		icon_state = "disposal-broken"

	// only handle is shown if no power
	if(stat & NOPOWER || mode == DISPOSALS_OFF)
		return

	// charging and ready light
	if(mode == DISPOSALS_CHARGING)
		add_overlay(image(icon, "dispover-charge"))
	else if(mode == DISPOSALS_CHARGED)
		add_overlay(image(icon, "dispover-ready"))

	// 	check for items in disposal - occupied light
	if(contents.len > 0)
		add_overlay(image(icon, "dispover-full"))

	// flush handle
	if(flush)
		add_overlay(image(icon, "dispover-handle"))

// timed process
// charge the "gas" reservoir and perform flush if ready
/obj/machinery/disposal/Process()
	if(stat & BROKEN) // nothing can happen if broken
		update_use_power(0)
		return

	flush_count++
	if(flush_count >= flush_every_ticks)
		if(LAZYLEN(contents))
			if(mode == DISPOSALS_CHARGED)
				spawn(0)
					flush()
		flush_count = 0

	// flush can happen even without power
	if(flush && percent_charged >= 1)
		flush()

	if(mode != DISPOSALS_CHARGING)
		update_use_power(1)
	else if(percent_charged >= 1)
		mode = DISPOSALS_CHARGED
		update()
	else
		pressurize() //otherwise charge

/obj/machinery/disposal/proc/pressurize()
	// won't charge if no power
	if(stat & NOPOWER)
		update_use_power(0)
		return

	if(percent_charged >= 1)
		return

	use_power(active_power_usage)
	percent_charged = CLAMP01(percent_charged + PERCENT_PER_PROCESS)

// perform a flush
/obj/machinery/disposal/proc/flush()
	flushing = 1
	flick("[icon_state]-flush", src)

	var/wrapcheck = 0
	var/obj/structure/disposalholder/H = new()	// virtual holder object which actually
												// travels through the pipes.
	//Hacky test to get drones to mail themselves through disposals.
	for(var/mob/living/silicon/robot/drone/D in src)
		wrapcheck = 1

	for(var/obj/item/smallDelivery/O in src)
		wrapcheck = 1

	if(wrapcheck == 1)
		H.tomail = 1

	sleep(10)
	if(last_sound < world.time + 1)
		playsound(src, 'sound/machines/disposalflush.ogg', 50, 0, 0)
		last_sound = world.time
	sleep(5) // wait for animation to finish

	H.init(src)	// copy the contents of disposer to holder
	H.start(src) // start the holder processing movement
	flushing = 0
	// now reset disposal state
	flush = 0
	percent_charged = 0
	if(mode == DISPOSALS_CHARGED)
		mode = DISPOSALS_CHARGING
	update()

// called when area power changes
/obj/machinery/disposal/power_change()
	..()	// do default setting/reset of stat NOPOWER bit
	update()	// update icon

// called when holder is expelled from a disposal
// should usually only occur if the pipe network is modified
/obj/machinery/disposal/proc/get_eject_turf()
	get_offset_target_turf(loc, rand(5)-rand(5), rand(5)-rand(5))

/obj/machinery/disposal/proc/expel(obj/structure/disposalholder/H)
	var/turf/target = get_eject_turf()
	playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
	if(H) // Somehow, someone managed to flush a window which broke mid-transit and caused the disposal to go in an infinite loop trying to expel null, hopefully this fixes it
		for(var/atom/movable/AM in H)
			AM.forceMove(loc)
			AM.pipe_eject(0)
			if(!isdrone(AM)) //Poor drones kept smashing windows and taking system damage being fired out of disposals. ~Z
				spawn(1)
					if(AM)
						AM.throw_at(target, 5, 1)

		qdel(H)

/obj/machinery/disposal/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(ishuman(mover) && mover.throwing)
		var/mob/living/carbon/human/H = mover
		if(H.stats.getPerk(PERK_SPACE_ASSHOLE))
			H.forceMove(src)
			visible_message("[H] dives into [src]!")
			flush = TRUE
		return
	else if(isitem(mover) && mover.throwing)
		var/obj/item/I = mover
		if(istype(I, /obj/item/projectile))
			return
		else
			if(prob(75))
				I.forceMove(src)
				visible_message("[I] lands in [src].")
			else
				visible_message("[I] bounces off of [src]'s rim!")
	else if(istype(mover, /obj/item/projectile))
		return TRUE
	else
		return ..(mover, target, height, air_group)

// virtual disposal object
// travels through pipes in lieu of actual items
// contents will be items flushed by the disposal
/obj/structure/disposalholder
	invisibility = 101
	dir = 0

	var/active = 0	// true if the holder is moving, otherwise inactive
	var/count = 2048	//*** can travel 2048 steps before going inactive (in case of loops)
	var/destinationTag = "" // changes if contains a delivery container
	var/tomail = 0 //changes if contains wrapped package
	var/has_mob = FALSE //If it contains a mob
	var/from_cloner = FALSE // if the package originates from a genetics cloner
	var/partialTag = "" //set by a partial tagger the first time round, then put in destinationTag if it goes through again.


// initialize a holder from the contents of a disposal unit
/obj/structure/disposalholder/proc/init(obj/machinery/disposal/D)
	// these three loops are here to prevent someone from mailing themselves into a sensitive area
	// by simply including a delivery in the same package as them

	//Check for any living mobs trigger hasmob.
	//hasmob effects whether the package goes to cargo or its tagged destination.
	for(var/mob/living/M in D)
		M.reset_view(src)
		if(M && M.stat != DEAD && !isdrone(M))
			has_mob = TRUE

	//Checks 1 contents level deep. This means that players can be sent through disposals...
	//...but it should require a second person to open the package. (i.e. person inside a wrapped locker)
	for(var/obj/O in D)
		if(O.contents)
			for(var/mob/living/M in O.contents)
				M.reset_view(src)
				if(M && M.stat != DEAD && !isdrone(M))
					has_mob = TRUE

	// now everything inside the disposal gets put into the holder
	// note AM since can contain mobs or objs
	for(var/atom/movable/AM in D)
		AM.forceMove(src)
		if(istype(AM, /obj/structure/bigDelivery) && !has_mob)
			var/obj/structure/bigDelivery/T = AM
			destinationTag = T.sortTag
		if(istype(AM, /obj/item/smallDelivery) && !has_mob)
			var/obj/item/smallDelivery/T = AM
			destinationTag = T.sortTag
		//Drones can mail themselves through maint.
		if(isdrone(AM))
			var/mob/living/silicon/robot/drone/drone = AM
			destinationTag = drone.mail_destination

// start the movement process
// argument is the disposal unit the holder started in
/obj/structure/disposalholder/proc/start(obj/machinery/disposal/D)
	if(!D.trunk)
		D.expel(src)	// no trunk connected, so expel immediately
		return

	forceMove(D.trunk)
	active = TRUE
	set_dir(DOWN)
	spawn(1)
		move()		// spawn off the movement process

	return

// movement process, persists while holder is moving through pipes
/obj/structure/disposalholder/proc/move()
	var/obj/structure/disposalpipe/last
	while(active)
		sleep(1)		// was 1
		if(!loc)
			return // check if we got GC'd

		if(has_mob && prob(10) && !from_cloner) //Mobs shunted from the cloning vat are free from damage.
			for(var/mob/living/H in src)
				if(isdrone(H)) //Drones use the mailing code to move through the disposal system,
					continue
				//if(H.stats.getPerk(PERK_SPACE_ASSHOLE)) //Assholes gain disposal immunity
				//	continue - SoJ edit, we dont want perfect immunity
				// Hurt any living creature jumping down disposals
				var/multiplier = 1

				// STAT_MEC or STAT_TGH help you reduce disposal damage, with no damage being recieved at all at STAT_LEVEL_EXPERT
				//if(H.stats)
				//	multiplier = min(H.stats.getMult(STAT_MEC, STAT_LEVEL_EXPERT), H.stats.getMult(STAT_TGH, STAT_LEVEL_EXPERT))
				//Soj edit we want these to be REALLY deadly and not good for fast travel
				if(multiplier > 0)
					H.take_overall_damage(8 * multiplier, 0, "Blunt Trauma")

		var/obj/structure/disposalpipe/current = loc
		last = current
		current = current.transfer(src)

		if(!loc)
			return //side effects

		if(!current)
			last.expel(src, loc, dir)

		if(!(count--))
			active = FALSE
	return


// find the turf which should contain the next pipe
/obj/structure/disposalholder/proc/nextloc()
	return get_step(loc, dir)

// find a matching pipe on a turf
/obj/structure/disposalholder/proc/findpipe(turf/T)
	if(!T)
		return null

	var/fdir = turn(dir, 180)	// flip the movement direction
	for(var/obj/structure/disposalpipe/P in T)
		if(fdir & P.pipe_dir)		// find pipe direction mask that matches flipped dir
			return P
	// if no matching pipe, return null
	return null

// merge two holder objects
// used when a a holder meets a stuck holder
/obj/structure/disposalholder/proc/merge(obj/structure/disposalholder/other)
	for(var/atom/movable/AM in other)
		AM.forceMove(src)		// move everything in other holder to this one
		if(ismob(AM))
			var/mob/M = AM
			if(M.client)	// if a client mob, update eye to follow this holder
				M.client.eye = src

	qdel(other)

/obj/structure/disposalholder/proc/settag(new_tag)
	destinationTag = new_tag

/obj/structure/disposalholder/proc/setpartialtag(new_tag)
	if(partialTag == new_tag)
		destinationTag = new_tag
		partialTag = ""
	else
		partialTag = new_tag

// called when player tries to move while in a pipe
/obj/structure/disposalholder/relaymove(mob/user)
	if(!isliving(user))
		return

	var/mob/living/U = user

	if(U.stat || U.last_special <= world.time)
		return

	U.last_special = world.time + 100

	if(loc)
		for(var/mob/M in hearers(loc.loc))
			to_chat(M, "<FONT size=[max(0, 5 - get_dist(src, M))]>CLONG, clong!</FONT>")

	playsound(loc, 'sound/effects/clang.ogg', 50, 0, 0)

/obj/structure/disposalholder/Destroy()
	active = 0
	return ..()

/obj/structure/disposalholder/AllowDrop()
	return TRUE

// Disposal pipes
/obj/structure/disposalpipe
	icon = 'icons/obj/pipes/disposal.dmi'
	name = "disposal pipe"
	desc = "An underfloor disposal pipe."
	plane = FLOOR_PLANE
	layer = DISPOSAL_PIPE_LAYER
	anchored = TRUE
	density = FALSE

	level = BELOW_PLATING_LEVEL			// underfloor only
	var/pipe_dir = 0		// bitmask of pipe directions
	dir = 0				// dir will contain dominant direction for junction pipes
	health = 10 	// health points 0-10
	layer = 2.3			// slightly lower than wires and other pipes
	var/base_icon_state	// initial icon state on map
	var/sortType = list()
	var/subtype = SORT_TYPE_NORMAL

// new pipe, set the icon_state as on map
/obj/structure/disposalpipe/New()
	. = ..()
	base_icon_state = icon_state

// pipe is deleted
// ensure if holder is present, it is expelled
/obj/structure/disposalpipe/Destroy()
	var/obj/structure/disposalholder/H = locate() in src
	if(H)
		// holder was present
		H.active = FALSE
		var/turf/T = loc
		if(T.density)
			// deleting pipe is inside a dense turf (wall)
			// this is unlikely, but just dump out everything into the turf in case

			for(var/atom/movable/AM in H)
				AM.forceMove(T)
				AM.pipe_eject(0)
			qdel(H)
			return ..()

		// otherwise, do normal expel from turf
		if(H)
			expel(H, T, 0)
	. = ..()

// returns the direction of the next pipe object, given the entrance dir
// by default, returns the bitmask of remaining directions
/obj/structure/disposalpipe/proc/nextdir(fromdir)
	return pipe_dir & (~turn(fromdir, 180))

// transfer the holder through this pipe segment
// overriden for special behaviour
//
/obj/structure/disposalpipe/proc/transfer(obj/structure/disposalholder/H)
	var/nextdir = nextdir(H.dir)
	H.set_dir(nextdir)
	var/turf/T = H.nextloc()
	var/obj/structure/disposalpipe/P = H.findpipe(T)

	if(P)
		// find other holder in next loc, if inactive merge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null

	return P


// update the icon_state to reflect hidden status
/obj/structure/disposalpipe/proc/update()
	var/turf/T = loc
	// space never hides pipes
	hide(!T.is_plating() && !istype(T,/turf/space))

// hide called by levelupdate if turf intact status changes
// change visibility status and force update of icon
/obj/structure/disposalpipe/hide(intact)
	invisibility = intact ? 101: 0	// hide if floor is intact
	update_icon()

// update actual icon_state depending on visibility
// if invisible, append "f" to icon_state to show faded version
// this will be revealed if a T-scanner is used
// if visible, use regular icon_state
/obj/structure/disposalpipe/update_icon()
	icon_state = base_icon_state

// expel the held objects into a turf
// called when there is a break in the pipe
/obj/structure/disposalpipe/proc/expel(obj/structure/disposalholder/H, turf/T, direction)
	if(!istype(H))
		return

	// Empty the holder if it is expelled into a dense turf.
	// Leaving it intact and sitting in a wall is stupid.
	if(T.density)
		for(var/atom/movable/AM in H)
			AM.loc = T
			AM.pipe_eject(0)
		qdel(H)
		return

	if(!T.is_plating() && istype(T,/turf/simulated/floor)) //intact floor, pop the tile
		var/turf/simulated/floor/F = T
		F.break_tile()
		new /obj/item/stack/tile(H)	// add to holder so it will be thrown with other stuff

	var/turf/target
	if(direction)		// direction is specified
		if(istype(T, /turf/space)) // if ended in space, then range is unlimited
			target = get_edge_target_turf(T, direction)
		else						// otherwise limit to 10 tiles
			target = get_ranged_target_turf(T, direction, 10)

		playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
		if(H)
			for(var/atom/movable/AM in H)
				AM.forceMove(T)
				AM.pipe_eject(direction)
				spawn(1)
					if(AM)
						AM.throw_at(target, 100, 1)
			qdel(H)

	else	// no specified direction, so throw in random direction
		playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
		if(H)
			for(var/atom/movable/AM in H)
				target = get_offset_target_turf(T, rand(5)-rand(5), rand(5)-rand(5))

				AM.forceMove(T)
				AM.pipe_eject(0)
				spawn(1)
					if(AM)
						AM.throw_at(target, 5, 1)

			qdel(H)

// call to break the pipe
// will expel any holder inside at the time
// then delete the pipe
// remains : set to leave broken pipe pieces in place
/obj/structure/disposalpipe/proc/broken(remains = 0)
	if(remains)
		for(var/D in cardinal)
			if(D & pipe_dir)
				var/obj/structure/disposalpipe/broken/P = new(loc)
				P.set_dir(D)

	invisibility = 101	// make invisible (since we won't delete the pipe immediately)
	var/obj/structure/disposalholder/H = locate() in src
	if(H)
		// holder was present
		H.active = 0
		var/turf/T = loc
		if(T.density)
			// broken pipe is inside a dense turf (wall)
			// this is unlikely, but just dump out everything into the turf in case

			for(var/atom/movable/AM in H)
				AM.forceMove(T)
				AM.pipe_eject(0)
			qdel(H)
			return

		// otherwise, do normal expel from turf
		if(H)
			expel(H, T, 0)

	spawn(2)	// delete pipe after 2 ticks to ensure expel proc finished
		qdel(src)


// pipe affected by explosion
/obj/structure/disposalpipe/ex_act(severity)
	switch(severity)
		if(1)
			broken(0)
			return
		if(2)
			health -= rand(5,15)
			healthCheck()
			return
		if(3)
			health -= rand(0,15)
			healthCheck()
			return


	// test health for brokenness
/obj/structure/disposalpipe/healthCheck()
	if(health < -2)
		broken(0)
	else if(health < 1)
		broken(1)
	return

	//attack by item
	//weldingtool: unfasten and convert to obj/disposalconstruct

/obj/structure/disposalpipe/attackby(obj/item/I, mob/user)
	var/turf/T = loc
	if(!T.is_plating())
		return		// prevent interaction with T-scanner revealed pipes

	add_fingerprint(user)

	if(QUALITY_WELDING in I.tool_qualities)
		if(I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_WELDING, FAILCHANCE_EASY, required_stat = STAT_MEC))
			welded()
		return

	// called when pipe is cut with welder
/obj/structure/disposalpipe/proc/welded()
	var/obj/structure/disposalconstruct/C = new(loc)
	switch(base_icon_state)
		if("pipe-s")
			C.pipe_type = PIPE_TYPE_STRAIGHT
		if("pipe-c")
			C.pipe_type = PIPE_TYPE_BENT
		if("pipe-j1")
			C.pipe_type = PIPE_TYPE_JUNC
		if("pipe-j2")
			C.pipe_type = PIPE_TYPE_JUNC_FLIP
		if("pipe-y")
			C.pipe_type = PIPE_TYPE_JUNC_Y
		if("pipe-t")
			C.pipe_type = PIPE_TYPE_TRUNK
		if("pipe-j1s")
			C.pipe_type = PIPE_TYPE_JUNC_SORT
			C.sortType = sortType
		if("pipe-j2s")
			C.pipe_type = PIPE_TYPE_JUNC_SORT_FLIP
			C.sortType = sortType
///// Z-Level stuff
		if("pipe-u")
			C.pipe_type = PIPE_TYPE_UP
		if("pipe-d")
			C.pipe_type = PIPE_TYPE_DOWN
///// Z-Level stuff end
		if("pipe-tagger")
			C.pipe_type = PIPE_TYPE_TAGGER
		if("pipe-tagger-partial")
			C.pipe_type = PIPE_TYPE_TAGGER_PART
	C.sort_mode = subtype
	transfer_fingerprints_to(C)
	C.set_dir(dir)
	C.density = FALSE
	C.anchored = TRUE
	C.update()

	qdel(src)

/obj/structure/disposalpipe/hides_under_flooring()
	return TRUE

// *** TEST verb
//client/verb/dispstop()
//	for(var/obj/structure/disposalholder/H in world)
//		H.active = 0

// a straight or bent segment
/obj/structure/disposalpipe/segment
	icon_state = "pipe-s"

/obj/structure/disposalpipe/segment/New()
	. = ..()
	if(icon_state == "pipe-s")
		pipe_dir = dir | turn(dir, 180)
	else
		pipe_dir = dir | turn(dir, -90)

	update()

///// Z-Level stuff
/obj/structure/disposalpipe/up
	icon_state = "pipe-u"

/obj/structure/disposalpipe/up/New()
	. = ..()
	pipe_dir = dir
	update()

/obj/structure/disposalpipe/up/nextdir(fromdir)
	var/nextdir
	if(fromdir == DOWN)
		nextdir = dir
	else
		nextdir = UP
	return nextdir

/obj/structure/disposalpipe/up/transfer(obj/structure/disposalholder/H)
	var/nextdir = nextdir(H.dir)
	H.set_dir(nextdir)

	var/turf/T
	var/obj/structure/disposalpipe/P
	if(nextdir == UP)
		T = GetAbove(src)
		if(!T)
			H.forceMove(loc)
			return
		else
			for(var/obj/structure/disposalpipe/down/F in T)
				P = F
	else
		T = get_step(loc, H.dir)
		P = H.findpipe(T)

	if(P)
		// find other holder in next loc, if inactive merge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null

	return P

/obj/structure/disposalpipe/down
	icon_state = "pipe-d"

/obj/structure/disposalpipe/down/New()
	. = ..()
	pipe_dir = dir
	update()

/obj/structure/disposalpipe/down/nextdir(fromdir)
	var/nextdir
	if(fromdir == UP)
		nextdir = dir
	else
		nextdir = DOWN
	return nextdir

/obj/structure/disposalpipe/down/transfer(obj/structure/disposalholder/H)
	var/nextdir = nextdir(H.dir)
	H.dir = nextdir

	var/turf/T
	var/obj/structure/disposalpipe/P

	if(nextdir == DOWN)
		T = GetBelow(src)
		if(!T)
			H.forceMove(loc)
			return
		else
			for(var/obj/structure/disposalpipe/up/F in T)
				P = F

	else
		T = get_step(loc, H.dir)
		P = H.findpipe(T)

	if(P)
		// find other holder in next loc, if inactive merge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null

	return P
///// Z-Level stuff

/obj/structure/disposalpipe/junction/yjunction
	icon_state = "pipe-y"

//a three-way junction with dir being the dominant direction
/obj/structure/disposalpipe/junction
	icon_state = "pipe-j1"

/obj/structure/disposalpipe/junction/New()
	. = ..()
	if(icon_state == "pipe-j1")
		pipe_dir = dir | turn(dir, -90) | turn(dir,180)
	else if(icon_state == "pipe-j2")
		pipe_dir = dir | turn(dir, 90) | turn(dir,180)
	else // pipe-y
		pipe_dir = dir | turn(dir,90) | turn(dir, -90)
	update()

// next direction to move
// if coming in from secondary dirs, then next is primary dir
// if coming in from primary dir, then next is equal chance of other dirs
/obj/structure/disposalpipe/junction/nextdir(var/fromdir)
	var/flipdir = turn(fromdir, 180)
	if(flipdir != dir)	// came from secondary dir
		return dir		// so exit through primary
	else				// came from primary
						// so need to choose either secondary exit
		var/mask = ..(fromdir)

		// find a bit which is set
		var/setbit = 0
		if(mask & NORTH)
			setbit = NORTH
		else if(mask & SOUTH)
			setbit = SOUTH
		else if(mask & EAST)
			setbit = EAST
		else
			setbit = WEST

		if(prob(50))	// 50% chance to choose the found bit or the other one
			return setbit
		else
			return mask & (~setbit)


/obj/structure/disposalpipe/tagger
	name = "package tagger"
	icon_state = "pipe-tagger"
	var/sort_tag = ""
	var/partial = 0

/obj/structure/disposalpipe/tagger/proc/updatedesc()
	desc = initial(desc)
	if(sort_tag)
		desc += "\nIt's tagging objects with the '[sort_tag]' tag."

/obj/structure/disposalpipe/tagger/proc/updatename()
	if(sort_tag)
		name = "[initial(name)] ([sort_tag])"
	else
		name = initial(name)

/obj/structure/disposalpipe/tagger/New()
	. = ..()
	pipe_dir = dir | turn(dir, 180)
	if(sort_tag)
		tagger_locations |= sort_tag
	updatename()
	updatedesc()
	update()

/obj/structure/disposalpipe/tagger/attackby(obj/item/I, mob/user)
	if(..())
		return

	if(istype(I, /obj/item/device/destTagger))
		var/obj/item/device/destTagger/O = I

		if(O.currTag)// Tag set
			sort_tag = O.currTag
			playsound(loc, 'sound/machines/twobeep.ogg', 100, 1)
			to_chat(user, SPAN_NOTICE("Changed tag to '[sort_tag]'."))
			updatename()
			updatedesc()

/obj/structure/disposalpipe/tagger/transfer(obj/structure/disposalholder/H)
	if(sort_tag)
		if(partial)
			H.setpartialtag(sort_tag)
		else
			H.settag(sort_tag)
	return ..()

/obj/structure/disposalpipe/tagger/partial //needs two passes to tag
	name = "partial package tagger"
	icon_state = "pipe-tagger-partial"
	partial = 1

//a three-way junction that sorts objects
/obj/structure/disposalpipe/sortjunction
	name = "sorting junction"
	icon_state = "pipe-j1s"
	desc = "An underfloor disposal pipe with a package sorting mechanism."

	var/posdir = 0
	var/negdir = 0
	var/sortdir = 0

/obj/structure/disposalpipe/sortjunction/proc/updatedesc()
	desc = initial(desc)
	if(sortType)
		desc += "\nIt's filtering objects with the '[sortType]' tag."

/obj/structure/disposalpipe/sortjunction/proc/updatename()
	if(sortType)
		name = "[initial(name)] ([sortType])"
	else
		name = initial(name)

/obj/structure/disposalpipe/sortjunction/proc/updatedir()
	posdir = dir
	negdir = turn(posdir, 180)

	if(icon_state == "pipe-j1s")
		sortdir = turn(posdir, -90)
	else if(icon_state == "pipe-j2s")
		sortdir = turn(posdir, 90)

	pipe_dir = sortdir | posdir | negdir

/obj/structure/disposalpipe/sortjunction/New()
	. = ..()
	if(sortType) tagger_locations |= sortType

	updatedir()
	updatename()
	updatedesc()
	update()

/obj/structure/disposalpipe/sortjunction/attackby(obj/item/I, mob/user)
	if(..())
		return

	if(istype(I, /obj/item/device/destTagger))
		var/obj/item/device/destTagger/O = I

		if(O.currTag)// Tag set
			sortType = O.currTag
			playsound(loc, 'sound/machines/twobeep.ogg', 100, 1)
			to_chat(user, "\blue Changed filter to '[sortType]'.")
			updatename()
			updatedesc()

/obj/structure/disposalpipe/sortjunction/proc/divert_check(checkTag)
	if(islist(sortType))
		return checkTag in sortType
	else
		return checkTag == sortType

	// next direction to move
	// if coming in from negdir, then next is primary dir or sortdir
	// if coming in from posdir, then flip around and go back to posdir
	// if coming in from sortdir, go to posdir

/obj/structure/disposalpipe/sortjunction/nextdir(fromdir, sortTag)
	if(fromdir != sortdir)	// probably came from the negdir
		if(divert_check(sortTag))
			return sortdir
		else
			return posdir
	else				// came from sortdir
						// so go with the flow to positive direction
		return posdir

/obj/structure/disposalpipe/sortjunction/transfer(obj/structure/disposalholder/H)
	var/nextdir = nextdir(H.dir, H.destinationTag)
	H.set_dir(nextdir)
	var/turf/T = H.nextloc()
	var/obj/structure/disposalpipe/P = H.findpipe(T)

	if(P)
		// find other holder in next loc, if inactive merge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null

	return P

//a three-way junction that filters all wrapped and tagged items
/obj/structure/disposalpipe/sortjunction/wildcard
	name = "wildcard sorting junction"
	desc = "An underfloor disposal pipe which filters all wrapped and tagged items."
	subtype = 1
	divert_check(var/checkTag)
		return checkTag != ""

//junction that filters all untagged items
/obj/structure/disposalpipe/sortjunction/untagged
	name = "untagged sorting junction"
	desc = "An underfloor disposal pipe which filters all untagged items."
	subtype = 2
	divert_check(var/checkTag)
		return checkTag == ""

/obj/structure/disposalpipe/sortjunction/flipped //for easier and cleaner mapping
	icon_state = "pipe-j2s"

/obj/structure/disposalpipe/sortjunction/wildcard/flipped
	icon_state = "pipe-j2s"

/obj/structure/disposalpipe/sortjunction/untagged/flipped
	icon_state = "pipe-j2s"

//a trunk joining to a disposal bin or outlet on the same turf
/obj/structure/disposalpipe/trunk
	icon_state = "pipe-t"
	var/obj/linked 	// the linked obj/machinery/disposal or obj/disposaloutlet

/obj/structure/disposalpipe/trunk/New()
	. = ..()
	pipe_dir = dir
	spawn(1)
		getlinked()

	update()

/obj/structure/disposalpipe/trunk/Destroy()
	// Unlink trunk and disposal so that objets are not sent to nullspace
	var/obj/machinery/disposal/D = linked
	if (istype(D))
		D.trunk = null
	linked = null
	. = ..()

/obj/structure/disposalpipe/trunk/proc/getlinked()
	linked = null
	var/obj/machinery/disposal/D = locate() in loc
	if(D)
		linked = D
		if (!D.trunk)
			D.trunk = src

	var/obj/structure/disposaloutlet/O = locate() in loc
	if(O)
		linked = O

	update()

// Override attackby so we disallow trunkremoval when somethings ontop
/obj/structure/disposalpipe/trunk/attackby(obj/item/I, mob/user)
	//Disposal bins or chutes
	/*
	These shouldn't be required
	var/obj/machinery/disposal/D = locate() in loc
	if(D && D.anchored)
		return
	//Disposal outlet
	var/obj/structure/disposaloutlet/O = locate() in loc
	if(O && O.anchored)
		return
	*/

	//Disposal constructors
	var/obj/structure/disposalconstruct/C = locate() in loc
	if(C && C.anchored)
		return

	var/turf/T = loc
	if(!T.is_plating())
		return		// prevent interaction with T-scanner revealed pipes
	add_fingerprint(user)

	if(QUALITY_WELDING in I.tool_qualities)
		if(I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_WELDING, FAILCHANCE_EASY, required_stat = STAT_MEC))
			welded()
		return

	// would transfer to next pipe segment, but we are in a trunk
	// if not entering from disposal bin,
	// transfer to linked object (outlet or bin)

/obj/structure/disposalpipe/trunk/transfer(obj/structure/disposalholder/H)
	if(H.dir == DOWN)		// we just entered from a disposer
		return ..()		// so do base transfer proc
	// otherwise, go to the linked object
	if(linked)
		var/obj/structure/disposaloutlet/O = linked
		if(istype(O) && (H))
			O.expel(H)	// expel at outlet
		else
			var/obj/machinery/disposal/D = linked
			if(H)
				D.expel(H)	// expel at disposal
	else
		if(H)
			expel(H, loc, 0)	// expel at turf
	return null

/obj/structure/disposalpipe/trunk/nextdir(fromdir)
	if(fromdir == DOWN)
		return dir
	else
		return 0

// a broken pipe
/obj/structure/disposalpipe/broken
	icon_state = "pipe-b"
	pipe_dir = 0		// broken pipes have pipe_dir=0 so they're not found as 'real' pipes
					// i.e. will be treated as an empty turf
	desc = "A broken piece of disposal pipe."

/obj/structure/disposalpipe/broken/New()
	. = ..()
	update()

// called when welded
// for broken pipe, remove and turn into scrap
/obj/structure/disposalpipe/broken/welded()
//	var/obj/item/scrap/S = new(loc)
//	S.set_components(200,0,0)
	qdel(src)

// the disposal outlet machine

/obj/structure/disposaloutlet
	name = "disposal outlet"
	desc = "An outlet for the pneumatic disposal system."
	icon = 'icons/obj/pipes/disposal.dmi'
	icon_state = "outlet"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER //So we can see things that are being ejected
	var/active = 0
	var/turf/target	// this will be where the output objects are 'thrown' to.
	var/mode = DISPOSALS_OFF

/obj/structure/disposaloutlet/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/disposaloutlet/LateInitialize(mapload)
	target = get_ranged_target_turf(src, dir, 10)

	var/obj/structure/disposalpipe/trunk/trunk = locate() in loc
	if(trunk)
		trunk.linked = src	// link the pipe trunk to self

// expel the contents of the holder object, then delete it
// called when the holder exits the outlet
/obj/structure/disposaloutlet/proc/expel(obj/structure/disposalholder/H)
	flick("outlet-open", src)
	playsound(src, 'sound/machines/warning-buzzer.ogg', 50, 0, 0)
	sleep(20)	//wait until correct animation frame
	playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)

	if(H)
		for(var/atom/movable/AM in H)
			AM.forceMove(loc)
			AM.pipe_eject(dir)
			if(!isdrone(AM)) //Drones keep smashing windows from being fired out of chutes. Bad for the station. ~Z
				spawn(5)
					AM.throw_at(target, 3, 1)
		qdel(H)


/obj/structure/disposaloutlet/attackby(obj/item/I, mob/user)
	if(!I || !user)
		return
	add_fingerprint(user)

	var/list/usable_qualities = list()
	if(mode <= 0)
		usable_qualities.Add(QUALITY_SCREW_DRIVING)
	if(mode == -1)
		usable_qualities.Add(QUALITY_WELDING)

	var/tool_type = I.get_tool_type(user, usable_qualities, src)
	switch(tool_type)
		if(QUALITY_SCREW_DRIVING)
			if(mode <= 0)
				var/used_sound = mode ? 'sound/machines/Custom_screwdriverclose.ogg' : 'sound/machines/Custom_screwdriveropen.ogg'
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC, instant_finish_tier = 30, forced_sound = used_sound))
					if(mode == 0) // It's off but still not unscrewed
						mode = -1 // Set it to doubleoff l0l
						to_chat(user, "You remove the screws around the power connection.")
					else if(mode == -1)
						mode = 0
						to_chat(user, "You attach the screws around the power connection.")
			return

		if(QUALITY_WELDING)
			if(mode == -1)
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
					to_chat(user, "You sliced the floorweld off the disposal outlet.")
					var/obj/structure/disposalconstruct/C = new(loc)
					transfer_fingerprints_to(C)
					C.pipe_type = PIPE_TYPE_OUTLET
					C.anchored = TRUE
					C.density = TRUE
					C.update()
					qdel(src)
			return

		if(ABORT_CHECK)
			return

// called when movable is expelled from a disposal pipe or outlet
// by default does nothing, override for special behaviour
/atom/movable/proc/pipe_eject(direction)
	return

// check if mob has client, if so restore client view on eject
/mob/pipe_eject(direction)
	reset_view()

/obj/effect/decal/cleanable/blood/gibs/pipe_eject(direction)
	var/list/dirs
	if(direction)
		dirs = list(direction, turn(direction, -45), turn(direction, 45))
	else
		dirs = alldirs.Copy()

	streak(dirs)

/obj/effect/decal/cleanable/blood/gibs/robot/pipe_eject(direction)
	var/list/dirs
	if(direction)
		dirs = list(direction, turn(direction, -45), turn(direction, 45))
	else
		dirs = alldirs.Copy()

	streak(dirs)
