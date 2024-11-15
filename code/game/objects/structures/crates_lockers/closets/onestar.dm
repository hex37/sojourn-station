//Closets full of loot, they should be placed in derelicts

//// Loot table on all tiers
// Tier 1
/obj/structure/closet/onestar/populate_contents()
	populated_contents = TRUE

/obj/structure/closet/onestar/proc/dont_spawn_items()
	if(populated_contents)
		return TRUE
	return FALSE

/obj/structure/closet/onestar/tier1
	name = "\improper Greyson forgotten closet"
	desc = "It's an old Greyson closet. Doesn't seem like it contains anything worthwhile. Probably."
	icon_state = "lootcloset"

/obj/structure/closet/onestar/tier1/populate_contents()
	if(dont_spawn_items())
		return
	new /obj/random/contraband/low_chance(src)
	new /obj/random/contraband/low_chance(src)
	new /obj/random/pack/rare/low_chance(src)
	new /obj/random/pack/tech_loot/onestar(src)
	new /obj/random/pack/tech_loot/onestar(src)
	new /obj/random/junk(src)
	new /obj/random/lowkeyrandom(src)
	new /obj/random/lowkeyrandom(src)
	new /obj/random/lowkeyrandom/low_chance(src)
	new /obj/random/lowkeyrandom/low_chance(src)
	new /obj/random/pack/tech_loot/low_chance(src)
	new /obj/random/pack/cloth/low_chance(src)
	new /obj/random/pack/cloth/low_chance(src)
	new /obj/random/pack/gun_loot/low_chance(src)
	new /obj/random/cloth/greyson_clothing/low_chance(src)
	new /obj/random/gun_parts/low(src)
	new /obj/random/gun_parts/low(src)
	if(prob(40))
		new /obj/random/gun_parts/frames(src)
	..()

// Tier 2
/obj/structure/closet/onestar/tier2
	name = "\improper Greyson forgotten closet"
	desc = "It's an old Greyson closet. Looks like there might be some decent stuff inside."
	icon_state = "lootcloset1"

/obj/structure/closet/onestar/tier2/populate_contents()
	if(dont_spawn_items())
		return
	new /obj/random/contraband/low_chance(src)
	new /obj/random/contraband/low_chance(src)
	new /obj/random/pack/rare/low_chance(src)
	new /obj/random/pack/tech_loot/onestar(src)
	new /obj/random/pack/tech_loot/onestar(src)
	new /obj/random/pack/tech_loot/onestar(src)
	new /obj/random/tool/advanced/onestar/low_chance(src)
	new /obj/random/lowkeyrandom(src)
	new /obj/random/lowkeyrandom/low_chance(src)
	new /obj/random/lowkeyrandom/low_chance(src)
	new /obj/random/pack/tech_loot/low_chance(src)
	new /obj/random/pack/cloth/low_chance(src)
	new /obj/random/pack/cloth/low_chance(src)
	new /obj/random/pack/gun_loot/low_chance(src)
	new /obj/random/gun_parts/low(src)
	new /obj/random/gun_parts/low(src)
	new /obj/random/gun_parts/low(src)
	if(prob(80))
		new /obj/random/gun_parts/frames(src)
		new /obj/random/gun_parts/frames(src)
	..()


// Tier 3
/obj/structure/closet/onestar/tier3
	name = "\improper Greyson forgotten closet"
	desc = "It's an old Greyson closet. Might contain something very valuable, or so you hope."
	icon_state = "lootcloset2"

/obj/structure/closet/onestar/tier3/populate_contents()
	if(dont_spawn_items())
		return
	new /obj/random/contraband/low_chance(src)
	new /obj/random/contraband/low_chance(src)
	new /obj/random/pack/rare/low_chance(src)
	new /obj/random/pack/tech_loot/onestar(src)
	new /obj/random/pack/tech_loot/onestar(src)
	new /obj/random/junk(src)
	new /obj/random/pack/tech_loot/onestar(src)
	new /obj/random/tool/advanced/onestar(src)
	new /obj/random/lowkeyrandom(src)
	new /obj/random/lowkeyrandom/low_chance(src)
	new /obj/random/lowkeyrandom/low_chance(src)
	new /obj/random/pack/tech_loot/low_chance(src)
	new /obj/random/pack/cloth/low_chance(src)
	new /obj/random/pack/cloth/low_chance(src)
	new /obj/random/pack/gun_loot/low_chance(src)
	new /obj/random/tool/advanced/onestar/low_chance(src)
	new /obj/random/cloth/greyson_clothing/low_chance(src)
	new /obj/random/lathe_disk/advanced/onestar/low_chance(src)
	new /obj/random/gun_parts/low(src)
	new /obj/random/gun_parts/low(src)
	new /obj/random/gun_parts/low(src)
	new /obj/random/gun_parts/low(src)
	new /obj/random/gun_parts/frames(src)
	new /obj/random/gun_parts/frames(src)
	if(prob(80))
		new /obj/random/gun_parts/frames(src)
		new /obj/random/gun_parts/frames(src)
	..()

