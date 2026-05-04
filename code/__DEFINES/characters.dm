// Character archetype IDs — used as savefile keys and for validation.
// Each /datum/character_archetype subtype sets its archetype_id to one of these.
#define CHARACTER_ARCHETYPE_INTERN "intern"
#define CHARACTER_ARCHETYPE_LABORER "laborer"
#define CHARACTER_ARCHETYPE_MANAGER "manager"
#define CHARACTER_ARCHETYPE_SCHOLAR "scholar"

/// Non-AFK playtime minutes required per SP grant interval
#define SP_PLAYTIME_INTERVAL 15
/// SP awarded per completed interval
#define SP_PER_INTERVAL 10

// Quirk category defines. Used to determine whether the quirks are bad/whatever/good
#define QUIRK_CATEGORY_POSITIVE "positive"
#define QUIRK_CATEGORY_NEGATIVE "negative"
#define QUIRK_CATEGORY_NEUTRAL  "neutral"
