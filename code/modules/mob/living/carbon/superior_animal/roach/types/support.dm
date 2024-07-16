/mob/living/carbon/superior_animal/roach/support
	name = "Seuche Roach"
	desc = "A monstrous, dog-sized cockroach. This one smells like hell and secretes strange vapors."
	icon_state = "seuche"
	turns_per_move = 6
	maxHealth = 15 * ROACH_HEALTH_MOD
	health = 15 * ROACH_HEALTH_MOD
	var/datum/reagents/gas_sac //Stores gas. Can't use the default reagents since that is now bloodstream
	melee_damage_upper = 3
	meat_type = /obj/item/reagent_containers/food/snacks/meat/roachmeat/seuche
	meat_amount = 3

	knockdown_odds = 3

	blattedin_revives_left = 1
	inherent_mutations = list(MUTATION_ROACH_BLOOD, MUTATION_PSN_BREATH, MUTATION_COUGHING, MUTATION_DEAF, MUTATION_TOURETTES, MUTATION_EPILEPSY)

/mob/living/carbon/superior_animal/roach/support/New()
	.=..()
	gas_sac = new /datum/reagents(100, src)

/mob/living/carbon/superior_animal/roach/support/Destroy()
	gas_sac.my_atom = null
	QDEL_NULL(gas_sac)

	. = ..()


/mob/living/carbon/superior_animal/roach/support/proc/gas_attack()
	if (!gas_sac.has_reagent("blattedin", 20) || stat != CONSCIOUS)
		return

	var/location = get_turf(src)
	var/datum/effect/effect/system/smoke_spread/chem/S = new

	S.attach(location)
	S.set_up(gas_sac, gas_sac.total_volume, 0, location)
	src.visible_message(SPAN_DANGER("\the [src] secretes strange vapors!"))

	spawn(0)
		S.start()

	gas_sac.clear_reagents()
	return TRUE

/mob/living/carbon/superior_animal/roach/support/Life()
	. = ..()

	var/atom/targetted_mob = (target_mob?.resolve())

	if(stat != CONSCIOUS)
		return

	if(stat != AI_inactive)
		return

	gas_sac.add_reagent("blattedin", 1)

	if(!targetted_mob)
		return

	if(prob(7))
		gas_attack()

/mob/living/carbon/superior_animal/roach/support/doTargetMessage()
	. = ..()
	if (gas_attack())
		visible_emote("charges at [.] in clouds of poison!")
