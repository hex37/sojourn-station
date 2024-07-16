/obj/item/storage/sheath
	name = "absolutism sheath"
	desc = "Made to store only the swords of the church."
	icon = 'icons/obj/sheath.dmi'

	icon_state = "sheath_0"
	item_state = "sheath_0"
	var/base_icon_state = "sheath"
	var/base_item_state = "sheath"

	slot_flags = SLOT_BELT
	price_tag = 50
	matter = list(MATERIAL_BIOMATTER = 5)
	storage_slots = 1
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_HUGE

	can_hold = list(
		/obj/item/tool/sword/nt,
		/obj/item/tool/sword/saber
		)
	cant_hold = list(
		/obj/item/tool/knife/dagger/nt,
		/obj/item/tool/spear/halberd
		)
	insertion_sound = 'sound/effects/sheathin.ogg'
	extraction_sound = 'sound/effects/sheathout.ogg'

/obj/item/storage/sheath/attack_hand(mob/living/carbon/human/user)
	if(contents.len && (src in user))
		var/obj/item/I = contents[contents.len]
		if(istype(I))
			hide_from(usr)
			var/turf/T = get_turf(user)
			remove_from_storage(I, T)
			usr.put_in_hands(I)
			add_fingerprint(user)
	else
		..()

/obj/item/storage/sheath/Initialize(mapload, ...)
	. = ..()
	update_icon()

/obj/item/storage/sheath/update_icon()
	var/icon_to_set
	for(var/obj/item/SW in contents)
		icon_to_set = SW.icon_state
	icon_state = "[base_icon_state]_[contents.len ? icon_to_set : "0"]"
	item_state = "[base_item_state]_[contents.len ? icon_to_set : "0"]"
	..()

/obj/item/storage/sheath/non_church
	name = "sheath_0"
	desc = "Made to store swords."

/obj/item/storage/sheath/non_church/general
	name = "sword sheath"
	desc = "A leathery-like sheath made to store blades."
	base_icon_state = "general_sheath"
	base_item_state = "general_sheath"

	can_hold = list(
		/obj/item/tool/cheap
	)
	cant_hold = list(
		/obj/item/tool/cheap/spear
	)
