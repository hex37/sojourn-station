/obj/item/reagent_containers/food/snacks/meat
	name = "meat"
	desc = "A slab of meat cut from a nondescript animal. The core ingredient in thousands upon thousands of food recipes, in one way or another."
	icon_state = "meat"
	taste_tag = list(MEAT_FOOD)
	health = 180
	filling_color = "#FF1C1C"
	center_of_mass = list("x"=16, "y"=14)
	bitesize = 3
	matter = list(MATERIAL_BIOMATTER = 10)
	preloaded_reagents = list("protein" = 9)
	slice_path = /obj/item/reagent_containers/food/snacks/rawcutlet
	slices_num = 3
	var/inherent_mutations = list() //Holder for genetics, created for the meat on spawn.
	var/datum/genetics/genetics_holder/unnatural_mutations = new() //GMO in your MEAT
	var/source_mob
	var/source_name
	price_tag = 20 //Partially to make it not dirt-cheap to buy from the beacon. Plus it's useful as biomatter, so it's worth something.

//For initializing genetics information for meat, so it's easy to call.
/obj/item/reagent_containers/food/snacks/meat/proc/initialize_genetics(mob/living/meat_source)
	if(meat_source)	//EQUINOX EDIT: basic sanity check to prevent runtimes
		if(meat_source.inherent_mutations)	//EQUINOX EDIT: more sanity checks to prevent runtimes
			inherent_mutations = meat_source.inherent_mutations.Copy()
		if(meat_source.unnatural_mutations)	//EQUINOX EDIT: more sanity checks to prevent runtimes
			unnatural_mutations = meat_source.unnatural_mutations.Copy()
		source_mob = meat_source.type	// these don't need sanity checks since these are inherent vars that won't be null as long as meat_source exists (ergo, handled in first check already)
		source_name = meat_source.name

/obj/item/reagent_containers/food/snacks/meat/syntiflesh
	name = "synthetic meat"
	desc = "A synthetic slab of flesh."

// Seperate definitions because some food likes to know if it's human.
// TODO: rewrite kitchen code to check a var on the meat item so we can remove
// all these sybtypes.
/obj/item/reagent_containers/food/snacks/meat/human
/obj/item/reagent_containers/food/snacks/meat/monkey
	//same as plain meat

/obj/item/reagent_containers/food/snacks/meat/pork
	name = "porcine meat"
	desc = "A raw slab of meat from pig or otherwise porcine animal."
	icon_state = "sus" // It's the name of genus of the pig, don't give me that look.
	preloaded_reagents = list("protein" = 8)
	filling_color = "#C28585"
	slice_path = /obj/item/reagent_containers/food/snacks/rawbacon
	slices_num = 4 // Since 2u protein each

/obj/item/reagent_containers/food/snacks/meat/corgi
	name = "Corgi meat"
	desc = "A raw slab of meat from a corgi."

/obj/item/reagent_containers/food/snacks/meat/termitemeat
	desc = "A slab of sickly-green bubbling meat cut from a giant termite. Rich in minerals."
	icon_state = "xenomeat"
	filling_color = "#E2FFDE"
	preloaded_reagents = list("protein" = 5, "hclacid" = 4, "sacid" = 4, "phosphorus" = 8)
	//Todo make each termite meat have their ground up mineral inside
	// IDK if anyone is ever going to do this, so, adding some of the otherwise unobtainable ghetto chems to it - obey

/obj/item/reagent_containers/food/snacks/meat/roachmeat
	desc = "A slab of sickly-green bubbling meat cut from a giant roach."
	icon_state = "xenomeat"
	filling_color = "#E2FFDE"

	bitesize = 6
	preloaded_reagents = list("protein" = 4, "blattedin" = 8, "diplopterum" = 7)

/obj/item/reagent_containers/food/snacks/meat/roachmeat/seuche
	preloaded_reagents = list("protein" = 2, "blattedin"= 12, "seligitillin" = 8, "diplopterum" = 6)
	// The roach that produces giant clouds of blattedin doesn't contain any blattedin in it's system? Tweaked. To compensate, making Jagers give even less blatt

