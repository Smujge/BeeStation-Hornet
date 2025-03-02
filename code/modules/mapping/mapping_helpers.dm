//Landmarks and other helpers which speed up the mapping process and reduce the number of unique instances/subtypes of items/turf/ect



/obj/effect/baseturf_helper //Set the baseturfs of every turf in the /area/ it is placed.
	name = "baseturf editor"
	icon = 'icons/effects/mapping_helpers.dmi'
	icon_state = ""

	var/list/baseturf_to_replace
	var/baseturf

	plane = POINT_PLANE

/obj/effect/baseturf_helper/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/baseturf_helper/LateInitialize()
	if(!baseturf_to_replace)
		baseturf_to_replace = typecacheof(/turf/open/space)
	else if(!length(baseturf_to_replace))
		baseturf_to_replace = list(baseturf_to_replace = TRUE)
	else if(baseturf_to_replace[baseturf_to_replace[1]] != TRUE) // It's not associative
		var/list/formatted = list()
		for(var/i in baseturf_to_replace)
			formatted[i] = TRUE
		baseturf_to_replace = formatted

	var/area/our_area = get_area(src)
	for(var/i in get_area_turfs(our_area, z))
		replace_baseturf(i)

	qdel(src)

/obj/effect/baseturf_helper/proc/replace_baseturf(turf/thing)
	if(length(thing.baseturfs))
		var/list/baseturf_cache = thing.baseturfs.Copy()
		for(var/i in baseturf_cache)
			if(baseturf_to_replace[i])
				baseturf_cache -= i
		thing.baseturfs = baseturfs_string_list(baseturf_cache, thing)
		if(!baseturf_cache.len)
			thing.assemble_baseturfs(baseturf)
		else
			thing.PlaceOnBottom(null, baseturf)
	else if(baseturf_to_replace[thing.baseturfs])
		thing.assemble_baseturfs(baseturf)
	else
		thing.PlaceOnBottom(null, baseturf)



/obj/effect/baseturf_helper/space
	name = "space baseturf editor"
	baseturf = /turf/open/space

/obj/effect/baseturf_helper/asteroid
	name = "asteroid baseturf editor"
	baseturf = /turf/open/floor/plating/asteroid

/obj/effect/baseturf_helper/asteroid/airless
	name = "asteroid airless baseturf editor"
	baseturf = /turf/open/floor/plating/asteroid/airless

/obj/effect/baseturf_helper/asteroid/basalt
	name = "asteroid basalt baseturf editor"
	baseturf = /turf/open/floor/plating/asteroid/basalt

/obj/effect/baseturf_helper/asteroid/snow
	name = "asteroid snow baseturf editor"
	baseturf = /turf/open/floor/plating/asteroid/snow

/obj/effect/baseturf_helper/beach/sand
	name = "beach sand baseturf editor"
	baseturf = /turf/open/floor/plating/beach/sand

/obj/effect/baseturf_helper/beach/water
	name = "water baseturf editor"
	baseturf = /turf/open/floor/plating/beach/water

/obj/effect/baseturf_helper/lava
	name = "lava baseturf editor"
	baseturf = /turf/open/lava/smooth

/obj/effect/baseturf_helper/lava_land/surface
	name = "lavaland baseturf editor"
	baseturf = /turf/open/lava/smooth/lava_land_surface


/obj/effect/mapping_helpers
	icon = 'icons/effects/mapping_helpers.dmi'
	icon_state = ""
	var/late = FALSE

/obj/effect/mapping_helpers/Initialize(mapload)
	..()
	return late ? INITIALIZE_HINT_LATELOAD : INITIALIZE_HINT_QDEL

//airlock helpers
/obj/effect/mapping_helpers/airlock
	layer = DOOR_HELPER_LAYER

/obj/effect/mapping_helpers/airlock/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_mapping("[src] spawned outside of mapload!")
		return
	var/obj/machinery/door/airlock/airlock = locate(/obj/machinery/door/airlock) in loc
	if(!airlock)
		log_mapping("[src] failed to find an airlock at [AREACOORD(src)]")
	else
		payload(airlock)

/obj/effect/mapping_helpers/airlock/proc/payload(obj/machinery/door/airlock/payload)
	return

/obj/effect/mapping_helpers/airlock/cyclelink_helper
	name = "airlock cyclelink helper"
	icon_state = "airlock_cyclelink_helper"

