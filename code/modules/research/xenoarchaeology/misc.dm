
//---- Noticeboard

/obj/structure/noticeboard/anomaly
	notices = 5
	icon_state = "nboard05"

/obj/structure/noticeboard/anomaly/New()
	//add some memos
	var/obj/item/paper/P = new()
	P.name = "Memo RE: proper analysis procedure"
	P.info = "<br>We keep test dummies in pens here for a reason, so standard procedure should be to activate newfound alien artifacts and place the two in close proximity. Promising items I might even approve monkey testing on."
	P.add_overlay(list("paper_stamped_rd"), TRUE)
	P.stamped &= STAMP_DOCUMENT
	src.contents += P

	P = new()
	P.name = "Memo RE: materials gathering"
	P.info = "Corasang,<br>the hands-on approach to gathering our samples may very well be slow at times, but it's safer than allowing the blundering miners to roll willy-nilly over our dig sites in their mechs, destroying everything in the process. And don't forget the escavation tools on your way out there!<br>- R.W"
	P.add_overlay(list("paper_stamped_rd"), TRUE)
	P.stamped &= STAMP_DOCUMENT
	src.contents += P

	P = new()
	P.name = "Memo RE: ethical quandaries"
	P.info = "Darion-<br><br>I don't care what his rank is, our business is that of science and knowledge - questions of moral application do not come into this. Sure, so there are those who would employ the energy-wave particles my modified device has managed to abscond for their own personal gain, but I can hardly see the practical benefits of some of these artifacts our benefactors left behind. Ward--"
	P.add_overlay(list("paper_stamped_rd"), TRUE)
	P.stamped &= STAMP_DOCUMENT
	src.contents += P

	P = new()
	P.name = "READ ME! Before you people destroy any more samples"
	P.info = "how many times do i have to tell you people, these xeno-arch samples are del-i-cate, and should be handled so! careful application of a focussed, concentrated heat or some corrosive liquids should clear away the extraneous carbon matter, while application of an energy beam will most decidedly destroy it entirely - like someone did to the chemical dispenser! W, <b>the one who signs your paychecks</b>"
	P.add_overlay(list("paper_stamped_rd"), TRUE)
	P.stamped &= STAMP_DOCUMENT
	src.contents += P

	P = new()
	P.name = "Reminder regarding the anomalous material suits"
	P.info = "Do you people think the anomaly suits are cheap to come by? I'm about a hair trigger away from instituting a log book for the damn things. Only wear them if you're going out for a dig, and for god's sake don't go tramping around in them unless you're field testing something, R"
	P.add_overlay(list("paper_stamped_rd"), TRUE)
	P.stamped &= STAMP_DOCUMENT
	src.contents += P

//---- Bookcase

/obj/structure/bookcase/manuals/xenoarchaeology
	name = "Xenoarchaeology Manuals bookcase"

	New()
		..()
		new /obj/item/book/manual/excavation(src)
		new /obj/item/book/manual/mass_spectrometry(src)
		new /obj/item/book/manual/materials_chemistry_analysis(src)
		new /obj/item/book/manual/anomaly_testing(src)
		new /obj/item/book/manual/anomaly_spectroscopy(src)
		new /obj/item/book/manual/stasis(src)
		update_icon()

//---- Lockers and closets

/obj/structure/closet/secure_closet/xenoarchaeologist
	name = "Xenoarchaeologist Locker"
	req_access = list(access_tox_storage)
	icon_state = "science"

	New()
		..()
		sleep(2)
		new /obj/item/clothing/under/rank/scientist(src)
		new /obj/item/clothing/suit/storage/membrane(src) //SCIENCE!!!
		new /obj/item/clothing/shoes/color(src)
		new /obj/item/clothing/glasses/powered/science(src)
		new /obj/item/device/radio/headset/headset_sci(src)
		new /obj/item/storage/belt/archaeology(src)
		new /obj/item/tool/pickaxe/excavation(src)
		new /obj/item/storage/backpack/duffelbag(src)
		new /obj/item/gun/projectile/boltgun/flare_gun(src)
		new /obj/item/ammo_casing/flare/prespawn(src)
		return

/obj/structure/closet/excavation
	name = "Excavation tools"
	icon_state = "eng"
	icon_door = "eng_tool"


	New()
		..()
		sleep(2)
		new /obj/item/storage/belt/archaeology(src)
		new /obj/item/device/lighting/toggleable/lantern(src)
		new /obj/item/device/ano_scanner(src)
		new /obj/item/device/depth_scanner(src)
		new /obj/item/device/core_sampler(src)
		new /obj/item/device/gps(src)
		new /obj/item/device/beacon_locator(src)
		new /obj/item/clothing/glasses/powered/meson(src)
		new /obj/item/tool/pickaxe(src)
		new /obj/item/device/measuring_tape(src)
		new /obj/item/tool/pickaxe/excavation(src)
		new /obj/item/storage/bag/fossils(src)
		new /obj/item/hand_labeler(src)
		new /obj/item/taperoll/research(src)
		new /obj/item/book/manual/excavation(src)
		return

//---- Isolation room air alarms

/obj/machinery/alarm/isolation
	req_one_access = list(access_moebius, access_atmospherics, access_engine_equip)

/obj/machinery/alarm/monitor/isolation
	req_one_access = list(access_moebius, access_atmospherics, access_engine_equip)
