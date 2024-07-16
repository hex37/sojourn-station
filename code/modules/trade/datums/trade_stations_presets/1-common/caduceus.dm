/datum/trade_station/caduceus
	name_pool = list(
		"MAV 'Caduceus'" = "Moebius Aid Vessel 'Caduceus':\n\"Hello there, we are from the Kriosan Confederacy. We will be leaving the system shortly but we can offer you medical supplies in the mean time.\"."
	)
	icon_states = list("moe_frigate", "ship")
	tree_x = 0.26
	tree_y = 0.9
	start_discovered = TRUE
	uid = "moe_basic"
	spawn_always = TRUE
	markup = COMMON_GOODS
	offer_limit = 20
	base_income = 1600
	wealth = 0
	hidden_inv_threshold = 2000
	recommendation_threshold = 2000
	stations_recommended = list("moe_adv")
	forced_overmap_zone = list(
		list(20, 22),
		list(20, 25)
	)
	inventory = list(
		"First Aid" = list(
			/obj/item/storage/firstaid/regular,
			/obj/item/storage/firstaid/fire,
			/obj/item/storage/firstaid/toxin,
			/obj/item/storage/firstaid/o2,
			/obj/item/storage/firstaid/adv,
			/obj/item/reagent_containers/glass/bottle/antitoxin = good_data("dylovene bottle", list(-1, 1), 700),
			/obj/item/reagent_containers/glass/bottle/inaprovaline = good_data("inaprovaline bottle", list(-1, 1), 700),
			/obj/item/reagent_containers/glass/bottle/stoxin = good_data("soporific bottle", list(-1, 1), 900),
			/obj/item/stack/medical/bruise_pack,
			/obj/item/stack/medical/ointment,
			/obj/item/stack/medical/splint
		),
		"Surgery" = list(
			/obj/item/tool/cautery,
			/obj/item/tool/surgicaldrill,
			/obj/item/tank/anesthetic,
			/obj/item/tool/hemostat,
			/obj/item/tool/scalpel,
			/obj/item/tool/retractor,
			/obj/item/tool/bonesetter,
			/obj/item/tool/saw/circular
		),
		"Blood" = list(
			/obj/structure/medical_stand,
			/obj/item/reagent_containers/blood/empty,
			/obj/item/reagent_containers/blood/APlus,
			/obj/item/reagent_containers/blood/AMinus,
			/obj/item/reagent_containers/blood/BPlus,
			/obj/item/reagent_containers/blood/BMinus,
			/obj/item/reagent_containers/blood/OPlus,
			/obj/item/reagent_containers/blood/OMinus
		),
		"Protection" = list(
			/obj/item/clothing/suit/radiation = good_data("Radiation Suit", list(3, 4), 600),
			/obj/item/clothing/head/radiation = good_data("Radiation Hood", list(3, 4), 600),
			/obj/item/clothing/suit/bio_suit/general = good_data("Gengeric Biohazard Suit", list(3, 4), 800),
			/obj/item/clothing/head/bio_hood/general = good_data("Gengeric Biohazard Hood", list(3, 4), 800),
			/obj/item/clothing/suit/bio_suit/virology = good_data("Virology Biohazard Suit", list(3, 4), 800),
			/obj/item/clothing/head/bio_hood/virology = good_data("Virology Biohazard Hood", list(3, 4), 800),
			/obj/item/clothing/suit/bio_suit/janitor = good_data("Janitor Biohazard Suit", list(3, 4), 800),
			/obj/item/clothing/head/bio_hood/janitor = good_data("Janitor Biohazard Hood", list(3, 4), 800),
			/obj/item/clothing/suit/bio_suit/security = good_data("Red Sec Biohazard Suit", list(3, 4), 800),
			/obj/item/clothing/head/bio_hood/security = good_data("Red Sec Biohazard Hood", list(3, 4), 800),
			/obj/item/clothing/suit/bio_suit/scientist = good_data("SI Biohazard Suit", list(3, 4), 800),
			/obj/item/clothing/head/bio_hood/scientist = good_data("SI Biohazard Hood", list(3, 4), 800),
			/obj/item/clothing/suit/bio_suit/cmo = good_data("CMO Biohazard Suit", list(3, 4), 800),
			/obj/item/clothing/head/bio_hood/cmo = good_data("CMO Biohazard Hood", list(3, 4), 800)
		),
		"Misc" = list(
			/obj/structure/reagent_dispensers/coolanttank,
			/obj/item/clothing/mask/breath/medical,
			/obj/item/clothing/mask/surgical,
			/obj/item/clothing/gloves/latex,
			/obj/item/reagent_containers/syringe,
			/obj/item/reagent_containers/hypospray/autoinjector,
			/obj/item/bodybag,
			/obj/item/storage/box/syringes,
			/obj/item/storage/box/autoinjectors,
			/obj/item/storage/box/masks,
			/obj/item/storage/box/gloves,
			/obj/item/storage/box/rxglasses,
			/obj/item/storage/box/bodybags,
			/obj/machinery/suspension_gen,
			/obj/item/computer_hardware/hard_drive/portable/design/medical = custom_good_amount_range(list(3, 6)),
			/obj/item/device/defib_kit,
			/obj/item/reagent_containers/glass/beaker/vial/nanites = good_data("Raw Nanites Vial", list(-2, 2), 1200),
			/obj/item/reagent_containers/glass/beaker/vial/uncapnanites = good_data("Raw Uncapped Nanites Vial", list(-1, 1), 1500)
		)
	)
	hidden_inventory = list(
		"Autoinjectors" = list(
			// Autoinjectors defined in hypospray.dm
			/obj/item/reagent_containers/hypospray/autoinjector/antitoxin = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/tricordrazine = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/kelotane = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/bicaridine = custom_good_amount_range(list(5, 10)),
			/obj/item/reagent_containers/hypospray/autoinjector/dexalin = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/spaceacillin = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/tramadol = custom_good_amount_range(list(5, 10)),
		),
		"Surgery II" = list(
			/obj/item/tool/retractor/adv = custom_good_amount_range(list(1, 2)),
			/obj/item/tool/bonesetter/adv = custom_good_amount_range(list(1, 2)),
			/obj/item/tool/cautery/adv = custom_good_amount_range(list(1, 2)),
			/obj/item/tool/hemostat/adv = custom_good_amount_range(list(1, 2)),
			/obj/item/tool/scalpel/laser = custom_good_amount_range(list(1, 2)),
			/obj/item/tool/scalpel/advanced = custom_good_amount_range(list(1, 2)),
			/obj/item/tool/tape_roll/bonegel = custom_good_amount_range(list(1, 2)),
			/obj/item/tool/saw/circular/medical = custom_good_amount_range(list(1, 2)),
			/obj/item/tool/hammer = custom_good_amount_range(list(1, 2)),
			/obj/item/tool/surgicaldrill/adv = custom_good_amount_range(list(1, 2)),
			/obj/item/modification/organ/internal/electromechanical/bone_braces = custom_good_amount_range(list(1, 2))
		)
	)

	offer_types = list(
		/obj/item/organ/internal/scaffold = offer_data_mods("aberrant organ (input, process, output)", 1200, 4, OFFER_ABERRANT_ORGAN, 3),
		/datum/reagent/medicine/ossisine = offer_data("ossissine bottle (60u)", 2000, 1),
		/datum/reagent/medicine/bicaridine = offer_data("bicard bottle (60u)", 250, 3),
		/datum/reagent/medicine/kelotane = offer_data("kelotane bottle (60u)", 250, 3),
		/datum/reagent/medicine/dylovene = offer_data("dylovene bottle (60u)", 250, 3),
		/datum/reagent/nanites/uncapped/control_booster_utility = offer_data("Control Booster Utility bottle (60u)", 30000, 1),
		/datum/reagent/nanites/uncapped/control_booster_combat = offer_data("Control Booster Combat bottle (60u)", 30000, 1)
		)