/obj/effect/mapping_helpers/airlock/cyclelink_helper/payload(obj/machinery/door/airlock/airlock)
	if(airlock.cyclelinkeddir)
		log_mapping("[src] at [AREACOORD(src)] tried to set [airlock] cyclelinkeddir, but it's already set!")
	else
		airlock.cyclelinkeddir = dir

/obj/effect/mapping_helpers/airlock/cyclelink_helper_multi
	name = "airlock multi-cyclelink helper"
	icon_state = "airlock_multicyclelink_helper"
	var/cycle_id

/obj/effect/mapping_helpers/airlock/cyclelink_helper_multi/payload(obj/machinery/door/airlock/airlock)
	if(airlock.closeOtherId)
		log_mapping("[src] at [AREACOORD(src)] tried to set [airlock] closeOtherId, but it's already set!")
	else
		airlock.closeOtherId = cycle_id

/obj/effect/mapping_helpers/airlock/locked
	name = "airlock lock helper"
	icon_state = "airlock_locked_helper"

/obj/effect/mapping_helpers/airlock/locked/payload(obj/machinery/door/airlock/airlock)
	if(airlock.locked)
		log_mapping("[src] at [AREACOORD(src)] tried to bolt [airlock] but it's already locked!")
	else
		airlock.locked = TRUE


/obj/effect/mapping_helpers/airlock/unres
	name = "airlock unresctricted side helper"
	icon_state = "airlock_unres_helper"

/obj/effect/mapping_helpers/airlock/unres/payload(obj/machinery/door/airlock/airlock)
	airlock.unres_sides ^= dir

/obj/effect/mapping_helpers/airlock/abandoned
	name = "airlock abandoned helper"
	icon_state = "airlock_abandoned"

/obj/effect/mapping_helpers/airlock/abandoned/payload(obj/machinery/door/airlock/airlock)
	if(airlock.abandoned)
		log_mapping("[src] at [AREACOORD(src)] tried to make [airlock] abandoned but it's already abandoned!")
	else
		airlock.abandoned = TRUE

//APC helpers
/obj/effect/mapping_helpers/apc

/obj/effect/mapping_helpers/apc/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_mapping("[src] spawned outside of mapload!")
		return
	var/obj/machinery/power/apc/apc = locate(/obj/machinery/power/apc) in loc
	if(!apc)
		log_mapping("[src] failed to find an APC at [AREACOORD(src)]")
	else
		payload(apc)

/obj/effect/mapping_helpers/apc/proc/payload(obj/machinery/power/apc/payload)
	return

/obj/effect/mapping_helpers/apc/discharged
	name = "apc zero change helper"
	icon_state = "apc_nopower"

/obj/effect/mapping_helpers/apc/discharged/payload(obj/machinery/power/apc/apc)
	var/obj/item/stock_parts/cell/C = apc.get_cell()
	C.charge = 0
	C.update_icon()


//needs to do its thing before spawn_rivers() is called
INITIALIZE_IMMEDIATE(/obj/effect/mapping_helpers/no_lava)

/obj/effect/mapping_helpers/no_lava
	icon_state = "no_lava"

/obj/effect/mapping_helpers/no_lava/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	T.flags_1 |= NO_LAVA_GEN_1

//This helper applies components to things on the map directly.
/obj/effect/mapping_helpers/component_injector
	name = "Component Injector"
	late = TRUE
	var/target_type
	var/target_name
	var/component_type

//Late init so everything is likely ready and loaded (no warranty)
/obj/effect/mapping_helpers/component_injector/LateInitialize()
	if(!ispath(component_type,/datum/component))
		CRASH("Wrong component type in [type] - [component_type] is not a component")
	var/turf/T = get_turf(src)
	for(var/atom/A in T.GetAllContents())
		if(A == src)
			continue
		if(target_name && A.name != target_name)
			continue
		if(target_type && !istype(A,target_type))
			continue
		var/cargs = build_args()
		A._AddComponent(cargs)
		qdel(src)
		return

/obj/effect/mapping_helpers/component_injector/proc/build_args()
	return list(component_type)

/obj/effect/mapping_helpers/component_injector/infective
	name = "Infective Injector"
	icon_state = "component_infective"
	component_type = /datum/component/infective
	var/disease_type

/obj/effect/mapping_helpers/component_injector/infective/build_args()
	if(!ispath(disease_type,/datum/disease))
		CRASH("Wrong disease type passed in.")
	var/datum/disease/D = new disease_type()
	return list(component_type,D)