/obj/item/reagent_containers/food/snacks/meat/roachmeat/panzer
	preloaded_reagents = list("protein" = 8, "blattedin" = 12, "starkellin" = 15, "diplopterum" = 4)

/obj/item/reagent_containers/food/snacks/meat/roachmeat/fuhrer
	preloaded_reagents = list("protein" = 6, "seligitillin" = 6, "fuhrerole" = 12, "diplopterum" = 6)

/obj/item/reagent_containers/food/snacks/meat/roachmeat/kaiser
	preloaded_reagents = list("protein" = 6, "blattedin" = 12, "seligitillin" = 6, "starkellin" = 15, "fuhrerole" = 12, "diplopterum" = 6)

/obj/item/reagent_containers/food/snacks/meat/roachmeat/jager
	preloaded_reagents = list("protein" = 6, "blattedin" = 2, "gewaltine" = 8, "diplopterum" = 2)

/obj/item/reagent_containers/food/snacks/meat/roachmeat/kraftwerk
	preloaded_reagents = list("protein" = 6, "blattedin" = 6, "gewaltine" = 6, "uncap nanites" = 2, "nanites" = 3)

/obj/item/reagent_containers/food/snacks/meat/roachmeat/glowing
	preloaded_reagents = list("protein" = 4, "blattedin" = 8, "diplopterum" = 7, MATERIAL_URANIUM = 5) // half a uranium per roach

/obj/item/reagent_containers/food/snacks/meat/roachmeat/elektromagnetisch
	preloaded_reagents = list("protein" = 4, "seligitillin" = 8, "diplopterum" = 6, "iron" = 5)

/obj/item/reagent_containers/food/snacks/meat/roachmeat/nitro
	desc = "A slab of sickly-green meat cut from a benzin roach. Has pools of welding fuel."
	preloaded_reagents = list("protein" = 4, "blattedin" = 6, "fuel" = 30)

/obj/item/reagent_containers/food/snacks/meat/spider
	desc = "A bloated slab of sickly-green meat cut from a spider."
	icon_state = "xenomeat"
	filling_color = "#E2FFDE"
	bitesize = 6
	preloaded_reagents = list("protein" = 7, "pararein" = 12, "ammonia" = 4)

/obj/item/reagent_containers/food/snacks/meat/spider/hunter
	preloaded_reagents = list("protein" = 9, "aranecolmin" = 8, "pararein" = 2, "ammonia" = 4)

/obj/item/reagent_containers/food/snacks/meat/spider/plasma
	preloaded_reagents = list("protein" = 9, "aranecolmin" = 8, "plasma" = 5, "ammonia" = 4)

/obj/item/reagent_containers/food/snacks/meat/spider/pepper
	preloaded_reagents = list("protein" = 9, "aranecolmin" = 8, "condensedcapsaicinspider" = 5, "ammonia" = 4)

/obj/item/reagent_containers/food/snacks/meat/spider/emperor
	//Emperor Spider's meat contains party drops, big brain chemical. 8 seems fine. Emperors are dangerous.
	preloaded_reagents = list("protein" = 8, "pararein" = 8, "party drops" = 8, "ammonia" = 4)

/obj/item/reagent_containers/food/snacks/meat/spider/reaper_spider
	preloaded_reagents = list("protein" = 8, "pararein" = 8, "stoxin" = 8, "ammonia" = 4)

/obj/item/reagent_containers/food/snacks/meat/spider/nurse
	desc = "A bloated slab of sickly-green meat cut from a spider. The venom just gives it more flavor. Delicious!"
	icon_state = "xenomeat"
	filling_color = "#E2FFDE"

	bitesize = 6
	preloaded_reagents = list("protein" = 8, "pararein" = 8, "stoxin" = 12, "ammonia" = 4)

/obj/item/reagent_containers/food/snacks/meat/spider/midwife
	preloaded_reagents = list("protein" = 8, "pararein" = 8, "mutagen" = 8, "ammonia" = 4)

