#define INFRA_IGNITION_FULLY_BLOCKED 0.2
#define HEATING_PER_FORCE 20
#define IR_HOTSPOT_TEMPERATURE (T0C + 1000)
#define  IR_LASER_ENERGY 2000

/// /// Handles heating and igniting of suseptible materials
/datum/element/ir_irradiant

/datum/element/ir_irradiant/Attach(datum/target)
	. = ..()

	if(!istype(target, /obj/projectile))
		return ELEMENT_INCOMPATIBLE

	target.AddElementTrait(TRAIT_ON_HIT_EFFECT, REF(src), /datum/element/on_hit_effect)
	RegisterSignal(target, COMSIG_ON_HIT_EFFECT, PROC_REF(infra_irradiate))

/datum/element/bane/Detach(datum/source)
	UnregisterSignal(source, COMSIG_ON_HIT_EFFECT)
	REMOVE_TRAIT(source, TRAIT_ON_HIT_EFFECT, REF(src))
	return ..()

/datum/element/ir_irradiant/proc/infra_irradiate(datum/element_owner, mob/living/irradiator,  atom/movable/infratarget, hit_zone, throw_hit)


	var/obj/projectile/projectile_owner = element_owner

	var/ir_absorbtion_mod = 1.0
	var/flammability_mod = infratarget.resistance_flags & ~FIRE_PROOF

	if(ishuman(infratarget) && hit_zone)
		var/mob/living/carbon/human/infravictim = infratarget
		ir_absorbtion_mod  =  1 - infravictim.getarmor(hit_zone, LASER) / 100
		flammability_mod *= 1 - infravictim.getarmor(hit_zone, FIRE) / 100
		// Check hit zone for temperature protection before heating
		if(!(infravictim.get_heat_protection_flags(SPACE_HELM_MAX_TEMP_PROTECT) & hit_zone))
			infravictim.adjust_bodytemperature(projectile_owner.force * HEATING_PER_FORCE * ir_absorbtion_mod)
		if(flammability_mod >= INFRA_IGNITION_FULLY_BLOCKED)
			infravictim.adjust_fire_stacks(4 * ir_absorbtion_mod * flammability_mod)
			infravictim.ignite_mob(TRUE)

	else
		ir_absorbtion_mod  =  1 - infratarget.get_armor_rating(LASER) / 100
		flammability_mod  *= 1 - infratarget.get_armor_rating(FIRE) / 100
		infratarget?.reagents.adjust_thermal_energy(IR_LASER_ENERGY)
		infratarget.fire_act(IR_HOTSPOT_TEMPERATURE * ir_absorbtion_mod * flammability_mod)

#undef INFRA_IGNITION_FULLY_BLOCKED
#undef HEATING_PER_FORCE
#undef IR_HOTSPOT_TEMPERATURE
