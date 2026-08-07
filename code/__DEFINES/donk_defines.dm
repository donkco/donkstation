// Body fat ratios
#define BODY_FAT_LETHAL 0.02
#define BODY_FAT_DANGER 0.06  // Ronnie Coleman, here I come...
#define BODY_FAT_NORMAL 0.18
#define BODY_FAT_OVERWEIGHT  0.25
#define BODY_FAT_OBESE 0.3 // Before.
#define BODY_FAT_MORBIDLY_OBESE 0.35 // its morbin time
#define BODY_FAT_EXTREMELY_OBESE 0.4 // And waaaay before!
#define BODY_FAT_MATROID_OBESE 0.5 // Around the house lower limit
#define BODY_FAT_PLANET_X_NIBURU 0.7
#define CALORIES_TO_BODYFAT_RATIO (1 / (SPACEMAN_DAILY_CALORIE_DEMAND * 10))

// Ailment defines

#define AILMENT_DORMANT 1
#define AILMENT_MILD 2
#define AILMENT_MODERATE 3
#define AILMENT_SEVERE 4
#define AILMENT_FLARED 5
#define AILMENT_DOCTOR_HORRIFIED 6
#define AILMENT_JOBIAN_TRIAL 7

#define HERTZ *1
#define SECONDS_PER_DAY 86400

//# -----------------Energy defines  --------------------------#
// Archaic energy units
// Calorie - Commonly used for food energy and sometimes in chemistry
#define CALORIE (4.184 JOULES)
#define CALORIES *CALORIE
// British Thermal Unit - Used for fuel and heating
#define BTU (1055 JOULES)
#define BTUS *BTU
// Barrel of oil equivalent - Used in fossil fuels industry
#define BOE (5.4 GIGA JOULES)
#define BOES *BOE

// I decree that 1u is officially equal to 1ml
#define UNIT 1
#define UNITS *UNIT
#define LITER (1000 UNITS)
#define LITERS *LITER

#define SPACEMAN_DAILY_CALORIE_DEMAND (2500 KILO CALORIES)
/// Passive energy consumption, set to a realistic 80 Watts (J / s) or about 19 (small)calories per second
#define SPACEMAN_ENERGY_CONSUMPTION (SPACEMAN_DAILY_CALORIE_DEMAND / SECONDS_PER_DAY / 1.5)
/// Running double step energy cost which means running at a full speed of 5 tiles / second has an energy consumption of 400w + the basic metabolic rate.
#define ENERGY_CONSUMPTION_STEP (40 JOULES)
#define SPACEWOMAN_CALORIE_MOD 0.8
// How much faster the ingame clock moves compared to real life, not accounting for time dilation.
#define SPACETIME_MOD 12
/// The watts as measured in the game world, which is 12 times faster than real life.
#define SPACEWATTS *(WATT * SPACETIME_MOD)

//#---------------- BLOOD SUGAR / NUTRITION
//equvalent to 100mg/dl in a 5L blood volume,
#define BLOOD_SUGAR_NORMAL (100 MG_GLUCOSE_PER_DL) //85 kJ

/// conversion factor for nutrition in joules to blood sugar in mg/dl, assuming exactly 5L of blood in the body. 1 joule = 0.0011765 mg/dl

/// How much sugar energy is contained in the spacemans circulatory system per mg / dl
#define JOULES_PER_BLOOD_GLUCOSE (SUGAR_ENERGY_PER_MG * HUMAN_BLOOD_VOLUME / 10)
/// Unit for assiging nutrition in blood sugar concentration rather than joules.
#define MG_GLUCOSE_PER_DL *JOULES_PER_BLOOD_GLUCOSE
/// How much food energy is contained by 1mg of sugar / carbohydrate
#define SUGAR_ENERGY_PER_MG (17 JOULES)
/// Approximate reasonable total blood volume for blood sugar calculations until we decide it makes more sense to go off actual blood reagent volume.
#define HUMAN_BLOOD_VOLUME (5 LITERS)

/// Used to determine how much less hungry we should feel when our stomach is full. A value of 0.4 makes us feel 40& fuller at NUTRITION_LEVEL_FULL and 24% fuller at NUTRITION_LEVEL_STARVING
#define STOMACH_FULLNESS_HUNGER_MOD 0.4

#define NUTRITION_LEVEL_FAT (360 MG_GLUCOSE_PER_DL)
#define NUTRITION_LEVEL_FULL (180 MG_GLUCOSE_PER_DL)
#define NUTRITION_LEVEL_WELL_FED (BLOOD_SUGAR_NORMAL)
#define NUTRITION_LEVEL_FED (90 MG_GLUCOSE_PER_DL)
#define NUTRITION_LEVEL_HUNGRY (80 MG_GLUCOSE_PER_DL)
#define NUTRITION_LEVEL_VERY_HUNGRY (70 MG_GLUCOSE_PER_DL)
#define NUTRITION_LEVEL_STARVING  (60 MG_GLUCOSE_PER_DL)

#define NUTRITION_LEVEL_START_MIN NUTRITION_LEVEL_HUNGRY
#define NUTRITION_LEVEL_START_MAX NUTRITION_LEVEL_WELL_FED

#define MAX_SATIETY 200

/* ----------------- ENERGY DENSITY ----------------------------
Energy densities in defined calories per unit (actual numeric values under the hood are J/cm3)
--------FOOD ENERGY----------*/
#define ENERGY_DENSITY_FAT (8.37 KILO CALORIES)
#define ENERGY_DENSITY_CARBOHYDRATE (6.21 KILO CALORIES)
#define ENERGY_DENSITY_PROTEIN (ENERGY_DENSITY_CARBOHYDRATE)
#define ENERGY_DENSITY_ETHANOL (5.74 KILO CALORIES)
// -----FUEL ENERGY -----------
#define ENERGY_DENSITY_PLASMA (83.8 BTUS) // Based on diborane which seems like a reasonable real world equivalent.  21.17 kcal per u
#define ENERGY_DENSITY_OIL (36.59 BTUS) //based on diesel fuel which should be reasonably close to lubricating oil. 9.22 kcal per u
#define ENERGY_DENSITY_FUEL (26.54 BTUS) // based on liquified butane, since it is a light volatile hydrocarbon.  6.69 kcal per u

#define TEMP_VECTOR_TRICK(x, y) list(x, y)