////// Closets

////Normal
//Tier 1
/obj/structure/closet/onestar/tier1/normal
	name = "\improper Greyson forgotten closet"
	icon_state = "lootcloset"
	old_chance = 70

// Empty
/obj/structure/closet/onestar/tier1/normal/empty
/obj/structure/closet/onestar/tier1/normal/empty/populate_contents()
	return

//Tier 2
/obj/structure/closet/onestar/tier2/normal
	name = "\improper Greyson forgotten closet"
	icon_state = "lootcloset1"
	old_chance = 30

// Empty
/obj/structure/closet/onestar/tier2/normal/empty
/obj/structure/closet/onestar/tier2/normal/empty/populate_contents()
	return

//Tier 3
/obj/structure/closet/onestar/tier3/normal
	name = "\improper Greyson forgotten closet"
	icon_state = "lootcloset2"
	old_chance = 10

// Empty
/obj/structure/closet/onestar/tier3/normal/empty
/obj/structure/closet/onestar/tier3/normal/empty/populate_contents()
	return


////Special
//Tier 1
/obj/structure/closet/onestar/tier1/special
	name = "\improper Greyson forgotten closet"
	icon_state = "special_lootcloset"
	old_chance = 70

/obj/structure/closet/onestar/tier1/special/populate_contents()
	if(dont_spawn_items())
		return
	new /obj/random/pack/rare/low_chance(src)
	new /obj/random/pack/rare/low_chance(src)
	new /obj/random/cloth/greyson_clothing/low_chance(src)
	new /obj/random/cloth/greyson_clothing/low_chance(src)
	new /obj/random/gun_parts/low(src)
	..()


// Empty
/obj/structure/closet/onestar/tier1/special/empty
/obj/structure/closet/onestar/tier1/special/empty/populate_contents()
	return

//Tier 2
/obj/structure/closet/onestar/tier2/special
	name = "\improper Greyson forgotten closet"
	icon_state = "special_lootcloset1"
	old_chance = 30

/obj/structure/closet/onestar/tier2/special/populate_contents()
	if(dont_spawn_items())
		return
	new /obj/random/pack/rare/low_chance(src)
	new /obj/random/pack/rare/low_chance(src)
	new /obj/random/cloth/greyson_clothing/low_chance(src)
	new /obj/random/cloth/greyson_clothing/low_chance(src)
	new /obj/random/gun_parts/low(src)
	new /obj/random/gun_parts/frames(src)
	..()


// Empty
/obj/structure/closet/onestar/tier2/special/empty
/obj/structure/closet/onestar/tier2/special/empty/populate_contents()
	return

//Tier 3
/obj/structure/closet/onestar/tier3/special
	name = "\improper Greyson forgotten closet"
	icon_state = "special_lootcloset2"
	old_chance = 10

/obj/structure/closet/onestar/tier3/special/populate_contents()
	if(dont_spawn_items())
		return
	new /obj/random/pack/rare/low_chance(src)
	new /obj/random/pack/rare/low_chance(src)
	new /obj/random/cloth/greyson_clothing/low_chance(src)
	new /obj/random/cloth/greyson_clothing/low_chance(src)
	new /obj/random/gun_parts/low(src)
	new /obj/random/gun_parts/frames(src)
	new /obj/random/gun_parts/frames(src)
	..()

// Empty
/obj/structure/closet/onestar/tier3/special/empty
/obj/structure/closet/onestar/tier3/special/empty/populate_contents()
	return

////Mineral
//Tier 1
/obj/structure/closet/onestar/tier1/mineral
	name = "\improper Greyson forgotten closet"
	icon_state = "mineral_lootcloset"
	old_chance = 70