/obj/effect/mapping_helpers/dead_body_placer
	name = "Dead Body placer"
	late = TRUE
	icon_state = "deadbodyplacer"
	/// number of bodies to spawn
	var/bodycount = 1
	/// -1: area search (VERY expensive - do not use this in maint/ruin type)
	/// 0: spawns onto itself
	/// +1: turfs from this dead body placer
	var/search_view_range = 0
	/// the list of container typepath which accepts dead bodies
	var/list/accepted_list = list(
		/obj/structure/bodycontainer/morgue,
		/obj/structure/closet
	)

/// as long as this body placer is contained within medbay morgue, this is fine to be expensive.
/// DO NOT USE this outside of medbay morgue
/obj/effect/mapping_helpers/dead_body_placer/medbay_morgue
	bodycount = 2
	accepted_list = list(/obj/structure/bodycontainer/morgue)
	search_view_range = -1

/obj/effect/mapping_helpers/dead_body_placer/ruin_morgue
	bodycount = 2
	accepted_list = list(/obj/structure/bodycontainer/morgue)
	search_view_range = 7

/obj/effect/mapping_helpers/dead_body_placer/maint_fridge
	bodycount = 2
	accepted_list = list(/obj/structure/closet)
	search_view_range = 0

/obj/effect/mapping_helpers/dead_body_placer/LateInitialize()
	var/area/current_area = get_area(src)
	var/list/found_container = list()

	// search_view_range
	//   [Negative]: area search, get_contained_turfs()
	if(search_view_range < 0)
		for(var/turf/each_turf in current_area.get_contained_turfs())
			for(var/obj/each_container in each_turf)
				for(var/acceptable_path in accepted_list)
					if(istype(each_container, acceptable_path))
						found_container += each_container
						break
	//  [Positive]: view range search, view()
	//      [Zero]: onto itself, get_turf()
	else
		for(var/obj/each_container in (search_view_range ? view(search_view_range, get_turf(src)) : get_turf(src)))
			if(get_area(each_container) != current_area)
				continue // we don't want to put a deadbody to a wrong area
			for(var/acceptable_path in accepted_list)
				if(istype(each_container, acceptable_path))
					found_container += each_container
					break

	while(bodycount-- > 0)
		if(length(found_container))
			spawn_dead_human_in_tray(pick(found_container))
		else // if we have found no container, just spawn onto a turf
			spawn_dead_human_in_tray(get_turf(src))

	qdel(src)

/obj/effect/mapping_helpers/dead_body_placer/proc/spawn_dead_human_in_tray(atom/container)
	var/mob/living/carbon/human/corpse = new(container)
	var/list/possible_alt_species = GLOB.roundstart_races.Copy() - list(SPECIES_HUMAN, SPECIES_IPC)
	if(prob(15) && length(possible_alt_species))
		corpse.set_species(GLOB.species_list[pick(possible_alt_species)])
	corpse.give_random_dormant_disease(25, min_symptoms = 1, max_symptoms = 5) // slightly more likely that an average stationgoer to have a dormant disease, bc who KNOWS how they died?
	corpse.death()
	for (var/obj/item/organ/organ in corpse.internal_organs) //randomly remove organs from each body, set those we keep to be in stasis
		if (prob(40))
			qdel(organ)
		else
			organ.organ_flags |= ORGAN_FROZEN
	container.update_icon()

//Color correction helper - only use of these per area, it will convert the entire area
/obj/effect/mapping_helpers/color_correction
	name = "color correction helper"
	icon_state = "color_correction"
	var/color_correction = /datum/client_colour/area_color/cold

/obj/effect/mapping_helpers/color_correction/Initialize(mapload)
	. = ..()
	var/area/A = get_area(get_turf(src))
	A.color_correction = color_correction

//Make any turf non-slip
/obj/effect/mapping_helpers/make_non_slip
	name = "non slip helper"
	icon_state = "no_slip"
	///Do we add the grippy visual
	var/grip_visual = TRUE

/obj/effect/mapping_helpers/make_non_slip/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	T?.make_traction(grip_visual)

//Change this areas turf texture
/obj/effect/mapping_helpers/tile_breaker
	name = "area turf texture helper"
	icon_state = "tile_breaker"

/obj/effect/mapping_helpers/tile_breaker/Initialize(mapload)
	. = ..()
	var/turf/open/floor/T = get_turf(src)
	if(istype(T, /turf/open/floor))
		T.break_tile()
