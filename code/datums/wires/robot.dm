/datum/wires/robot
	holder_type = /mob/living/silicon/robot
	wire_count = 5
	descriptions = list(
		new /datum/wire_description(BORG_WIRE_LAWCHECK, "LawSync"),
		new /datum/wire_description(BORG_WIRE_MAIN_POWER, "Power",),
		new /datum/wire_description(BORG_WIRE_LOCKED_DOWN, "Failsafe"),
		new /datum/wire_description(BORG_WIRE_AI_CONTROL, "Remote access"),
		new /datum/wire_description(BORG_WIRE_CAMERA,  "Camera")
	)

var/const/BORG_WIRE_LAWCHECK = 1
var/const/BORG_WIRE_MAIN_POWER = 2 // The power wires do nothing whyyyyyyyyyyyyy
var/const/BORG_WIRE_LOCKED_DOWN = 4
var/const/BORG_WIRE_AI_CONTROL = 8
var/const/BORG_WIRE_CAMERA = 16

/datum/wires/robot/get_status(mob/living/user)
	var/mob/living/silicon/robot/R = holder
	. = ..()
	. += "The LawSync light is [R.lawupdate ? "on" : "off"]."
	. += "The AI link light is [R.connected_ai ? "on" : "off"]."
	. += "The Camera light is [(R.camera && R.camera.status == 1) ? "on" : "off"]."
	. += "The lockdown light is [R.lockcharge ? "on" : "off"]."

/datum/wires/robot/UpdateCut(var/index, var/mended)

	var/mob/living/silicon/robot/R = holder
	switch(index)
		if(BORG_WIRE_LAWCHECK) //Cut the law wire, and the borg will no longer receive law updates from its AI
			if(!mended)
				if (R.lawupdate == 1)
					to_chat(R, "LawSync protocol engaged.")
					R.show_laws()
			else
				if (R.lawupdate == 0 && !R.HasTrait(CYBORG_TRAIT_EMAGGED))
					R.lawupdate = 1

		if (BORG_WIRE_AI_CONTROL) //Cut the AI wire to reset AI control
			if(!mended)
				R.disconnect_from_ai()

		if (BORG_WIRE_CAMERA)
			if(!isnull(R.camera) && !R.scrambledcodes)
				R.camera.status = mended

		if(BORG_WIRE_LAWCHECK)	//Forces a law update if the borg is set to receive them. Since an update would happen when the borg checks its laws anyway, not much use, but eh
			if (R.lawupdate)
				R.lawsync()

		if(BORG_WIRE_LOCKED_DOWN)
			R.SetLockdown(!mended)


/datum/wires/robot/UpdatePulsed(var/index)
	var/mob/living/silicon/robot/R = holder
	switch(index)
		if (BORG_WIRE_AI_CONTROL) //pulse the AI wire to make the borg reselect an AI
			if(!R.HasTrait(CYBORG_TRAIT_EMAGGED))
				var/mob/living/silicon/ai/new_ai = select_active_ai(R)
				R.connect_to_ai(new_ai)

		if (BORG_WIRE_CAMERA)
			if(!isnull(R.camera) && R.camera.can_use() && !R.scrambledcodes)
				R.visible_message("[R]'s camera lense focuses loudly.")
				to_chat(R, "Your camera lense focuses loudly.")

		if(BORG_WIRE_LOCKED_DOWN)
			R.SetLockdown(!R.lockcharge) // Toggle

/datum/wires/robot/CanUse(var/mob/living/L)
	var/mob/living/silicon/robot/R = holder
	if(R.wiresexposed)
		return 1
	return 0

/datum/wires/robot/proc/IsCameraCut()
	return wires_status & BORG_WIRE_CAMERA

/datum/wires/robot/proc/LockedCut()
	return wires_status & BORG_WIRE_LOCKED_DOWN
