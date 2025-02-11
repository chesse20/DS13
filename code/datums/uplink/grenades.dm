/***********
* Grenades *
************/
/datum/uplink_item/item/grenades
	category = /datum/uplink_category/grenades

/datum/uplink_item/item/grenades/smoke
	name = "1xSmoke Grenade"
	item_cost = 4
	path = /obj/item/grenade/smokebomb

/datum/uplink_item/item/grenades/smokes
	name = "5xSmoke Grenades"
	item_cost = 16
	path = /obj/item/storage/box/smokes

/datum/uplink_item/item/grenades/emp
	name = "1xEMP Grenade"
	item_cost = 8
	path = /obj/item/grenade/empgrenade

/datum/uplink_item/item/grenades/emp/special
	is_special = 6
	is_special = TRUE
	antag_roles = list(MODE_EARTHGOV_AGENT)

/datum/uplink_item/item/grenades/emps
	name = "5xEMP Grenades"
	item_cost = 24
	path = /obj/item/storage/box/emps

/datum/uplink_item/item/grenades/emps/special
	is_special = 18
	is_special = TRUE
	antag_roles = list(MODE_EARTHGOV_AGENT)

/datum/uplink_item/item/grenades/frag_high_yield
	name = "Fragmentation Bomb"
	item_cost = 24
	antag_roles = list(MODE_MERCENARY) // yeah maybe regular traitors shouldn't be able to get these
	path = /obj/item/grenade/frag/high_yield

/datum/uplink_item/item/grenades/frag_high_yield/special
	item_cost = 18
	is_special = TRUE
	antag_roles = list(MODE_UNITOLOGIST, MODE_UNITOLOGIST_SHARD)

/datum/uplink_item/item/grenades/fragshell
	name = "1xFragmentation Shell"
	desc = "Weaker than standard fragmentation grenades, these devices can be fired from a grenade launcher."
	item_cost = 10
	antag_roles = list(MODE_MERCENARY)
	path = /obj/item/grenade/frag/shell

/datum/uplink_item/item/grenades/fragshell/special
	item_cost = 7
	is_special = TRUE
	antag_roles = list(MODE_UNITOLOGIST, MODE_UNITOLOGIST_SHARD)

/datum/uplink_item/item/grenades/fragshells
	name = "5xFragmentation Shells"
	desc = "Weaker than standard fragmentation grenades, these devices can be fired from a grenade launcher."
	item_cost = 40
	antag_roles = list(MODE_MERCENARY)
	path = /obj/item/storage/box/fragshells

/datum/uplink_item/item/grenades/frag
	name = "1xFragmentation Grenade"
	item_cost = 10
	antag_roles = list(MODE_MERCENARY)
	path = /obj/item/grenade/frag

/datum/uplink_item/item/grenades/frags
	name = "5xFragmentation Grenades"
	item_cost = 40
	antag_roles = list(MODE_MERCENARY)
	path = /obj/item/storage/box/frags

/datum/uplink_item/item/grenades/supermatter
	name = "1xSupermatter Grenade"
	desc = "This grenade contains a small supermatter shard which will delaminate upon activation and pull in nearby objects, irradiate lifeforms, and eventually explode."
	item_cost = 25
	antag_roles = list(MODE_MERCENARY = 15)
	path = /obj/item/grenade/supermatter

/datum/uplink_item/item/grenades/supermatters
	name = "5xSupermatter Grenades"
	desc = "These grenades contains a small supermatter shard which will delaminate upon activation and pull in nearby objects, irradiate lifeforms, and eventually explode."
	item_cost = 60
	antag_roles = list(MODE_MERCENARY)
	path = /obj/item/storage/box/supermatters