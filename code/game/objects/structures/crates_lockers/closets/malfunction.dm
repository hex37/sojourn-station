/obj/structure/closet/malf/suits
	desc = "It's a storage unit for operational gear."
	icon_state = "syndicate"

/obj/structure/closet/malf/suits/populate_contents()
	if(populated_contents)
		return
	populated_contents = TRUE
	new /obj/item/tank/jetpack/void(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/clothing/suit/space/void(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/cell/large(src)
	new /obj/item/tool/multitool(src)