/obj/structure/closet/onestar/tier1/mineral/populate_contents()
	if(dont_spawn_items())
		return
	new /obj/random/pack/tech_loot/low_chance(src)
	new /obj/random/pack/tech_loot/low_chance(src)
	new /obj/random/cloth/greyson_clothing/low_chance(src)
	new /obj/random/gun_parts/low(src)
	new /obj/random/gun_parts/frames(src)
	new /obj/random/gun_parts/frames(src)
	..()
// Empty
/obj/structure/closet/onestar/tier1/mineral/empty
/obj/structure/closet/onestar/tier1/mineral/empty/populate_contents()
	return

//Tier 2
/obj/structure/closet/onestar/tier2/mineral
	name = "\improper Greyson forgotten closet"
	icon_state = "mineral_lootcloset1"
	old_chance = 30

/obj/structure/closet/onestar/tier2/mineral/populate_contents()
	if(dont_spawn_items())
		return
	new /obj/random/pack/tech_loot/low_chance(src)
	new /obj/random/pack/tech_loot/low_chance(src)
	new /obj/random/cloth/greyson_clothing/low_chance(src)
	new /obj/random/gun_parts/low(src)
	new /obj/random/gun_parts/frames(src)
	new /obj/random/gun_parts/frames(src)
	..()
// Empty
/obj/structure/closet/onestar/tier2/mineral/empty
/obj/structure/closet/onestar/tier2/mineral/empty/populate_contents()
	return

//Tier 3
/obj/structure/closet/onestar/tier3/mineral
	name = "\improper Greyson forgotten closet"
	icon_state = "mineral_lootcloset2"
	old_chance = 10

/obj/structure/closet/onestar/tier3/mineral/populate_contents()
	if(dont_spawn_items())
		return
	new /obj/random/pack/tech_loot/low_chance(src)
	new /obj/random/pack/tech_loot/low_chance(src)
	new /obj/random/cloth/greyson_clothing/low_chance(src)
	new /obj/random/gun_parts/low(src)
	new /obj/random/gun_parts/frames(src)
	new /obj/random/gun_parts/frames(src)
	..()
// Empty
/obj/structure/closet/onestar/tier3/mineral/empty
/obj/structure/closet/onestar/tier3/mineral/empty/populate_contents()
	return

////Medical
//Tier 1
/obj/structure/closet/onestar/tier1/medical
	name = "\improper Greyson forgotten closet"
	icon_state = "medical_lootcloset"
	old_chance = 70

/obj/structure/closet/onestar/tier1/medical/populate_contents()
	if(dont_spawn_items())
		return
	new /obj/random/lowkeyrandom(src)
	new /obj/random/lowkeyrandom(src)
	new /obj/random/cloth/greyson_clothing/low_chance(src)
	new /obj/random/gun_parts/low(src)
	new /obj/random/gun_parts/frames(src)
	new /obj/random/gun_parts/frames(src)
	..()
// Empty
/obj/structure/closet/onestar/tier1/medical/empty
/obj/structure/closet/onestar/tier1/medical/empty/populate_contents()
	return

//Tier 2
/obj/structure/closet/onestar/tier2/medical
	name = "\improper Greyson forgotten closet"
	icon_state = "medical_lootcloset1"
	old_chance = 30

/obj/structure/closet/onestar/tier2/medical/populate_contents()
	if(dont_spawn_items())
		return
	new /obj/random/lowkeyrandom(src)
	new /obj/random/lowkeyrandom(src)
	new /obj/random/cloth/greyson_clothing/low_chance(src)
	new /obj/random/gun_parts/low(src)
	..()
// Empty
/obj/structure/closet/onestar/tier2/medical/empty
/obj/structure/closet/onestar/tier2/medical/empty/populate_contents()
	return

//Tier 3
/obj/structure/closet/onestar/tier3/medical
	name = "\improper Greyson forgotten closet"
	icon_state = "medical_lootcloset2"
	old_chance = 10

/obj/structure/closet/onestar/tier3/medical/populate_contents()
	if(dont_spawn_items())
		return
	new /obj/random/lowkeyrandom(src)
	new /obj/random/lowkeyrandom(src)
	new /obj/random/cloth/greyson_clothing/low_chance(src)
	new /obj/random/gun_parts/low(src)
	new /obj/random/gun_parts/frames(src)
	..()
// Empty
/obj/structure/closet/onestar/tier3/medical/empty
/obj/structure/closet/onestar/tier3/medical/empty/populate_contents()
	return