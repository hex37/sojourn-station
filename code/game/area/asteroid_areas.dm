// GENERIC MINING AREAS

/area/mine
	icon_state = "mining"
	forced_ambience = list('sound/ambience/mineambience.ogg')
	sound_env = ASTEROID
	vessel = null

/area/mine/prep
	name = "Lonestar Mining Prep"
	ship_area = TRUE

/area/mine/processing
	name = "Lonestar Ore Processing"
	ship_area = TRUE

/area/mine/hallway
	name = "Lonestar General"
	ship_area = TRUE

/area/mine/medical
	name = "Lonestar Triage"
	ship_area = TRUE

/area/mine/livingarea
	name = "Lonestar Quarters"
	ship_area = TRUE

/area/mine/atmos
	name = "Lonestar Atmos"
	ship_area = TRUE

/area/mine/power
	name = "Lonestar Machine Room"
	ship_area = TRUE

/area/mine/lockers
	name = "Lonestar Locker Room"
	ship_area = TRUE

/area/mine/explored
	name = "Mine"
	icon_state = "explored"

/area/mine/unexplored
	name = "Mine"
	icon_state = "unexplored"
	turf_initializer = new /datum/turf_initializer/mining()

/area/mine/gulag
	name = "Labor Mines"
	has_gravity = 1

/area/mine/gulag_base
	name = "Labor Camp"
	has_gravity = 1


// OUTPOSTS

// Small outposts
/area/outpost/mining_north
	name = "North Mining Outpost"
	icon_state = "outpost_mine_north"

/area/outpost/mining_west
	name = "West Mining Outpost"
	icon_state = "outpost_mine_west"

/area/outpost/abandoned
	name = "Abandoned Outpost"
	icon_state = "dark"

/area/outpost/abandoned_fortress
	name = "Abandoned Fortress"
	icon_state = "yellow"

/area/outpost/abandoned_fortress/powered
	name = "Abandoned Fortress"
	icon_state = "yellow"
	requires_power = FALSE

/area/outpost/abandoned_fortress/powered_lit
	name = "Excelsior Fortress"
	icon_state = "yellow"
	requires_power = FALSE
	dynamic_lighting = 0

// Main mining outpost
/area/outpost/mining_main
	icon_state = "outpost_mine_main"

/area/outpost/mining_main/dorms
	name = "Mining Outpost Dormitory"

/area/outpost/mining_main/medbay
	name = "Mining Outpost Medical"

/area/outpost/mining_main/maintenance
	name = "Mining Outpost Maintenance"

/area/outpost/mining_main/west_hall
	name = "Mining Outpost West Hallway"

/area/outpost/mining_main/east_hall
	name = "Mining Outpost East Hallway"

/area/outpost/mining_main/eva
	name = "Mining Outpost EVA storage"

/area/outpost/mining_main/refinery
	name = "Mining Outpost Refinery"



// Engineering Outpost
/area/outpost/engineering
	icon_state = "outpost_engine"

/area/outpost/engineering/hallway
	name = "Engineering Outpost Hallway"

/area/outpost/engineering/atmospherics
	name = "Engineering Outpost Atmospherics"

/area/outpost/engineering/power
	name = "Engineering Outpost Power Distribution"

/area/outpost/engineering/telecomms
	name = "Engineering Outpost Telecommunications"

/area/outpost/engineering/storage
	name = "Engineering Outpost Storage"

/area/outpost/engineering/meeting
	name = "Engineering Outpost Meeting Room"



// Research Outpost
/area/outpost/research
	icon_state = "outpost_research"

/area/outpost/research/hallway
	name = "Research Outpost Hallway"

/area/outpost/research/dock
	name = "Research Outpost Shuttle Dock"

/area/outpost/research/eva
	name = "Research Outpost EVA"

/area/outpost/research/analysis
	name = "Research Outpost Sample Analysis"

/area/outpost/research/chemistry
	name = "Research Outpost Chemistry"

/area/outpost/research/medical
	name = "Research Outpost Medical"

/area/outpost/research/power
	name = "Research Outpost Maintenance"

/area/outpost/research/isolation_a
	name = "Research Outpost Isolation A"

/area/outpost/research/isolation_b
	name = "Research Outpost Isolation B"

/area/outpost/research/isolation_c
	name = "Research Outpost Isolation C"

/area/outpost/research/isolation_monitoring
	name = "Research Outpost Isolation Monitoring"

/area/outpost/research/lab
	name = "Research Outpost Laboratory"

/area/outpost/research/emergency_storage
	name = "Research Outpost Emergency Storage"

/area/outpost/research/anomaly_storage
	name = "Research Outpost Anomalous Storage"

/area/outpost/research/anomaly_analysis
	name = "Research Outpost Anomaly Analysis"

/area/outpost/research/kitchen
	name = "Research Outpost Kitchen"

/area/outpost/research/disposal
	name = "Research Outpost Waste Disposal"