/obj/item/reagent_containers/food/snacks/meat/spider/cave_spider
	preloaded_reagents = list("protein" = 8, "pararein" = 8, "frostoil" = 8, "ammonia" = 4)

/obj/item/reagent_containers/food/snacks/meat/spider/recluse
	preloaded_reagents = list("protein" = 8, "pararein" = 8, "zombiepowder" = 6, "ammonia" = 4)

/obj/item/reagent_containers/food/snacks/meat/spider/queen
	preloaded_reagents = list("protein" = 8, "pararein" = 8, "menace" = 6, "ammonia" = 4)

/obj/item/reagent_containers/food/snacks/meat/carp
	name = "carp fillet"
	desc = "A juicy fillet cut from a carp. They are known for the potent and powerful venom they produce."
	icon_state = "fishfillet"
	filling_color = "#FFDEFE"
	center_of_mass = list("x"=17, "y"=13)
	bitesize = 6
	preloaded_reagents = list("protein" = 8, "carpotoxin" = 8)

/obj/item/reagent_containers/food/snacks/meat/bearmeat
	name = "bear meat"
	desc = "A slab of meat cut from a bear."
	icon_state = "bearmeat"
	filling_color = "#DB0000"
	bitesize = 3
	center_of_mass = list("x"=16, "y"=10)
	preloaded_reagents = list("protein" = 12, "hyperzine" = 5)

/obj/item/reagent_containers/food/snacks/meat/primal
	name = "meat"
	desc = "A massive slab of meat containing a metric ton of protein and chemicals natural to a render."
	icon_state = "bearmeat"
	filling_color = "#DB0000"
	bitesize = 6
	center_of_mass = list("x"=16, "y"=10)
	preloaded_reagents = list("protein" = 25, "tramadol" = 5)

/obj/item/reagent_containers/food/snacks/meat/xenomeat
	name = "xenomorph meat"
	desc = "A fatty cut of bright-green meat."
	icon_state = "xenomeat"
	filling_color = "#43DE18"
	bitesize = 6
	center_of_mass = list("x"=16, "y"=10)
	preloaded_reagents = list("protein" = 6, "pacid" = 6)

/obj/item/reagent_containers/food/snacks/meat/fungi
	name = "fungal slab"
	desc = "The meat of a strange, sentient fungal creature. It feels watery to the touch, yet it doesn't moisten, presumabily packed with myriad of chemicals." // You didn't just kill your mushroom friend for this, did you...?
	icon_state = "fungalmeat"
	filling_color = "#BF896B"
	preloaded_reagents = list("protein" = 6, "dexalinp" = 3, "haloperidol" = 4, "hyronalin" = 5, "vermicetol" = 3, "dermaline" = 2, "kelotane" = 2, "peridaxon" = 2, "varceptol" = 3, "meralyne" = 3, "tricordrazine" = 4, "oxycodone" = 5)

/obj/item/reagent_containers/food/snacks/meat/chicken
	name = "poultry"
	desc = "Poultry meat, might be chicken or any other avian species."
	icon_state = "birdmeat"
	filling_color = "#EDA897"
	preloaded_reagents = list("protein" = 8)
	slice_path = /obj/item/reagent_containers/food/snacks/chickenbreast
	slices_num = 4

/obj/item/reagent_containers/food/snacks/meat/chicken/vox
	name = "tribal bird meat"
	desc = "The meat of a tribal bird native to this planet. Their remarkable endurance makes the tissue rubbery, but very rich in protein."
	icon_state = "voxmeat"
	filling_color = "#3B8529"
	preloaded_reagents = list("protein" = 8, "polystem" = 5, "quickclot" = 5)
	slice_path = /obj/item/reagent_containers/food/snacks/chickenbreast
	slices_num = 4

/obj/item/reagent_containers/food/snacks/meat/runtimes_dinner
	name = "Runtime's Dinner"
	desc = "A plate of wet catfood."
	icon_state = "soydope"
	filling_color = "#3B8529"
	preloaded_reagents = list("protein" = 8, "nutriment" = 15, "polystem" = 1)
	slices_num = 0
