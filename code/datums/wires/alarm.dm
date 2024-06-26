/datum/wires/alarm
	holder_type = /obj/machinery/alarm
	wire_count = 5
	descriptions = list(
		new /datum/wire_description(AALARM_WIRE_IDSCAN, "ID scanner"),
		new /datum/wire_description(AALARM_WIRE_POWER, "Main power"),
		new /datum/wire_description(AALARM_WIRE_SYPHON, "Panic mode"),
		new /datum/wire_description(AALARM_WIRE_AI_CONTROL, "Remote access"),
		new /datum/wire_description(AALARM_WIRE_AALARM, "Alarm trigger")
	)

var/const/AALARM_WIRE_IDSCAN = 1
var/const/AALARM_WIRE_POWER = 2
var/const/AALARM_WIRE_SYPHON = 4
var/const/AALARM_WIRE_AI_CONTROL = 8
var/const/AALARM_WIRE_AALARM = 16


/datum/wires/alarm/CanUse(var/mob/living/L)
	var/obj/machinery/alarm/A = holder
	if(A.wiresexposed && A.buildstage == 2)
		return 1
	return 0

/datum/wires/alarm/get_status(mob/living/user)
	var/obj/machinery/alarm/A = holder
	. = ..()
	. += "The Air Alarm is [A.locked ? "locked." : "unlocked."]"
	. += "The Air Alarm is [(A.shorted || (A.stat & (NOPOWER|BROKEN))) ? "offline." : "working properly!"]"
	. += "The 'AI control allowed' light is [A.aidisabled ? "off" : "on"]."

/datum/wires/alarm/UpdateCut(var/index, var/mended)
	var/obj/machinery/alarm/A = holder
	switch(index)
		if(AALARM_WIRE_IDSCAN)
			if(!mended)
				A.locked = 1
				//world << "Idscan wire cut"

		if(AALARM_WIRE_POWER)
			A.shock(usr, 50)
			A.shorted = !mended
			A.update_icon()
			//world << "Power wire cut"

		if (AALARM_WIRE_AI_CONTROL)
			if (A.aidisabled == !mended)
				A.aidisabled = mended
				//world << "AI Control Wire Cut"

		if(AALARM_WIRE_SYPHON)
			if(!mended)
				A.mode = 3 // AALARM_MODE_PANIC
				A.apply_mode()
				//world << "Syphon Wire Cut"

		if(AALARM_WIRE_AALARM)
			if (A.alarm_area.atmosalert(2, A))
				A.post_alert(2)
			A.update_icon()

/datum/wires/alarm/UpdatePulsed(var/index)
	var/obj/machinery/alarm/A = holder
	switch(index)
		if(AALARM_WIRE_IDSCAN)
			A.locked = !A.locked
		//	world << "Idscan wire pulsed"

		if (AALARM_WIRE_POWER)
		//	world << "Power wire pulsed"
			if(A.shorted == 0)
				A.shorted = 1
				A.update_icon()

			spawn(12000)
				if(A.shorted == 1)
					A.shorted = 0
					A.update_icon()


		if (AALARM_WIRE_AI_CONTROL)
		//	world << "AI Control wire pulsed"
			if (A.aidisabled == 0)
				A.aidisabled = 1
			A.updateDialog()
			spawn(100)
				if (A.aidisabled == 1)
					A.aidisabled = 0

		if(AALARM_WIRE_SYPHON)
		//	world << "Syphon wire pulsed"
			if(A.mode == 1) // AALARM_MODE_SCRUB
				A.mode = 3 // AALARM_MODE_PANIC
			else
				A.mode = 1 // AALARM_MODE_SCRUB
			A.apply_mode()

		if(AALARM_WIRE_AALARM)
		//	world << "Aalarm wire pulsed"
			if (A.alarm_area.atmosalert(0, A))
				A.post_alert(0)
			A.update_icon()
