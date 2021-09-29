//Access defines, one is applied to each distribution channel for obtaining the item. An item can have different access in different channels
#define ACCESS_PUBLIC	"public"
#define ACCESS_PATRONS	"patrons"
#define ACCESS_WHITELIST	"whitelist"
// Switch this out to use a database at some point. Each ckey is
// associated with a list of custom item datums. When the character
// spawns, the list is checked and all appropriate datums are spawned.
// See config/example/patron_items.txt for a more detailed overview
// of how the config system works.

// CUSTOM ITEM ICONS:
// Inventory icons must be in patron_item_OBJ with state name [item_icon].
// On-mob icons must be in patron_item_MOB with state name [item_icon].
// Inhands must be in patron_item_MOB as [icon_state]_l and [icon_state]_r.

// Kits must have mech icons in patron_item_OBJ under [kit_icon].
// Broken must be [kit_icon]-broken and open must be [kit_icon]-open.

// Kits must also have hardsuit icons in patron_item_MOB as [kit_icon]_suit
// and [kit_icon]_helmet, and in patron_item_OBJ as [kit_icon].

/var/list/patron_items = list()

/datum/patron_item
	var/name
	var/id	//Used to link whitelists to us
	var/inherit_inhands = 1 //if unset, and inhands are not provided, then the inhand overlays will be invisible.
	var/item_icon
	var/description

	var/item_path = /obj/item
	var/item_path_as_string
	var/req_access = 0
	var/list/req_titles = list()
	var/kit_name
	var/kit_desc
	var/kit_icon
	var/additional_data


	/*
		New vars for DS13
	*/
	var/loadout_cost = null //If not null, this item can be purchased in the loadout for this many points
	var/loadout_access	=	null //One of the ACCESS_XXX defines above, determines who is allowed to buy this in loadout

	var/store_cost = null //If not null, this item can be purchased in the store for this many credits
	var/store_access	=	null //One of the ACCESS_XXX defines above, determines who is allowed to buy this in store

	var/loadout_modkit_cost	=	null //If not null, a modkit to transform another item into this item can be purchased in the loadout for this many points
	var/modkit_access	=	null//One of the ACCESS_XXX defines above, determines who is allowed to buy this in store

	var/list/whitelist	=	null	//A list of ckeys who can use ACCESS_WHITELIST channels with this item

	var/category = "Misc"	//Used for store and loadout

	/*
		This can be one of a few things:
			-A single typepath, or a list of typepaths, of items which the modkit can be applied to, to transform them into the desired item
			-A modkit typepath which is the exact type the modkit will be. This allows you to override procs and make more complex rules about application
	*/
	var/modkit_base	= null


/datum/patron_item/New()
	.=..()

	if (!isnull(loadout_cost) && !isnull(loadout_access))
		create_loadout_datum()

	if (!isnull(store_cost) && !isnull(store_access))
		create_store_datum()

/datum/patron_item/proc/create_loadout_datum()
	var/datum/gear/G = new()
	G.display_name = src.name
	G.description = description
	G.path = item_path
	G.cost = loadout_cost

	switch (loadout_access)
		if (ACCESS_PUBLIC)
			//do nothing
		if (ACCESS_PATRONS)
			G.patron_only = TRUE
		//if (ACCESS_WHITELIST)
			//TODO: Code gear whitelists

	G.Initialize()

	GLOB.gear_datums[G.display_name] = G



/datum/patron_item/proc/create_store_datum()
	var/datum/design/D = new()

	D.name = name
	D.desc = description
	D.build_path = item_path
	D.price = store_cost
	D.build_type = STORE
	D.starts_unlocked = TRUE

	//TODO: PAtron functionality for store listings
	//TODO: Whitelist functionality for store listings
	//TODO: Set transfer setting if the item is a rig or module

	register_research_design(D)



/*
	This proc loads whitelists for Patron items. It assumes that list is appropriately formatted according to the instructions in that file
*/
/proc/load_patron_item_whitelists()

	//The ID of the whitelist we are currently reading
	var/current_id

	//The list of keys in the whitelist
	var/list/current_list = null

	for(var/line in splittext(file2text("config/custom_items.txt"), "\n"))

		line = trim(line)
		if(line == "" || !line || findtext(line, "#", 1, 2))
			continue



		var/list/split = splittext(line,regex(@"[ {},]"))
		if(!LAZYLEN(split))
			continue

		for (var/string in split)

			if (!length(string))
				continue

			//If we don't have an open list id yet, then this first word must be a new ID
			if (!current_id)
				current_id = string
				continue

			current_list += string

		//If there's a curly brace at the end of the line, it closes this list
		if (current_id && findtext(line, "}"))
			register_patron_whitelist(current_id, current_list)
			current_list = list()
			current_id = null


//Here we take an assembled whitelist and find which patron item it should attach to by matching the ID
/proc/register_patron_whitelist(current_id, list/current_list)
	GLOB.patron_item_whitelisted_ckeys |= current_list

	for (var/datum/patron_item/PI in GLOB.patron_items)
		if (PI.id == current_id)
			PI.whitelist = current_list.Copy()
			return TRUE

	LOG_DEBUG("ERROR: Patron whitelist ID [current_id] found no matching patron_item datum to assign to")
	return FALSE


// Parses the config file into the custom_items list.
//DEPRECATED: This proc is no longer used, kept for future reference
/*
/hook/startup/proc/load_custom_items()

	var/datum/custom_item/current_data


		if(findtext(line, "{", 1, 2) || findtext(line, "}", 1, 2)) // New block!
			if(current_data && current_data.assoc_key)
				if(!custom_items[current_data.assoc_key])
					custom_items[current_data.assoc_key] = list()
				var/list/L = custom_items[current_data.assoc_key]
				L |= current_data
			current_data = null

		var/split = findtext(line,":")
		if(!split)
			continue
		var/field = trim(copytext(line,1,split))
		var/field_data = trim(copytext(line,(split+1)))
		if(!field || !field_data)
			continue

		if(!current_data)
			current_data = new()

		switch(field)
			if("ckey")
				current_data.assoc_key = lowertext(field_data)
			if("character_name")
				current_data.character_name = lowertext(field_data)
			if("item_path")
				current_data.item_path = text2path(field_data)
				current_data.item_path_as_string = field_data
			if("item_name")
				current_data.name = field_data
			if("item_icon")
				current_data.item_icon = field_data
			if("inherit_inhands")
				current_data.inherit_inhands = text2num(field_data)
			if("description")
				current_data.description = field_data
			if("req_access")
				current_data.req_access = text2num(field_data)
			if("req_titles")
				current_data.req_titles = splittext(field_data,", ")
			if("kit_name")
				current_data.kit_name = field_data
			if("kit_desc")
				current_data.kit_desc = field_data
			if("kit_icon")
				current_data.kit_icon = field_data
			if("additional_data")
				current_data.additional_data = field_data
	return TRUE
*/