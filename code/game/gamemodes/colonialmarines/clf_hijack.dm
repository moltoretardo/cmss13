/datum/game_mode/extended/clf_hijack
	name = "Distress Signal"
	config_tag = "Distress Signal"
	flags_round_type = MODE_CLF_HIJACK
	toggleable_flags = MODE_NO_SNIPER_SENTRY|MODE_NO_ATTACK_DEAD|MODE_NO_STRIPDRAG_ENEMY|MODE_STRONG_DEFIBS|MODE_BLOOD_OPTIMIZATION|MODE_NO_COMBAT_CAS
	taskbar_icon = 'icons/taskbar/gml_distress.png'

/datum/game_mode/extended/clf_hijack/get_roles_list()
	return ROLES_CLF_HIJACK
