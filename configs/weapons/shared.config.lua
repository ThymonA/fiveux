config.weapon_autoshotgun = {
	name = 'weapon_autoshotgun',
	hash = GetHashKey('WEAPON_AUTOSHOTGUN'),
	clipSize = 10,
	category = 'shotgun',
	model = 'w_sg_sweeper',
	ammo = {
		name = 'ammo_shotgun',
		hash = GetHashKey('AMMO_SHOTGUN'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_AUTOSHOTGUN_CLIP_01',
			hash = GetHashKey('COMPONENT_AUTOSHOTGUN_CLIP_01'),
			model = 'w_sg_sweeper_mag1',
			type = 'clip',
			default = true
		}
	},
	hasAttachments = true,
	numberOfAttachments = 1
}

config.weapon_battleaxe = {
	name = 'weapon_battleaxe',
	hash = GetHashKey('WEAPON_BATTLEAXE'),
	clipSize = 0,
	category = 'melee',
	model = 'w_me_battleaxe',
	ammo = nil,
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_bottle = {
	name = 'weapon_bottle',
	hash = GetHashKey('WEAPON_BOTTLE'),
	clipSize = 0,
	category = 'melee',
	model = 'w_me_bottle',
	ammo = nil,
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_bullpuprifle = {
	name = 'weapon_bullpuprifle',
	hash = GetHashKey('WEAPON_BULLPUPRIFLE'),
	clipSize = 30,
	category = 'rifle',
	model = 'w_ar_bullpuprifle',
	ammo = {
		name = 'ammo_rifle',
		hash = GetHashKey('AMMO_RIFLE'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_BULLPUPRIFLE_CLIP_01',
			hash = GetHashKey('COMPONENT_BULLPUPRIFLE_CLIP_01'),
			model = 'w_ar_bullpuprifle_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_BULLPUPRIFLE_CLIP_02',
			hash = GetHashKey('COMPONENT_BULLPUPRIFLE_CLIP_02'),
			model = 'w_ar_bullpuprifle_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_FLSH',
			hash = GetHashKey('COMPONENT_AT_AR_FLSH'),
			model = 'w_at_ar_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_SMALL',
			hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL'),
			model = 'w_at_scope_small',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_SUPP',
			hash = GetHashKey('COMPONENT_AT_AR_SUPP'),
			model = 'w_at_ar_supp',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_AFGRIP',
			hash = GetHashKey('COMPONENT_AT_AR_AFGRIP'),
			model = 'w_at_ar_afgrip',
			type = 'default',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 6
}

config.weapon_combatpdw = {
	name = 'weapon_combatpdw',
	hash = GetHashKey('WEAPON_COMBATPDW'),
	clipSize = 30,
	category = 'smg',
	model = 'W_SB_PDW',
	ammo = {
		name = 'ammo_smg',
		hash = GetHashKey('AMMO_SMG'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_COMBATPDW_CLIP_01',
			hash = GetHashKey('COMPONENT_COMBATPDW_CLIP_01'),
			model = 'W_SB_PDW_Mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_COMBATPDW_CLIP_02',
			hash = GetHashKey('COMPONENT_COMBATPDW_CLIP_02'),
			model = 'W_SB_PDW_Mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_FLSH',
			hash = GetHashKey('COMPONENT_AT_AR_FLSH'),
			model = 'w_at_ar_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_AFGRIP',
			hash = GetHashKey('COMPONENT_AT_AR_AFGRIP'),
			model = 'w_at_ar_afgrip',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_SMALL',
			hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL'),
			model = 'w_at_scope_small',
			type = 'scope',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 5
}

config.weapon_compactlauncher = {
	name = 'weapon_compactlauncher',
	hash = GetHashKey('WEAPON_COMPACTLAUNCHER'),
	clipSize = 1,
	category = 'heavy',
	model = 'w_lr_compactgl',
	ammo = {
		name = 'ammo_grenadelauncher',
		hash = GetHashKey('AMMO_GRENADELAUNCHER'),
		max = 20
	},
	components = {
		{
			name = 'COMPONENT_COMPACTLAUNCHER_CLIP_01',
			hash = GetHashKey('COMPONENT_COMPACTLAUNCHER_CLIP_01'),
			model = 'w_lr_compactgl_mag1',
			type = 'clip',
			default = true
		}
	},
	hasAttachments = true,
	numberOfAttachments = 1
}

config.weapon_compactrifle = {
	name = 'weapon_compactrifle',
	hash = GetHashKey('WEAPON_COMPACTRIFLE'),
	clipSize = 30,
	category = 'rifle',
	model = 'w_ar_assaultrifle_smg',
	ammo = {
		name = 'ammo_rifle',
		hash = GetHashKey('AMMO_RIFLE'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_COMPACTRIFLE_CLIP_01',
			hash = GetHashKey('COMPONENT_COMPACTRIFLE_CLIP_01'),
			model = 'w_ar_assaultrifle_smg_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_COMPACTRIFLE_CLIP_02',
			hash = GetHashKey('COMPONENT_COMPACTRIFLE_CLIP_02'),
			model = 'w_ar_assaultrifle_smg_mag2',
			type = 'clip',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 2
}

config.weapon_dagger = {
	name = 'weapon_dagger',
	hash = GetHashKey('WEAPON_DAGGER'),
	clipSize = 0,
	category = 'melee',
	model = 'w_me_dagger',
	ammo = nil,
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_dbshotgun = {
	name = 'weapon_dbshotgun',
	hash = GetHashKey('WEAPON_DBSHOTGUN'),
	clipSize = 2,
	category = 'shotgun',
	model = 'w_sg_doublebarrel',
	ammo = {
		name = 'ammo_shotgun',
		hash = GetHashKey('AMMO_SHOTGUN'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_DBSHOTGUN_CLIP_01',
			hash = GetHashKey('COMPONENT_DBSHOTGUN_CLIP_01'),
			model = 'w_sg_doublebarrel_mag1',
			type = 'clip',
			default = true
		}
	},
	hasAttachments = true,
	numberOfAttachments = 1
}

config.weapon_firework = {
	name = 'weapon_firework',
	hash = GetHashKey('WEAPON_FIREWORK'),
	clipSize = 1,
	category = 'heavy',
	model = 'w_lr_firework',
	ammo = {
		name = 'ammo_firework',
		hash = GetHashKey('AMMO_FIREWORK'),
		max = 20
	},
	components = {
		{
			name = 'COMPONENT_FIREWORK_CLIP_01',
			hash = GetHashKey('COMPONENT_FIREWORK_CLIP_01'),
			model = '',
			type = 'clip',
			default = true
		}
	},
	hasAttachments = true,
	numberOfAttachments = 1
}

config.weapon_flaregun = {
	name = 'weapon_flaregun',
	hash = GetHashKey('WEAPON_FLAREGUN'),
	clipSize = 1,
	category = 'pistol',
	model = 'w_pi_flaregun',
	ammo = {
		name = 'ammo_flaregun',
		hash = GetHashKey('AMMO_FLAREGUN'),
		max = 20
	},
	components = {
		{
			name = 'COMPONENT_FLAREGUN_CLIP_01',
			hash = GetHashKey('COMPONENT_FLAREGUN_CLIP_01'),
			model = 'w_pi_flaregun_mag1',
			type = 'clip',
			default = true
		}
	},
	hasAttachments = true,
	numberOfAttachments = 1
}

config.weapon_flashlight = {
	name = 'weapon_flashlight',
	hash = GetHashKey('WEAPON_FLASHLIGHT'),
	clipSize = 0,
	category = 'melee',
	model = 'w_me_flashlight',
	ammo = nil,
	components = {
		{
			name = 'COMPONENT_FLASHLIGHT_LIGHT',
			hash = GetHashKey('COMPONENT_FLASHLIGHT_LIGHT'),
			model = 'w_me_flashlight_flash',
			type = 'flashlight',
			default = true
		}
	},
	hasAttachments = true,
	numberOfAttachments = 1
}

config.weapon_gusenberg = {
	name = 'weapon_gusenberg',
	hash = GetHashKey('WEAPON_GUSENBERG'),
	clipSize = 30,
	category = 'mg',
	model = 'w_sb_gusenberg',
	ammo = {
		name = 'ammo_mg',
		hash = GetHashKey('AMMO_MG'),
		max = 500
	},
	components = {
		{
			name = 'COMPONENT_GUSENBERG_CLIP_01',
			hash = GetHashKey('COMPONENT_GUSENBERG_CLIP_01'),
			model = 'w_sb_gusenberg_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_GUSENBERG_CLIP_02',
			hash = GetHashKey('COMPONENT_GUSENBERG_CLIP_02'),
			model = 'w_sb_gusenberg_mag2',
			type = 'clip',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 2
}

config.weapon_hatchet = {
	name = 'weapon_hatchet',
	hash = GetHashKey('WEAPON_HATCHET'),
	clipSize = 0,
	category = 'melee',
	model = 'w_me_hatchet',
	ammo = nil,
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_heavypistol = {
	name = 'weapon_heavypistol',
	hash = GetHashKey('WEAPON_HEAVYPISTOL'),
	clipSize = 18,
	category = 'pistol',
	model = 'w_pi_heavypistol',
	ammo = {
		name = 'ammo_pistol',
		hash = GetHashKey('AMMO_PISTOL'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_HEAVYPISTOL_CLIP_01',
			hash = GetHashKey('COMPONENT_HEAVYPISTOL_CLIP_01'),
			model = 'w_pi_heavypistol_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_HEAVYPISTOL_CLIP_02',
			hash = GetHashKey('COMPONENT_HEAVYPISTOL_CLIP_02'),
			model = 'w_pi_heavypistol_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_PI_FLSH',
			hash = GetHashKey('COMPONENT_AT_PI_FLSH'),
			model = 'w_at_pi_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_PI_SUPP',
			hash = GetHashKey('COMPONENT_AT_PI_SUPP'),
			model = 'w_at_pi_supp',
			type = 'suppressor',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 4
}

config.weapon_heavyshotgun = {
	name = 'weapon_heavyshotgun',
	hash = GetHashKey('WEAPON_HEAVYSHOTGUN'),
	clipSize = 6,
	category = 'shotgun',
	model = 'w_sg_heavyshotgun',
	ammo = {
		name = 'ammo_shotgun',
		hash = GetHashKey('AMMO_SHOTGUN'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_HEAVYSHOTGUN_CLIP_01',
			hash = GetHashKey('COMPONENT_HEAVYSHOTGUN_CLIP_01'),
			model = 'w_sg_heavyshotgun_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_HEAVYSHOTGUN_CLIP_02',
			hash = GetHashKey('COMPONENT_HEAVYSHOTGUN_CLIP_02'),
			model = 'w_sg_heavyshotgun_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_FLSH',
			hash = GetHashKey('COMPONENT_AT_AR_FLSH'),
			model = 'w_at_ar_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_SUPP_02',
			hash = GetHashKey('COMPONENT_AT_AR_SUPP_02'),
			model = 'w_at_ar_supp_02',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_AFGRIP',
			hash = GetHashKey('COMPONENT_AT_AR_AFGRIP'),
			model = 'w_at_ar_afgrip',
			type = 'default',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 5
}

config.weapon_hominglauncher = {
	name = 'weapon_hominglauncher',
	hash = GetHashKey('WEAPON_HOMINGLAUNCHER'),
	clipSize = 1,
	category = 'heavy',
	model = 'w_lr_homing',
	ammo = {
		name = 'ammo_hominglauncher',
		hash = GetHashKey('AMMO_HOMINGLAUNCHER'),
		max = 10
	},
	components = {
		{
			name = 'COMPONENT_HOMINGLAUNCHER_CLIP_01',
			hash = GetHashKey('COMPONENT_HOMINGLAUNCHER_CLIP_01'),
			model = '',
			type = 'clip',
			default = true
		}
	},
	hasAttachments = true,
	numberOfAttachments = 1
}

config.weapon_knuckle = {
	name = 'weapon_knuckle',
	hash = GetHashKey('WEAPON_KNUCKLE'),
	clipSize = 0,
	category = 'unarmed',
	model = 'W_ME_Knuckle',
	ammo = nil,
	components = {
		{
			name = 'COMPONENT_KNUCKLE_VARMOD_BASE',
			hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_BASE'),
			model = 'W_ME_Knuckle',
			type = 'variant',
			default = false
		},
		{
			name = 'COMPONENT_KNUCKLE_VARMOD_PIMP',
			hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_PIMP'),
			model = 'W_ME_Knuckle_02',
			type = 'variant',
			default = false
		},
		{
			name = 'COMPONENT_KNUCKLE_VARMOD_BALLAS',
			hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_BALLAS'),
			model = 'W_ME_Knuckle_BG',
			type = 'variant',
			default = false
		},
		{
			name = 'COMPONENT_KNUCKLE_VARMOD_DOLLAR',
			hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_DOLLAR'),
			model = 'W_ME_Knuckle_DLR',
			type = 'variant',
			default = false
		},
		{
			name = 'COMPONENT_KNUCKLE_VARMOD_DIAMOND',
			hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_DIAMOND'),
			model = 'W_ME_Knuckle_DMD',
			type = 'variant',
			default = false
		},
		{
			name = 'COMPONENT_KNUCKLE_VARMOD_HATE',
			hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_HATE'),
			model = 'W_ME_Knuckle_HT',
			type = 'variant',
			default = false
		},
		{
			name = 'COMPONENT_KNUCKLE_VARMOD_LOVE',
			hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_LOVE'),
			model = 'W_ME_Knuckle_LV',
			type = 'variant',
			default = false
		},
		{
			name = 'COMPONENT_KNUCKLE_VARMOD_PLAYER',
			hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_PLAYER'),
			model = 'W_ME_Knuckle_PC',
			type = 'variant',
			default = false
		},
		{
			name = 'COMPONENT_KNUCKLE_VARMOD_KING',
			hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_KING'),
			model = 'W_ME_Knuckle_SLG',
			type = 'variant',
			default = false
		},
		{
			name = 'COMPONENT_KNUCKLE_VARMOD_VAGOS',
			hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_VAGOS'),
			model = 'W_ME_Knuckle_VG',
			type = 'variant',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 10
}

config.weapon_machete = {
	name = 'weapon_machete',
	hash = GetHashKey('WEAPON_MACHETE'),
	clipSize = 0,
	category = 'melee',
	model = 'w_me_machette_lr',
	ammo = nil,
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_machinepistol = {
	name = 'weapon_machinepistol',
	hash = GetHashKey('WEAPON_MACHINEPISTOL'),
	clipSize = 12,
	category = 'smg',
	model = 'w_sb_compactsmg',
	ammo = {
		name = 'ammo_smg',
		hash = GetHashKey('AMMO_SMG'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_MACHINEPISTOL_CLIP_01',
			hash = GetHashKey('COMPONENT_MACHINEPISTOL_CLIP_01'),
			model = 'w_sb_compactsmg_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_MACHINEPISTOL_CLIP_02',
			hash = GetHashKey('COMPONENT_MACHINEPISTOL_CLIP_02'),
			model = 'w_sb_compactsmg_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_PI_SUPP',
			hash = GetHashKey('COMPONENT_AT_PI_SUPP'),
			model = 'w_at_pi_supp',
			type = 'suppressor',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 3
}

config.weapon_marksmanpistol = {
	name = 'weapon_marksmanpistol',
	hash = GetHashKey('WEAPON_MARKSMANPISTOL'),
	clipSize = 1,
	category = 'pistol',
	model = 'W_PI_SingleShot',
	ammo = {
		name = 'ammo_pistol',
		hash = GetHashKey('AMMO_PISTOL'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_MARKSMANPISTOL_CLIP_01',
			hash = GetHashKey('COMPONENT_MARKSMANPISTOL_CLIP_01'),
			model = 'W_PI_SingleShot_Shell',
			type = 'clip',
			default = true
		}
	},
	hasAttachments = true,
	numberOfAttachments = 1
}

config.weapon_marksmanrifle = {
	name = 'weapon_marksmanrifle',
	hash = GetHashKey('WEAPON_MARKSMANRIFLE'),
	clipSize = 8,
	category = 'sniper',
	model = 'w_sr_marksmanrifle',
	ammo = {
		name = 'ammo_sniper',
		hash = GetHashKey('AMMO_SNIPER'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_MARKSMANRIFLE_CLIP_01',
			hash = GetHashKey('COMPONENT_MARKSMANRIFLE_CLIP_01'),
			model = 'w_sr_marksmanrifle_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_MARKSMANRIFLE_CLIP_02',
			hash = GetHashKey('COMPONENT_MARKSMANRIFLE_CLIP_02'),
			model = 'w_sr_marksmanrifle_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_FLSH',
			hash = GetHashKey('COMPONENT_AT_AR_FLSH'),
			model = 'w_at_ar_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM',
			hash = GetHashKey('COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM'),
			model = 'w_at_scope_large',
			type = 'scope',
			default = true
		},
		{
			name = 'COMPONENT_AT_AR_SUPP',
			hash = GetHashKey('COMPONENT_AT_AR_SUPP'),
			model = 'w_at_ar_supp',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_AFGRIP',
			hash = GetHashKey('COMPONENT_AT_AR_AFGRIP'),
			model = 'w_at_ar_afgrip',
			type = 'default',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 6
}

config.weapon_minismg = {
	name = 'weapon_minismg',
	hash = GetHashKey('WEAPON_MINISMG'),
	clipSize = 20,
	category = 'smg',
	model = 'w_sb_minismg',
	ammo = {
		name = 'ammo_smg',
		hash = GetHashKey('AMMO_SMG'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_MINISMG_CLIP_01',
			hash = GetHashKey('COMPONENT_MINISMG_CLIP_01'),
			model = 'w_sb_minismg_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_MINISMG_CLIP_02',
			hash = GetHashKey('COMPONENT_MINISMG_CLIP_02'),
			model = 'w_sb_minismg_mag2',
			type = 'clip',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 2
}

config.weapon_musket = {
	name = 'weapon_musket',
	hash = GetHashKey('WEAPON_MUSKET'),
	clipSize = 1,
	category = 'sniper',
	model = 'w_ar_musket',
	ammo = {
		name = 'ammo_shotgun',
		hash = GetHashKey('AMMO_SHOTGUN'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_MUSKET_CLIP_01',
			hash = GetHashKey('COMPONENT_MUSKET_CLIP_01'),
			model = 'P_CS_Joint_02',
			type = 'clip',
			default = true
		}
	},
	hasAttachments = true,
	numberOfAttachments = 1
}

config.weapon_pipebomb = {
	name = 'weapon_pipebomb',
	hash = GetHashKey('WEAPON_PIPEBOMB'),
	clipSize = 1,
	category = 'thrown',
	model = 'w_ex_pipebomb',
	ammo = {
		name = 'ammo_pipebomb',
		hash = GetHashKey('AMMO_PIPEBOMB'),
		max = 10
	},
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_poolcue = {
	name = 'weapon_poolcue',
	hash = GetHashKey('WEAPON_POOLCUE'),
	clipSize = 0,
	category = 'melee',
	model = 'w_me_poolcue',
	ammo = nil,
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_proxmine = {
	name = 'weapon_proxmine',
	hash = GetHashKey('WEAPON_PROXMINE'),
	clipSize = 1,
	category = 'thrown',
	model = 'w_ex_apmine',
	ammo = {
		name = 'ammo_proxmine',
		hash = GetHashKey('AMMO_PROXMINE'),
		max = 5
	},
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_railgun = {
	name = 'weapon_railgun',
	hash = GetHashKey('WEAPON_RAILGUN'),
	clipSize = 1,
	category = 'heavy',
	model = 'w_ar_railgun',
	ammo = {
		name = 'ammo_railgun',
		hash = GetHashKey('AMMO_RAILGUN'),
		max = 20
	},
	components = {
		{
			name = 'COMPONENT_RAILGUN_CLIP_01',
			hash = GetHashKey('COMPONENT_RAILGUN_CLIP_01'),
			model = 'w_ar_railgun_mag1',
			type = 'clip',
			default = true
		}
	},
	hasAttachments = true,
	numberOfAttachments = 1
}

config.weapon_revolver = {
	name = 'weapon_revolver',
	hash = GetHashKey('WEAPON_REVOLVER'),
	clipSize = 6,
	category = 'pistol',
	model = 'w_pi_revolver',
	ammo = {
		name = 'ammo_pistol',
		hash = GetHashKey('AMMO_PISTOL'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_REVOLVER_CLIP_01',
			hash = GetHashKey('COMPONENT_REVOLVER_CLIP_01'),
			model = 'w_pi_revolver_Mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_REVOLVER_VARMOD_BOSS',
			hash = GetHashKey('COMPONENT_REVOLVER_VARMOD_BOSS'),
			model = 'w_pi_revolver_b',
			type = 'variant',
			default = false
		},
		{
			name = 'COMPONENT_REVOLVER_VARMOD_GOON',
			hash = GetHashKey('COMPONENT_REVOLVER_VARMOD_GOON'),
			model = 'w_pi_revolver_g',
			type = 'variant',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 3
}

config.weapon_unarmed = {
	name = 'weapon_unarmed',
	hash = GetHashKey('WEAPON_UNARMED'),
	clipSize = 0,
	category = 'unarmed',
	model = nil,
	ammo = nil,
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_knife = {
	name = 'weapon_knife',
	hash = GetHashKey('WEAPON_KNIFE'),
	clipSize = 0,
	category = 'melee',
	model = 'w_me_knife_01',
	ammo = nil,
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_nightstick = {
	name = 'weapon_nightstick',
	hash = GetHashKey('WEAPON_NIGHTSTICK'),
	clipSize = 0,
	category = 'melee',
	model = 'w_me_nightstick',
	ammo = nil,
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_hammer = {
	name = 'weapon_hammer',
	hash = GetHashKey('WEAPON_HAMMER'),
	clipSize = 0,
	category = 'melee',
	model = 'w_me_hammer',
	ammo = nil,
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_bat = {
	name = 'weapon_bat',
	hash = GetHashKey('WEAPON_BAT'),
	clipSize = 0,
	category = 'melee',
	model = 'w_me_bat',
	ammo = nil,
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_golfclub = {
	name = 'weapon_golfclub',
	hash = GetHashKey('WEAPON_GOLFCLUB'),
	clipSize = 0,
	category = 'melee',
	model = 'w_me_gclub',
	ammo = nil,
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_crowbar = {
	name = 'weapon_crowbar',
	hash = GetHashKey('WEAPON_CROWBAR'),
	clipSize = 0,
	category = 'melee',
	model = 'w_me_crowbar',
	ammo = nil,
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_pistol = {
	name = 'weapon_pistol',
	hash = GetHashKey('WEAPON_PISTOL'),
	clipSize = 12,
	category = 'pistol',
	model = 'W_PI_PISTOL',
	ammo = {
		name = 'ammo_pistol',
		hash = GetHashKey('AMMO_PISTOL'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_PISTOL_CLIP_01',
			hash = GetHashKey('COMPONENT_PISTOL_CLIP_01'),
			model = 'w_pi_pistol_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_PISTOL_CLIP_02',
			hash = GetHashKey('COMPONENT_PISTOL_CLIP_02'),
			model = 'w_pi_pistol_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_PI_FLSH',
			hash = GetHashKey('COMPONENT_AT_PI_FLSH'),
			model = 'w_at_pi_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_PI_SUPP_02',
			hash = GetHashKey('COMPONENT_AT_PI_SUPP_02'),
			model = 'w_at_pi_supp_2',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL_VARMOD_LUXE',
			hash = GetHashKey('COMPONENT_PISTOL_VARMOD_LUXE'),
			model = 'W_PI_Pistol_Luxe',
			type = 'variant',
			default = false
		},
		{
			name = 'COMPONENT_GUNRUN_MK2_UPGRADE',
			hash = GetHashKey('COMPONENT_GUNRUN_MK2_UPGRADE'),
			model = '',
			type = 'default',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 6
}

config.weapon_combatpistol = {
	name = 'weapon_combatpistol',
	hash = GetHashKey('WEAPON_COMBATPISTOL'),
	clipSize = 12,
	category = 'pistol',
	model = 'W_PI_COMBATPISTOL',
	ammo = {
		name = 'ammo_pistol',
		hash = GetHashKey('AMMO_PISTOL'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_COMBATPISTOL_CLIP_01',
			hash = GetHashKey('COMPONENT_COMBATPISTOL_CLIP_01'),
			model = 'w_pi_combatpistol_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_COMBATPISTOL_CLIP_02',
			hash = GetHashKey('COMPONENT_COMBATPISTOL_CLIP_02'),
			model = 'w_pi_combatpistol_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_PI_FLSH',
			hash = GetHashKey('COMPONENT_AT_PI_FLSH'),
			model = 'w_at_pi_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_PI_SUPP',
			hash = GetHashKey('COMPONENT_AT_PI_SUPP'),
			model = 'w_at_pi_supp',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER',
			hash = GetHashKey('COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER'),
			model = 'w_pi_combatpistol_luxe',
			type = 'variant',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 5
}

config.weapon_appistol = {
	name = 'weapon_appistol',
	hash = GetHashKey('WEAPON_APPISTOL'),
	clipSize = 18,
	category = 'pistol',
	model = 'W_PI_APPISTOL',
	ammo = {
		name = 'ammo_pistol',
		hash = GetHashKey('AMMO_PISTOL'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_APPISTOL_CLIP_01',
			hash = GetHashKey('COMPONENT_APPISTOL_CLIP_01'),
			model = 'w_pi_appistol_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_APPISTOL_CLIP_02',
			hash = GetHashKey('COMPONENT_APPISTOL_CLIP_02'),
			model = 'w_pi_appistol_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_PI_FLSH',
			hash = GetHashKey('COMPONENT_AT_PI_FLSH'),
			model = 'w_at_pi_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_PI_SUPP',
			hash = GetHashKey('COMPONENT_AT_PI_SUPP'),
			model = 'w_at_pi_supp',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_APPISTOL_VARMOD_LUXE',
			hash = GetHashKey('COMPONENT_APPISTOL_VARMOD_LUXE'),
			model = 'W_PI_APPistol_Luxe',
			type = 'variant',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 5
}

config.weapon_pistol50 = {
	name = 'weapon_pistol50',
	hash = GetHashKey('WEAPON_PISTOL50'),
	clipSize = 9,
	category = 'pistol',
	model = 'W_PI_PISTOL50',
	ammo = {
		name = 'ammo_pistol',
		hash = GetHashKey('AMMO_PISTOL'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_PISTOL50_CLIP_01',
			hash = GetHashKey('COMPONENT_PISTOL50_CLIP_01'),
			model = 'W_PI_PISTOL50_Mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_PISTOL50_CLIP_02',
			hash = GetHashKey('COMPONENT_PISTOL50_CLIP_02'),
			model = 'W_PI_PISTOL50_Mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_PI_FLSH',
			hash = GetHashKey('COMPONENT_AT_PI_FLSH'),
			model = 'w_at_pi_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_SUPP_02',
			hash = GetHashKey('COMPONENT_AT_AR_SUPP_02'),
			model = 'w_at_ar_supp_02',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL50_VARMOD_LUXE',
			hash = GetHashKey('COMPONENT_PISTOL50_VARMOD_LUXE'),
			model = 'W_PI_Pistol50_Luxe',
			type = 'variant',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 5
}

config.weapon_microsmg = {
	name = 'weapon_microsmg',
	hash = GetHashKey('WEAPON_MICROSMG'),
	clipSize = 16,
	category = 'smg',
	model = 'w_sb_microsmg',
	ammo = {
		name = 'ammo_smg',
		hash = GetHashKey('AMMO_SMG'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_MICROSMG_CLIP_01',
			hash = GetHashKey('COMPONENT_MICROSMG_CLIP_01'),
			model = 'w_sb_microsmg_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_MICROSMG_CLIP_02',
			hash = GetHashKey('COMPONENT_MICROSMG_CLIP_02'),
			model = 'w_sb_microsmg_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_PI_FLSH',
			hash = GetHashKey('COMPONENT_AT_PI_FLSH'),
			model = 'w_at_pi_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_MACRO',
			hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO'),
			model = 'w_at_scope_macro',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_SUPP_02',
			hash = GetHashKey('COMPONENT_AT_AR_SUPP_02'),
			model = 'w_at_ar_supp_02',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_MICROSMG_VARMOD_LUXE',
			hash = GetHashKey('COMPONENT_MICROSMG_VARMOD_LUXE'),
			model = 'W_SB_MicroSMG_Luxe',
			type = 'variant',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 6
}

config.weapon_smg = {
	name = 'weapon_smg',
	hash = GetHashKey('WEAPON_SMG'),
	clipSize = 30,
	category = 'smg',
	model = 'w_sb_smg',
	ammo = {
		name = 'ammo_smg',
		hash = GetHashKey('AMMO_SMG'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_SMG_CLIP_01',
			hash = GetHashKey('COMPONENT_SMG_CLIP_01'),
			model = 'w_sb_smg_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_SMG_CLIP_02',
			hash = GetHashKey('COMPONENT_SMG_CLIP_02'),
			model = 'w_sb_smg_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_SMG_CLIP_03',
			hash = GetHashKey('COMPONENT_SMG_CLIP_03'),
			model = 'w_sb_smg_boxmag',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_FLSH',
			hash = GetHashKey('COMPONENT_AT_AR_FLSH'),
			model = 'w_at_ar_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_MACRO_02',
			hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_02'),
			model = 'w_at_scope_macro_2',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_PI_SUPP',
			hash = GetHashKey('COMPONENT_AT_PI_SUPP'),
			model = 'w_at_pi_supp',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_SMG_VARMOD_LUXE',
			hash = GetHashKey('COMPONENT_SMG_VARMOD_LUXE'),
			model = 'W_SB_SMG_Luxe',
			type = 'variant',
			default = false
		},
		{
			name = 'COMPONENT_GUNRUN_MK2_UPGRADE',
			hash = GetHashKey('COMPONENT_GUNRUN_MK2_UPGRADE'),
			model = '',
			type = 'default',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 8
}

config.weapon_assaultsmg = {
	name = 'weapon_assaultsmg',
	hash = GetHashKey('WEAPON_ASSAULTSMG'),
	clipSize = 30,
	category = 'smg',
	model = 'w_sb_assaultsmg',
	ammo = {
		name = 'ammo_smg',
		hash = GetHashKey('AMMO_SMG'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_ASSAULTSMG_CLIP_01',
			hash = GetHashKey('COMPONENT_ASSAULTSMG_CLIP_01'),
			model = 'W_SB_ASSAULTSMG_Mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_ASSAULTSMG_CLIP_02',
			hash = GetHashKey('COMPONENT_ASSAULTSMG_CLIP_02'),
			model = 'W_SB_ASSAULTSMG_Mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_FLSH',
			hash = GetHashKey('COMPONENT_AT_AR_FLSH'),
			model = 'w_at_ar_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_MACRO',
			hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO'),
			model = 'w_at_scope_macro',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_SUPP_02',
			hash = GetHashKey('COMPONENT_AT_AR_SUPP_02'),
			model = 'w_at_ar_supp_02',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER',
			hash = GetHashKey('COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER'),
			model = 'w_sb_assaultsmg_luxe',
			type = 'variant',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 6
}

config.weapon_assaultrifle = {
	name = 'weapon_assaultrifle',
	hash = GetHashKey('WEAPON_ASSAULTRIFLE'),
	clipSize = 30,
	category = 'rifle',
	model = 'W_AR_ASSAULTRIFLE',
	ammo = {
		name = 'ammo_rifle',
		hash = GetHashKey('AMMO_RIFLE'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_ASSAULTRIFLE_CLIP_01',
			hash = GetHashKey('COMPONENT_ASSAULTRIFLE_CLIP_01'),
			model = 'w_ar_assaultrifle_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_ASSAULTRIFLE_CLIP_02',
			hash = GetHashKey('COMPONENT_ASSAULTRIFLE_CLIP_02'),
			model = 'w_ar_assaultrifle_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_ASSAULTRIFLE_CLIP_03',
			hash = GetHashKey('COMPONENT_ASSAULTRIFLE_CLIP_03'),
			model = 'w_ar_assaultrifle_boxmag',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_FLSH',
			hash = GetHashKey('COMPONENT_AT_AR_FLSH'),
			model = 'w_at_ar_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_MACRO',
			hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO'),
			model = 'w_at_scope_macro',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_SUPP_02',
			hash = GetHashKey('COMPONENT_AT_AR_SUPP_02'),
			model = 'w_at_ar_supp_02',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_AFGRIP',
			hash = GetHashKey('COMPONENT_AT_AR_AFGRIP'),
			model = 'w_at_ar_afgrip',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_ASSAULTRIFLE_VARMOD_LUXE',
			hash = GetHashKey('COMPONENT_ASSAULTRIFLE_VARMOD_LUXE'),
			model = 'W_AR_AssaultRifle_Luxe',
			type = 'variant',
			default = false
		},
		{
			name = 'COMPONENT_GUNRUN_MK2_UPGRADE',
			hash = GetHashKey('COMPONENT_GUNRUN_MK2_UPGRADE'),
			model = '',
			type = 'default',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 9
}

config.weapon_carbinerifle = {
	name = 'weapon_carbinerifle',
	hash = GetHashKey('WEAPON_CARBINERIFLE'),
	clipSize = 30,
	category = 'rifle',
	model = 'W_AR_CARBINERIFLE',
	ammo = {
		name = 'ammo_rifle',
		hash = GetHashKey('AMMO_RIFLE'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_CARBINERIFLE_CLIP_01',
			hash = GetHashKey('COMPONENT_CARBINERIFLE_CLIP_01'),
			model = 'w_ar_carbinerifle_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_CARBINERIFLE_CLIP_02',
			hash = GetHashKey('COMPONENT_CARBINERIFLE_CLIP_02'),
			model = 'w_ar_carbinerifle_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_CARBINERIFLE_CLIP_03',
			hash = GetHashKey('COMPONENT_CARBINERIFLE_CLIP_03'),
			model = 'w_ar_carbinerifle_boxmag',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_FLSH',
			hash = GetHashKey('COMPONENT_AT_AR_FLSH'),
			model = 'w_at_ar_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_RAILCOVER_01',
			hash = GetHashKey('COMPONENT_AT_RAILCOVER_01'),
			model = 'w_at_railcover_01',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_MEDIUM',
			hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM'),
			model = 'w_at_scope_medium',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_SUPP',
			hash = GetHashKey('COMPONENT_AT_AR_SUPP'),
			model = 'w_at_ar_supp',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_AFGRIP',
			hash = GetHashKey('COMPONENT_AT_AR_AFGRIP'),
			model = 'w_at_ar_afgrip',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_CARBINERIFLE_VARMOD_LUXE',
			hash = GetHashKey('COMPONENT_CARBINERIFLE_VARMOD_LUXE'),
			model = 'W_AR_CarbineRifle_Luxe',
			type = 'variant',
			default = false
		},
		{
			name = 'COMPONENT_GUNRUN_MK2_UPGRADE',
			hash = GetHashKey('COMPONENT_GUNRUN_MK2_UPGRADE'),
			model = '',
			type = 'default',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 10
}

config.weapon_advancedrifle = {
	name = 'weapon_advancedrifle',
	hash = GetHashKey('WEAPON_ADVANCEDRIFLE'),
	clipSize = 30,
	category = 'rifle',
	model = 'W_AR_ADVANCEDRIFLE',
	ammo = {
		name = 'ammo_rifle',
		hash = GetHashKey('AMMO_RIFLE'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_ADVANCEDRIFLE_CLIP_01',
			hash = GetHashKey('COMPONENT_ADVANCEDRIFLE_CLIP_01'),
			model = 'w_ar_advancedrifle_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_ADVANCEDRIFLE_CLIP_02',
			hash = GetHashKey('COMPONENT_ADVANCEDRIFLE_CLIP_02'),
			model = 'w_ar_advancedrifle_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_FLSH',
			hash = GetHashKey('COMPONENT_AT_AR_FLSH'),
			model = 'w_at_ar_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_SMALL',
			hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL'),
			model = 'w_at_scope_small',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_SUPP',
			hash = GetHashKey('COMPONENT_AT_AR_SUPP'),
			model = 'w_at_ar_supp',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE',
			hash = GetHashKey('COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE'),
			model = 'W_AR_AdvancedRifle_Luxe',
			type = 'variant',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 6
}

config.weapon_mg = {
	name = 'weapon_mg',
	hash = GetHashKey('WEAPON_MG'),
	clipSize = 54,
	category = 'mg',
	model = 'w_mg_mg',
	ammo = {
		name = 'ammo_mg',
		hash = GetHashKey('AMMO_MG'),
		max = 500
	},
	components = {
		{
			name = 'COMPONENT_MG_CLIP_01',
			hash = GetHashKey('COMPONENT_MG_CLIP_01'),
			model = 'w_mg_mg_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_MG_CLIP_02',
			hash = GetHashKey('COMPONENT_MG_CLIP_02'),
			model = 'w_mg_mg_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_SMALL_02',
			hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL_02'),
			model = 'w_at_scope_small_2',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_MG_VARMOD_LOWRIDER',
			hash = GetHashKey('COMPONENT_MG_VARMOD_LOWRIDER'),
			model = 'w_mg_mg_luxe',
			type = 'variant',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 4
}

config.weapon_combatmg = {
	name = 'weapon_combatmg',
	hash = GetHashKey('WEAPON_COMBATMG'),
	clipSize = 100,
	category = 'mg',
	model = 'w_mg_combatmg',
	ammo = {
		name = 'ammo_mg',
		hash = GetHashKey('AMMO_MG'),
		max = 500
	},
	components = {
		{
			name = 'COMPONENT_COMBATMG_CLIP_01',
			hash = GetHashKey('COMPONENT_COMBATMG_CLIP_01'),
			model = 'w_mg_combatmg_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_COMBATMG_CLIP_02',
			hash = GetHashKey('COMPONENT_COMBATMG_CLIP_02'),
			model = 'w_mg_combatmg_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_MEDIUM',
			hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM'),
			model = 'w_at_scope_medium',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_AFGRIP',
			hash = GetHashKey('COMPONENT_AT_AR_AFGRIP'),
			model = 'w_at_ar_afgrip',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_COMBATMG_VARMOD_LOWRIDER',
			hash = GetHashKey('COMPONENT_COMBATMG_VARMOD_LOWRIDER'),
			model = 'w_mg_combatmg_luxe',
			type = 'variant',
			default = false
		},
		{
			name = 'COMPONENT_GUNRUN_MK2_UPGRADE',
			hash = GetHashKey('COMPONENT_GUNRUN_MK2_UPGRADE'),
			model = '',
			type = 'default',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 6
}

config.weapon_pumpshotgun = {
	name = 'weapon_pumpshotgun',
	hash = GetHashKey('WEAPON_PUMPSHOTGUN'),
	clipSize = 8,
	category = 'shotgun',
	model = 'w_sg_pumpshotgun',
	ammo = {
		name = 'ammo_shotgun',
		hash = GetHashKey('AMMO_SHOTGUN'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_PUMPSHOTGUN_CLIP_01',
			hash = GetHashKey('COMPONENT_PUMPSHOTGUN_CLIP_01'),
			model = '',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_AT_AR_FLSH',
			hash = GetHashKey('COMPONENT_AT_AR_FLSH'),
			model = 'w_at_ar_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_SR_SUPP',
			hash = GetHashKey('COMPONENT_AT_SR_SUPP'),
			model = 'w_at_sr_supp_2',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER',
			hash = GetHashKey('COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER'),
			model = 'w_sg_pumpshotgun_luxe',
			type = 'variant',
			default = false
		},
		{
			name = 'COMPONENT_GUNRUN_MK2_UPGRADE',
			hash = GetHashKey('COMPONENT_GUNRUN_MK2_UPGRADE'),
			model = '',
			type = 'default',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 5
}

config.weapon_sawnoffshotgun = {
	name = 'weapon_sawnoffshotgun',
	hash = GetHashKey('WEAPON_SAWNOFFSHOTGUN'),
	clipSize = 8,
	category = 'shotgun',
	model = 'w_sg_sawnoff',
	ammo = {
		name = 'ammo_shotgun',
		hash = GetHashKey('AMMO_SHOTGUN'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_SAWNOFFSHOTGUN_CLIP_01',
			hash = GetHashKey('COMPONENT_SAWNOFFSHOTGUN_CLIP_01'),
			model = '',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE',
			hash = GetHashKey('COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE'),
			model = 'W_SG_Sawnoff_Luxe',
			type = 'variant',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 2
}

config.weapon_assaultshotgun = {
	name = 'weapon_assaultshotgun',
	hash = GetHashKey('WEAPON_ASSAULTSHOTGUN'),
	clipSize = 8,
	category = 'shotgun',
	model = 'w_sg_assaultshotgun',
	ammo = {
		name = 'ammo_shotgun',
		hash = GetHashKey('AMMO_SHOTGUN'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_ASSAULTSHOTGUN_CLIP_01',
			hash = GetHashKey('COMPONENT_ASSAULTSHOTGUN_CLIP_01'),
			model = 'w_sg_assaultshotgun_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_ASSAULTSHOTGUN_CLIP_02',
			hash = GetHashKey('COMPONENT_ASSAULTSHOTGUN_CLIP_02'),
			model = 'w_sg_assaultshotgun_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_FLSH',
			hash = GetHashKey('COMPONENT_AT_AR_FLSH'),
			model = 'w_at_ar_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_SUPP',
			hash = GetHashKey('COMPONENT_AT_AR_SUPP'),
			model = 'w_at_ar_supp',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_AFGRIP',
			hash = GetHashKey('COMPONENT_AT_AR_AFGRIP'),
			model = 'w_at_ar_afgrip',
			type = 'default',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 5
}

config.weapon_bullpupshotgun = {
	name = 'weapon_bullpupshotgun',
	hash = GetHashKey('WEAPON_BULLPUPSHOTGUN'),
	clipSize = 14,
	category = 'shotgun',
	model = 'w_sg_bullpupshotgun',
	ammo = {
		name = 'ammo_shotgun',
		hash = GetHashKey('AMMO_SHOTGUN'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_BULLPUPSHOTGUN_CLIP_01',
			hash = GetHashKey('COMPONENT_BULLPUPSHOTGUN_CLIP_01'),
			model = '',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_AT_AR_FLSH',
			hash = GetHashKey('COMPONENT_AT_AR_FLSH'),
			model = 'w_at_ar_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_SUPP_02',
			hash = GetHashKey('COMPONENT_AT_AR_SUPP_02'),
			model = 'w_at_ar_supp_02',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_AFGRIP',
			hash = GetHashKey('COMPONENT_AT_AR_AFGRIP'),
			model = 'w_at_ar_afgrip',
			type = 'default',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 4
}

config.weapon_stungun = {
	name = 'weapon_stungun',
	hash = GetHashKey('WEAPON_STUNGUN'),
	clipSize = 2104529083,
	category = 'stungun',
	model = 'w_pi_stungun',
	ammo = {
		name = 'ammo_stungun',
		hash = GetHashKey('AMMO_STUNGUN'),
		max = 250
	},
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_sniperrifle = {
	name = 'weapon_sniperrifle',
	hash = GetHashKey('WEAPON_SNIPERRIFLE'),
	clipSize = 10,
	category = 'sniper',
	model = 'w_sr_sniperrifle',
	ammo = {
		name = 'ammo_sniper',
		hash = GetHashKey('AMMO_SNIPER'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_SNIPERRIFLE_CLIP_01',
			hash = GetHashKey('COMPONENT_SNIPERRIFLE_CLIP_01'),
			model = 'w_sr_sniperrifle_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_AT_AR_SUPP_02',
			hash = GetHashKey('COMPONENT_AT_AR_SUPP_02'),
			model = 'w_at_ar_supp_02',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_LARGE',
			hash = GetHashKey('COMPONENT_AT_SCOPE_LARGE'),
			model = 'w_at_scope_large',
			type = 'scope',
			default = true
		},
		{
			name = 'COMPONENT_AT_SCOPE_MAX',
			hash = GetHashKey('COMPONENT_AT_SCOPE_MAX'),
			model = 'w_at_scope_max',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_SNIPERRIFLE_VARMOD_LUXE',
			hash = GetHashKey('COMPONENT_SNIPERRIFLE_VARMOD_LUXE'),
			model = 'W_SR_SniperRifle_Luxe',
			type = 'variant',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 5
}

config.weapon_heavysniper = {
	name = 'weapon_heavysniper',
	hash = GetHashKey('WEAPON_HEAVYSNIPER'),
	clipSize = 6,
	category = 'sniper',
	model = 'w_sr_heavysniper',
	ammo = {
		name = 'ammo_sniper',
		hash = GetHashKey('AMMO_SNIPER'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_HEAVYSNIPER_CLIP_01',
			hash = GetHashKey('COMPONENT_HEAVYSNIPER_CLIP_01'),
			model = 'w_sr_heavysniper_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_AT_SCOPE_LARGE',
			hash = GetHashKey('COMPONENT_AT_SCOPE_LARGE'),
			model = 'w_at_scope_large',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_MAX',
			hash = GetHashKey('COMPONENT_AT_SCOPE_MAX'),
			model = 'w_at_scope_max',
			type = 'scope',
			default = true
		},
		{
			name = 'COMPONENT_GUNRUN_MK2_UPGRADE',
			hash = GetHashKey('COMPONENT_GUNRUN_MK2_UPGRADE'),
			model = '',
			type = 'default',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 4
}

config.weapon_grenadelauncher = {
	name = 'weapon_grenadelauncher',
	hash = GetHashKey('WEAPON_GRENADELAUNCHER'),
	clipSize = 10,
	category = 'heavy',
	model = 'w_lr_grenadelauncher',
	ammo = {
		name = 'ammo_grenadelauncher',
		hash = GetHashKey('AMMO_GRENADELAUNCHER'),
		max = 20
	},
	components = {
		{
			name = 'COMPONENT_GRENADELAUNCHER_CLIP_01',
			hash = GetHashKey('COMPONENT_GRENADELAUNCHER_CLIP_01'),
			model = 'w_lr_40mm',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_AT_AR_FLSH',
			hash = GetHashKey('COMPONENT_AT_AR_FLSH'),
			model = 'w_at_ar_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_AFGRIP',
			hash = GetHashKey('COMPONENT_AT_AR_AFGRIP'),
			model = 'w_at_ar_afgrip',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_SMALL',
			hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL'),
			model = 'w_at_scope_small',
			type = 'scope',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 4
}

config.weapon_grenadelauncher_smoke = {
	name = 'weapon_grenadelauncher_smoke',
	hash = GetHashKey('WEAPON_GRENADELAUNCHER_SMOKE'),
	clipSize = 10,
	category = 'heavy',
	model = 'w_lr_grenadelauncher',
	ammo = {
		name = 'ammo_grenadelauncher_smoke',
		hash = GetHashKey('AMMO_GRENADELAUNCHER_SMOKE'),
		max = 20
	},
	components = {
		{
			name = 'COMPONENT_AT_AR_FLSH',
			hash = GetHashKey('COMPONENT_AT_AR_FLSH'),
			model = 'w_at_ar_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_AFGRIP',
			hash = GetHashKey('COMPONENT_AT_AR_AFGRIP'),
			model = 'w_at_ar_afgrip',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_SMALL',
			hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL'),
			model = 'w_at_scope_small',
			type = 'scope',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 3
}

config.weapon_rpg = {
	name = 'weapon_rpg',
	hash = GetHashKey('WEAPON_RPG'),
	clipSize = 1,
	category = 'heavy',
	model = 'w_lr_rpg',
	ammo = {
		name = 'ammo_rpg',
		hash = GetHashKey('AMMO_RPG'),
		max = 20
	},
	components = {
		{
			name = 'COMPONENT_RPG_CLIP_01',
			hash = GetHashKey('COMPONENT_RPG_CLIP_01'),
			model = '',
			type = 'clip',
			default = true
		}
	},
	hasAttachments = true,
	numberOfAttachments = 1
}

config.weapon_minigun = {
	name = 'weapon_minigun',
	hash = GetHashKey('WEAPON_MINIGUN'),
	clipSize = 15000,
	category = 'heavy',
	model = 'w_mg_minigun',
	ammo = {
		name = 'ammo_minigun',
		hash = GetHashKey('AMMO_MINIGUN'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_MINIGUN_CLIP_01',
			hash = GetHashKey('COMPONENT_MINIGUN_CLIP_01'),
			model = '',
			type = 'clip',
			default = true
		}
	},
	hasAttachments = true,
	numberOfAttachments = 1
}

config.weapon_grenade = {
	name = 'weapon_grenade',
	hash = GetHashKey('WEAPON_GRENADE'),
	clipSize = 1,
	category = 'thrown',
	model = 'w_ex_grenadefrag',
	ammo = {
		name = 'ammo_grenade',
		hash = GetHashKey('AMMO_GRENADE'),
		max = 25
	},
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_stickybomb = {
	name = 'weapon_stickybomb',
	hash = GetHashKey('WEAPON_STICKYBOMB'),
	clipSize = 1,
	category = 'thrown',
	model = 'w_ex_pe',
	ammo = {
		name = 'ammo_stickybomb',
		hash = GetHashKey('AMMO_STICKYBOMB'),
		max = 25
	},
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_smokegrenade = {
	name = 'weapon_smokegrenade',
	hash = GetHashKey('WEAPON_SMOKEGRENADE'),
	clipSize = 1,
	category = 'thrown',
	model = 'w_ex_grenadesmoke',
	ammo = {
		name = 'ammo_smokegrenade',
		hash = GetHashKey('AMMO_SMOKEGRENADE'),
		max = 25
	},
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_bzgas = {
	name = 'weapon_bzgas',
	hash = GetHashKey('WEAPON_BZGAS'),
	clipSize = 1,
	category = 'thrown',
	model = 'w_ex_grenadesmoke',
	ammo = {
		name = 'ammo_bzgas',
		hash = GetHashKey('AMMO_BZGAS'),
		max = 25
	},
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_molotov = {
	name = 'weapon_molotov',
	hash = GetHashKey('WEAPON_MOLOTOV'),
	clipSize = 1,
	category = 'thrown',
	model = 'w_ex_molotov',
	ammo = {
		name = 'ammo_molotov',
		hash = GetHashKey('AMMO_MOLOTOV'),
		max = 25
	},
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_fireextinguisher = {
	name = 'weapon_fireextinguisher',
	hash = GetHashKey('WEAPON_FIREEXTINGUISHER'),
	clipSize = 2000,
	category = 'fireextinguisher',
	model = 'w_am_fire_exting',
	ammo = {
		name = 'ammo_fireextinguisher',
		hash = GetHashKey('AMMO_FIREEXTINGUISHER'),
		max = 2000
	},
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_petrolcan = {
	name = 'weapon_petrolcan',
	hash = GetHashKey('WEAPON_PETROLCAN'),
	clipSize = 4500,
	category = 'petrolcan',
	model = 'w_am_jerrycan',
	ammo = {
		name = 'ammo_petrolcan',
		hash = GetHashKey('AMMO_PETROLCAN'),
		max = 4500
	},
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.gadget_parachute = {
	name = 'gadget_parachute',
	hash = GetHashKey('GADGET_PARACHUTE'),
	clipSize = 0,
	category = 'parachute',
	model = nil,
	ammo = nil,
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_ball = {
	name = 'weapon_ball',
	hash = GetHashKey('WEAPON_BALL'),
	clipSize = 1,
	category = 'thrown',
	model = 'w_am_baseball',
	ammo = {
		name = 'ammo_ball',
		hash = GetHashKey('AMMO_BALL'),
		max = 1
	},
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_flare = {
	name = 'weapon_flare',
	hash = GetHashKey('WEAPON_FLARE'),
	clipSize = 1,
	category = 'thrown',
	model = 'w_am_flare',
	ammo = {
		name = 'ammo_flare',
		hash = GetHashKey('AMMO_FLARE'),
		max = 25
	},
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_snowball = {
	name = 'weapon_snowball',
	hash = GetHashKey('WEAPON_SNOWBALL'),
	clipSize = 1,
	category = 'thrown',
	model = 'w_ex_snowball',
	ammo = {
		name = 'ammo_snowball',
		hash = GetHashKey('AMMO_SNOWBALL'),
		max = 10
	},
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_snspistol = {
	name = 'weapon_snspistol',
	hash = GetHashKey('WEAPON_SNSPISTOL'),
	clipSize = 6,
	category = 'pistol',
	model = 'w_pi_sns_pistol',
	ammo = {
		name = 'ammo_pistol',
		hash = GetHashKey('AMMO_PISTOL'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_SNSPISTOL_CLIP_01',
			hash = GetHashKey('COMPONENT_SNSPISTOL_CLIP_01'),
			model = 'w_pi_sns_pistol_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_SNSPISTOL_CLIP_02',
			hash = GetHashKey('COMPONENT_SNSPISTOL_CLIP_02'),
			model = 'w_pi_sns_pistol_mag2',
			type = 'clip',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 2
}

config.weapon_specialcarbine = {
	name = 'weapon_specialcarbine',
	hash = GetHashKey('WEAPON_SPECIALCARBINE'),
	clipSize = 30,
	category = 'rifle',
	model = 'w_ar_specialcarbine',
	ammo = {
		name = 'ammo_rifle',
		hash = GetHashKey('AMMO_RIFLE'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_SPECIALCARBINE_CLIP_01',
			hash = GetHashKey('COMPONENT_SPECIALCARBINE_CLIP_01'),
			model = 'w_ar_specialcarbine_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_SPECIALCARBINE_CLIP_02',
			hash = GetHashKey('COMPONENT_SPECIALCARBINE_CLIP_02'),
			model = 'w_ar_specialcarbine_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_FLSH',
			hash = GetHashKey('COMPONENT_AT_AR_FLSH'),
			model = 'w_at_ar_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_MEDIUM',
			hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM'),
			model = 'w_at_scope_medium',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_SUPP_02',
			hash = GetHashKey('COMPONENT_AT_AR_SUPP_02'),
			model = 'w_at_ar_supp_02',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_AFGRIP',
			hash = GetHashKey('COMPONENT_AT_AR_AFGRIP'),
			model = 'w_at_ar_afgrip',
			type = 'default',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 6
}

config.weapon_stone_hatchet = {
	name = 'weapon_stone_hatchet',
	hash = GetHashKey('WEAPON_STONE_HATCHET'),
	clipSize = 0,
	category = 'melee',
	model = 'w_me_stonehatchet',
	ammo = nil,
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_switchblade = {
	name = 'weapon_switchblade',
	hash = GetHashKey('WEAPON_SWITCHBLADE'),
	clipSize = 0,
	category = 'melee',
	model = 'w_me_switchblade',
	ammo = nil,
	components = {
		{
			name = 'COMPONENT_SWITCHBLADE_VARMOD_BASE',
			hash = GetHashKey('COMPONENT_SWITCHBLADE_VARMOD_BASE'),
			model = 'w_me_switchblade',
			type = 'variant',
			default = false
		},
		{
			name = 'COMPONENT_SWITCHBLADE_VARMOD_VAR1',
			hash = GetHashKey('COMPONENT_SWITCHBLADE_VARMOD_VAR1'),
			model = 'w_me_switchblade_b',
			type = 'variant',
			default = false
		},
		{
			name = 'COMPONENT_SWITCHBLADE_VARMOD_VAR2',
			hash = GetHashKey('COMPONENT_SWITCHBLADE_VARMOD_VAR2'),
			model = 'w_me_switchblade_g',
			type = 'variant',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 3
}

config.weapon_assaultrifle_mk2 = {
	name = 'weapon_assaultrifle_mk2',
	hash = GetHashKey('WEAPON_ASSAULTRIFLE_MK2'),
	clipSize = 30,
	category = 'rifle',
	model = 'w_ar_assaultriflemk2',
	ammo = {
		name = 'ammo_rifle',
		hash = GetHashKey('AMMO_RIFLE'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_ASSAULTRIFLE_MK2_CLIP_01',
			hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CLIP_01'),
			model = 'w_ar_assaultriflemk2_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_ASSAULTRIFLE_MK2_CLIP_02',
			hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CLIP_02'),
			model = 'w_ar_assaultriflemk2_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_ASSAULTRIFLE_MK2_CLIP_ARMORPIERCING',
			hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CLIP_ARMORPIERCING'),
			model = 'w_ar_assaultriflemk2_mag_ap',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_ASSAULTRIFLE_MK2_CLIP_FMJ',
			hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CLIP_FMJ'),
			model = 'w_ar_assaultriflemk2_mag_fmj',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_ASSAULTRIFLE_MK2_CLIP_INCENDIARY',
			hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CLIP_INCENDIARY'),
			model = 'w_ar_assaultriflemk2_mag_inc',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_ASSAULTRIFLE_MK2_CLIP_TRACER',
			hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CLIP_TRACER'),
			model = 'w_ar_assaultriflemk2_mag_tr',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_FLSH',
			hash = GetHashKey('COMPONENT_AT_AR_FLSH'),
			model = 'w_at_ar_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_SIGHTS',
			hash = GetHashKey('COMPONENT_AT_SIGHTS'),
			model = 'w_at_sights_1',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_MACRO_MK2',
			hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_MK2'),
			model = 'w_at_scope_macro',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_MEDIUM_MK2',
			hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM_MK2'),
			model = 'w_at_scope_medium_2',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_SUPP_02',
			hash = GetHashKey('COMPONENT_AT_AR_SUPP_02'),
			model = 'w_at_ar_supp_02',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_01',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_01'),
			model = 'w_at_muzzle_1',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_02',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_02'),
			model = 'w_at_muzzle_2',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_03',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_03'),
			model = 'w_at_muzzle_3',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_04',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_04'),
			model = 'w_at_muzzle_4',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_05',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_05'),
			model = 'w_at_muzzle_5',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_06',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_06'),
			model = 'w_at_muzzle_6',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_07',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_07'),
			model = 'w_at_muzzle_7',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_AFGRIP_02',
			hash = GetHashKey('COMPONENT_AT_AR_AFGRIP_02'),
			model = 'w_at_afgrip_2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_BARREL_01',
			hash = GetHashKey('COMPONENT_AT_AR_BARREL_01'),
			model = 'w_at_ar_barrel_1',
			type = 'default',
			default = true
		},
		{
			name = 'COMPONENT_AT_AR_BARREL_02',
			hash = GetHashKey('COMPONENT_AT_AR_BARREL_02'),
			model = 'w_at_ar_barrel_2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_ASSAULTRIFLE_MK2_CAMO',
			hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO'),
			model = 'w_at_armk2_camo1',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_ASSAULTRIFLE_MK2_CAMO_02',
			hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_02'),
			model = 'w_at_armk2_camo2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_ASSAULTRIFLE_MK2_CAMO_03',
			hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_03'),
			model = 'w_at_armk2_camo3',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_ASSAULTRIFLE_MK2_CAMO_04',
			hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_04'),
			model = 'w_at_armk2_camo4',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_ASSAULTRIFLE_MK2_CAMO_05',
			hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_05'),
			model = 'w_at_armk2_camo5',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_ASSAULTRIFLE_MK2_CAMO_06',
			hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_06'),
			model = 'w_at_armk2_camo6',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_ASSAULTRIFLE_MK2_CAMO_07',
			hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_07'),
			model = 'w_at_armk2_camo7',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_ASSAULTRIFLE_MK2_CAMO_08',
			hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_08'),
			model = 'w_at_armk2_camo8',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_ASSAULTRIFLE_MK2_CAMO_09',
			hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_09'),
			model = 'w_at_armk2_camo9',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_ASSAULTRIFLE_MK2_CAMO_10',
			hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_10'),
			model = 'w_at_armk2_camo10',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_ASSAULTRIFLE_MK2_CAMO_IND_01',
			hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_IND_01'),
			model = 'w_at_armk2_camo_ind1',
			type = 'default',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 32
}

config.weapon_bullpuprifle_mk2 = {
	name = 'weapon_bullpuprifle_mk2',
	hash = GetHashKey('WEAPON_BULLPUPRIFLE_MK2'),
	clipSize = 30,
	category = 'rifle',
	model = 'w_ar_bullpupriflemk2',
	ammo = {
		name = 'ammo_rifle',
		hash = GetHashKey('AMMO_RIFLE'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_BULLPUPRIFLE_MK2_CLIP_01',
			hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CLIP_01'),
			model = 'w_ar_bullpupriflemk2_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_BULLPUPRIFLE_MK2_CLIP_02',
			hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CLIP_02'),
			model = 'w_ar_bullpupriflemk2_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_BULLPUPRIFLE_MK2_CLIP_TRACER',
			hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CLIP_TRACER'),
			model = 'W_AR_BullpupRifleMK2_Mag_TR',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_BULLPUPRIFLE_MK2_CLIP_INCENDIARY',
			hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CLIP_INCENDIARY'),
			model = 'W_AR_BullpupRifleMK2_Mag_INC',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_BULLPUPRIFLE_MK2_CLIP_ARMORPIERCING',
			hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CLIP_ARMORPIERCING'),
			model = 'W_AR_BullpupRifleMK2_Mag_AP',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_BULLPUPRIFLE_MK2_CLIP_FMJ',
			hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CLIP_FMJ'),
			model = 'W_AR_BullpupRifleMK2_Mag_FMJ',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_FLSH',
			hash = GetHashKey('COMPONENT_AT_AR_FLSH'),
			model = 'w_at_ar_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_SIGHTS',
			hash = GetHashKey('COMPONENT_AT_SIGHTS'),
			model = 'w_at_sights_1',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_MACRO_02_MK2',
			hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_02_MK2'),
			model = 'w_at_scope_macro_2',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_SMALL_MK2',
			hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL_MK2'),
			model = 'w_at_scope_small',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_BP_BARREL_01',
			hash = GetHashKey('COMPONENT_AT_BP_BARREL_01'),
			model = 'W_AR_BP_MK2_Barrel1',
			type = 'default',
			default = true
		},
		{
			name = 'COMPONENT_AT_BP_BARREL_02',
			hash = GetHashKey('COMPONENT_AT_BP_BARREL_02'),
			model = 'W_AR_BP_MK2_Barrel2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_SUPP',
			hash = GetHashKey('COMPONENT_AT_AR_SUPP'),
			model = 'w_at_ar_supp',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_01',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_01'),
			model = 'w_at_muzzle_1',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_02',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_02'),
			model = 'w_at_muzzle_2',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_03',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_03'),
			model = 'w_at_muzzle_3',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_04',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_04'),
			model = 'w_at_muzzle_4',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_05',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_05'),
			model = 'w_at_muzzle_5',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_06',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_06'),
			model = 'w_at_muzzle_6',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_07',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_07'),
			model = 'w_at_muzzle_7',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_AFGRIP_02',
			hash = GetHashKey('COMPONENT_AT_AR_AFGRIP_02'),
			model = 'w_at_afgrip_2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_BULLPUPRIFLE_MK2_CAMO',
			hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO'),
			model = 'w_ar_bullpupriflemk2_camo1',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_BULLPUPRIFLE_MK2_CAMO_02',
			hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_02'),
			model = 'w_ar_bullpupriflemk2_camo2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_BULLPUPRIFLE_MK2_CAMO_03',
			hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_03'),
			model = 'w_ar_bullpupriflemk2_camo3',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_BULLPUPRIFLE_MK2_CAMO_04',
			hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_04'),
			model = 'w_ar_bullpupriflemk2_camo4',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_BULLPUPRIFLE_MK2_CAMO_05',
			hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_05'),
			model = 'w_ar_bullpupriflemk2_camo5',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_BULLPUPRIFLE_MK2_CAMO_06',
			hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_06'),
			model = 'w_ar_bullpupriflemk2_camo6',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_BULLPUPRIFLE_MK2_CAMO_07',
			hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_07'),
			model = 'w_ar_bullpupriflemk2_camo7',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_BULLPUPRIFLE_MK2_CAMO_08',
			hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_08'),
			model = 'w_ar_bullpupriflemk2_camo8',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_BULLPUPRIFLE_MK2_CAMO_09',
			hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_09'),
			model = 'w_ar_bullpupriflemk2_camo9',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_BULLPUPRIFLE_MK2_CAMO_10',
			hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_10'),
			model = 'w_ar_bullpupriflemk2_camo10',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_BULLPUPRIFLE_MK2_CAMO_IND_01',
			hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_IND_01'),
			model = 'w_ar_bullpupriflemk2_camo_ind1',
			type = 'default',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 32
}

config.weapon_carbinerifle_mk2 = {
	name = 'weapon_carbinerifle_mk2',
	hash = GetHashKey('WEAPON_CARBINERIFLE_MK2'),
	clipSize = 30,
	category = 'rifle',
	model = 'w_ar_carbineriflemk2',
	ammo = {
		name = 'ammo_rifle',
		hash = GetHashKey('AMMO_RIFLE'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_CARBINERIFLE_MK2_CLIP_01',
			hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CLIP_01'),
			model = 'w_ar_carbineriflemk2_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_CARBINERIFLE_MK2_CLIP_02',
			hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CLIP_02'),
			model = 'w_ar_carbineriflemk2_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_CARBINERIFLE_MK2_CLIP_ARMORPIERCING',
			hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CLIP_ARMORPIERCING'),
			model = 'w_ar_carbineriflemk2_mag_ap',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_CARBINERIFLE_MK2_CLIP_FMJ',
			hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CLIP_FMJ'),
			model = 'w_ar_carbineriflemk2_mag_fmj',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_CARBINERIFLE_MK2_CLIP_INCENDIARY',
			hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CLIP_INCENDIARY'),
			model = 'w_ar_carbineriflemk2_mag_inc',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_CARBINERIFLE_MK2_CLIP_TRACER',
			hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CLIP_TRACER'),
			model = 'w_ar_carbineriflemk2_mag_tr',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_FLSH',
			hash = GetHashKey('COMPONENT_AT_AR_FLSH'),
			model = 'w_at_ar_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_SIGHTS',
			hash = GetHashKey('COMPONENT_AT_SIGHTS'),
			model = 'w_at_sights_1',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_MACRO_MK2',
			hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_MK2'),
			model = 'w_at_scope_macro',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_MEDIUM_MK2',
			hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM_MK2'),
			model = 'w_at_scope_medium_2',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_SUPP',
			hash = GetHashKey('COMPONENT_AT_AR_SUPP'),
			model = 'w_at_ar_supp',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_01',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_01'),
			model = 'w_at_muzzle_1',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_02',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_02'),
			model = 'w_at_muzzle_2',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_03',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_03'),
			model = 'w_at_muzzle_3',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_04',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_04'),
			model = 'w_at_muzzle_4',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_05',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_05'),
			model = 'w_at_muzzle_5',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_06',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_06'),
			model = 'w_at_muzzle_6',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_07',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_07'),
			model = 'w_at_muzzle_7',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_AFGRIP_02',
			hash = GetHashKey('COMPONENT_AT_AR_AFGRIP_02'),
			model = 'w_at_afgrip_2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_AT_CR_BARREL_01',
			hash = GetHashKey('COMPONENT_AT_CR_BARREL_01'),
			model = 'w_at_cr_barrel_1',
			type = 'default',
			default = true
		},
		{
			name = 'COMPONENT_AT_CR_BARREL_02',
			hash = GetHashKey('COMPONENT_AT_CR_BARREL_02'),
			model = 'w_at_cr_barrel_2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_CARBINERIFLE_MK2_CAMO',
			hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO'),
			model = 'w_ar_carbineriflemk2_camo1',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_CARBINERIFLE_MK2_CAMO_02',
			hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_02'),
			model = 'w_ar_carbineriflemk2_camo2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_CARBINERIFLE_MK2_CAMO_03',
			hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_03'),
			model = 'w_ar_carbineriflemk2_camo3',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_CARBINERIFLE_MK2_CAMO_04',
			hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_04'),
			model = 'w_ar_carbineriflemk2_camo4',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_CARBINERIFLE_MK2_CAMO_05',
			hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_05'),
			model = 'w_ar_carbineriflemk2_camo5',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_CARBINERIFLE_MK2_CAMO_06',
			hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_06'),
			model = 'w_ar_carbineriflemk2_camo6',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_CARBINERIFLE_MK2_CAMO_07',
			hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_07'),
			model = 'w_ar_carbineriflemk2_camo7',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_CARBINERIFLE_MK2_CAMO_08',
			hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_08'),
			model = 'w_ar_carbineriflemk2_camo8',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_CARBINERIFLE_MK2_CAMO_09',
			hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_09'),
			model = 'w_ar_carbineriflemk2_camo9',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_CARBINERIFLE_MK2_CAMO_10',
			hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_10'),
			model = 'w_ar_carbineriflemk2_camo10',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_CARBINERIFLE_MK2_CAMO_IND_01',
			hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_IND_01'),
			model = 'w_ar_carbineriflemk2_camo_ind1',
			type = 'default',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 32
}

config.weapon_combatmg_mk2 = {
	name = 'weapon_combatmg_mk2',
	hash = GetHashKey('WEAPON_COMBATMG_MK2'),
	clipSize = 100,
	category = 'mg',
	model = 'w_mg_combatmgmk2',
	ammo = {
		name = 'ammo_mg',
		hash = GetHashKey('AMMO_MG'),
		max = 500
	},
	components = {
		{
			name = 'COMPONENT_COMBATMG_MK2_CLIP_01',
			hash = GetHashKey('COMPONENT_COMBATMG_MK2_CLIP_01'),
			model = 'w_mg_combatmgmk2_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_COMBATMG_MK2_CLIP_02',
			hash = GetHashKey('COMPONENT_COMBATMG_MK2_CLIP_02'),
			model = 'w_mg_combatmgmk2_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_COMBATMG_MK2_CLIP_ARMORPIERCING',
			hash = GetHashKey('COMPONENT_COMBATMG_MK2_CLIP_ARMORPIERCING'),
			model = 'w_mg_combatmgmk2_mag_ap',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_COMBATMG_MK2_CLIP_FMJ',
			hash = GetHashKey('COMPONENT_COMBATMG_MK2_CLIP_FMJ'),
			model = 'w_mg_combatmgmk2_mag_fmj',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_COMBATMG_MK2_CLIP_INCENDIARY',
			hash = GetHashKey('COMPONENT_COMBATMG_MK2_CLIP_INCENDIARY'),
			model = 'w_mg_combatmgmk2_mag_inc',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_COMBATMG_MK2_CLIP_TRACER',
			hash = GetHashKey('COMPONENT_COMBATMG_MK2_CLIP_TRACER'),
			model = 'w_mg_combatmgmk2_mag_tr',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_SIGHTS',
			hash = GetHashKey('COMPONENT_AT_SIGHTS'),
			model = 'w_at_sights_1',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_SMALL_MK2',
			hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL_MK2'),
			model = 'w_at_scope_small',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_MEDIUM_MK2',
			hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM_MK2'),
			model = 'w_at_scope_medium_2',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_01',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_01'),
			model = 'w_at_muzzle_1',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_02',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_02'),
			model = 'w_at_muzzle_2',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_03',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_03'),
			model = 'w_at_muzzle_3',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_04',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_04'),
			model = 'w_at_muzzle_4',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_05',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_05'),
			model = 'w_at_muzzle_5',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_06',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_06'),
			model = 'w_at_muzzle_6',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_07',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_07'),
			model = 'w_at_muzzle_7',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_AFGRIP_02',
			hash = GetHashKey('COMPONENT_AT_AR_AFGRIP_02'),
			model = 'w_at_afgrip_2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_AT_MG_BARREL_01',
			hash = GetHashKey('COMPONENT_AT_MG_BARREL_01'),
			model = 'w_at_mg_barrel_1',
			type = 'default',
			default = true
		},
		{
			name = 'COMPONENT_AT_MG_BARREL_02',
			hash = GetHashKey('COMPONENT_AT_MG_BARREL_02'),
			model = 'w_at_mg_barrel_2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_COMBATMG_MK2_CAMO',
			hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO'),
			model = 'w_mg_combatmgmk2_camo1',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_COMBATMG_MK2_CAMO_02',
			hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_02'),
			model = 'w_mg_combatmgmk2_camo2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_COMBATMG_MK2_CAMO_03',
			hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_03'),
			model = 'w_mg_combatmgmk2_camo3',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_COMBATMG_MK2_CAMO_04',
			hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_04'),
			model = 'w_mg_combatmgmk2_camo4',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_COMBATMG_MK2_CAMO_05',
			hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_05'),
			model = 'w_mg_combatmgmk2_camo5',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_COMBATMG_MK2_CAMO_06',
			hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_06'),
			model = 'w_mg_combatmgmk2_camo6',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_COMBATMG_MK2_CAMO_07',
			hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_07'),
			model = 'w_mg_combatmgmk2_camo7',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_COMBATMG_MK2_CAMO_08',
			hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_08'),
			model = 'w_mg_combatmgmk2_camo8',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_COMBATMG_MK2_CAMO_09',
			hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_09'),
			model = 'w_mg_combatmgmk2_camo9',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_COMBATMG_MK2_CAMO_10',
			hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_10'),
			model = 'w_mg_combatmgmk2_camo10',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_COMBATMG_MK2_CAMO_IND_01',
			hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_IND_01'),
			model = 'w_mg_combatmgmk2_camo_ind1',
			type = 'default',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 30
}

config.weapon_doubleaction = {
	name = 'weapon_doubleaction',
	hash = GetHashKey('WEAPON_DOUBLEACTION'),
	clipSize = 6,
	category = 'pistol',
	model = 'w_pi_wep1_gun',
	ammo = {
		name = 'ammo_pistol',
		hash = GetHashKey('AMMO_PISTOL'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_DOUBLEACTION_CLIP_01',
			hash = GetHashKey('COMPONENT_DOUBLEACTION_CLIP_01'),
			model = 'w_pi_wep1_mag1',
			type = 'clip',
			default = true
		}
	},
	hasAttachments = true,
	numberOfAttachments = 1
}

config.weapon_heavysniper_mk2 = {
	name = 'weapon_heavysniper_mk2',
	hash = GetHashKey('WEAPON_HEAVYSNIPER_MK2'),
	clipSize = 6,
	category = 'sniper',
	model = 'w_sr_heavysnipermk2',
	ammo = {
		name = 'ammo_sniper',
		hash = GetHashKey('AMMO_SNIPER'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_HEAVYSNIPER_MK2_CLIP_01',
			hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CLIP_01'),
			model = 'w_sr_heavysnipermk2_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_HEAVYSNIPER_MK2_CLIP_02',
			hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CLIP_02'),
			model = 'w_sr_heavysnipermk2_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_HEAVYSNIPER_MK2_CLIP_ARMORPIERCING',
			hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CLIP_ARMORPIERCING'),
			model = 'w_sr_heavysnipermk2_mag_ap',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE',
			hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE'),
			model = 'w_sr_heavysnipermk2_mag_ap2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_HEAVYSNIPER_MK2_CLIP_FMJ',
			hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CLIP_FMJ'),
			model = 'w_sr_heavysnipermk2_mag_fmj',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_HEAVYSNIPER_MK2_CLIP_INCENDIARY',
			hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CLIP_INCENDIARY'),
			model = 'w_sr_heavysnipermk2_mag_inc',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_LARGE_MK2',
			hash = GetHashKey('COMPONENT_AT_SCOPE_LARGE_MK2'),
			model = 'w_at_scope_large',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_MAX',
			hash = GetHashKey('COMPONENT_AT_SCOPE_MAX'),
			model = 'w_at_scope_max',
			type = 'scope',
			default = true
		},
		{
			name = 'COMPONENT_AT_SCOPE_NV',
			hash = GetHashKey('COMPONENT_AT_SCOPE_NV'),
			model = 'w_at_scope_nv',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_THERMAL',
			hash = GetHashKey('COMPONENT_AT_SCOPE_THERMAL'),
			model = 'w_at_scope_nv',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_SR_SUPP_03',
			hash = GetHashKey('COMPONENT_AT_SR_SUPP_03'),
			model = 'w_at_sr_supp3',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_08',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_08'),
			model = 'w_at_muzzle_8',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_09',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_09'),
			model = 'w_at_muzzle_9',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_SR_BARREL_01',
			hash = GetHashKey('COMPONENT_AT_SR_BARREL_01'),
			model = 'w_at_sr_barrel_1',
			type = 'default',
			default = true
		},
		{
			name = 'COMPONENT_AT_SR_BARREL_02',
			hash = GetHashKey('COMPONENT_AT_SR_BARREL_02'),
			model = 'w_at_sr_barrel_2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_HEAVYSNIPER_MK2_CAMO',
			hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO'),
			model = 'w_at_heavysnipermk2_camo1',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_HEAVYSNIPER_MK2_CAMO_02',
			hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_02'),
			model = 'w_at_heavysnipermk2_camo2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_HEAVYSNIPER_MK2_CAMO_03',
			hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_03'),
			model = 'w_at_heavysnipermk2_camo3',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_HEAVYSNIPER_MK2_CAMO_04',
			hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_04'),
			model = 'w_at_heavysnipermk2_camo4',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_HEAVYSNIPER_MK2_CAMO_05',
			hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_05'),
			model = 'w_at_heavysnipermk2_camo5',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_HEAVYSNIPER_MK2_CAMO_06',
			hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_06'),
			model = 'w_at_heavysnipermk2_camo6',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_HEAVYSNIPER_MK2_CAMO_07',
			hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_07'),
			model = 'w_at_heavysnipermk2_camo7',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_HEAVYSNIPER_MK2_CAMO_08',
			hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_08'),
			model = 'w_at_heavysnipermk2_camo8',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_HEAVYSNIPER_MK2_CAMO_09',
			hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_09'),
			model = 'w_at_heavysnipermk2_camo9',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_HEAVYSNIPER_MK2_CAMO_10',
			hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_10'),
			model = 'w_at_heavysnipermk2_camo10',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_HEAVYSNIPER_MK2_CAMO_IND_01',
			hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_IND_01'),
			model = 'w_at_heavysnipermk2_camo_ind1',
			type = 'default',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 26
}

config.weapon_marksmanrifle_mk2 = {
	name = 'weapon_marksmanrifle_mk2',
	hash = GetHashKey('WEAPON_MARKSMANRIFLE_MK2'),
	clipSize = 8,
	category = 'sniper',
	model = 'w_sr_marksmanriflemk2',
	ammo = {
		name = 'ammo_sniper',
		hash = GetHashKey('AMMO_SNIPER'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_MARKSMANRIFLE_MK2_CLIP_01',
			hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CLIP_01'),
			model = 'w_sr_marksmanriflemk2_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_MARKSMANRIFLE_MK2_CLIP_02',
			hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CLIP_02'),
			model = 'w_sr_marksmanriflemk2_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_MARKSMANRIFLE_MK2_CLIP_ARMORPIERCING',
			hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CLIP_ARMORPIERCING'),
			model = 'w_sr_marksmanriflemk2_mag_ap',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_MARKSMANRIFLE_MK2_CLIP_FMJ',
			hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CLIP_FMJ'),
			model = 'w_sr_marksmanriflemk2_mag_fmj',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_MARKSMANRIFLE_MK2_CLIP_INCENDIARY',
			hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CLIP_INCENDIARY'),
			model = 'w_sr_marksmanriflemk2_mag_inc',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_MARKSMANRIFLE_MK2_CLIP_TRACER',
			hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CLIP_TRACER'),
			model = 'w_sr_marksmanriflemk2_mag_tr',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_FLSH',
			hash = GetHashKey('COMPONENT_AT_AR_FLSH'),
			model = 'w_at_ar_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_SIGHTS',
			hash = GetHashKey('COMPONENT_AT_SIGHTS'),
			model = 'w_at_sights_1',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_MEDIUM_MK2',
			hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM_MK2'),
			model = 'w_at_scope_medium_2',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM_MK2',
			hash = GetHashKey('COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM_MK2'),
			model = 'w_at_scope_large',
			type = 'scope',
			default = true
		},
		{
			name = 'COMPONENT_AT_AR_SUPP',
			hash = GetHashKey('COMPONENT_AT_AR_SUPP'),
			model = 'w_at_ar_supp',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_01',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_01'),
			model = 'w_at_muzzle_1',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_02',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_02'),
			model = 'w_at_muzzle_2',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_03',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_03'),
			model = 'w_at_muzzle_3',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_04',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_04'),
			model = 'w_at_muzzle_4',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_05',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_05'),
			model = 'w_at_muzzle_5',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_06',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_06'),
			model = 'w_at_muzzle_6',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_07',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_07'),
			model = 'w_at_muzzle_7',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_AFGRIP_02',
			hash = GetHashKey('COMPONENT_AT_AR_AFGRIP_02'),
			model = 'w_at_afgrip_2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_AT_MRFL_BARREL_01',
			hash = GetHashKey('COMPONENT_AT_MRFL_BARREL_01'),
			model = 'w_sr_mr_mk2_barrel_1',
			type = 'default',
			default = true
		},
		{
			name = 'COMPONENT_AT_MRFL_BARREL_02',
			hash = GetHashKey('COMPONENT_AT_MRFL_BARREL_02'),
			model = 'w_sr_mr_mk2_barrel_2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_MARKSMANRIFLE_MK2_CAMO',
			hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO'),
			model = 'w_sr_marksmanriflemk2_camo1',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_MARKSMANRIFLE_MK2_CAMO_02',
			hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_02'),
			model = 'w_sr_marksmanriflemk2_camo2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_MARKSMANRIFLE_MK2_CAMO_03',
			hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_03'),
			model = 'w_sr_marksmanriflemk2_camo3',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_MARKSMANRIFLE_MK2_CAMO_04',
			hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_04'),
			model = 'w_sr_marksmanriflemk2_camo4',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_MARKSMANRIFLE_MK2_CAMO_05',
			hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_05'),
			model = 'w_sr_marksmanriflemk2_camo5',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_MARKSMANRIFLE_MK2_CAMO_06',
			hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_06'),
			model = 'w_sr_marksmanriflemk2_camo6',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_MARKSMANRIFLE_MK2_CAMO_07',
			hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_07'),
			model = 'w_sr_marksmanriflemk2_camo7',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_MARKSMANRIFLE_MK2_CAMO_08',
			hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_08'),
			model = 'w_sr_marksmanriflemk2_camo8',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_MARKSMANRIFLE_MK2_CAMO_09',
			hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_09'),
			model = 'w_sr_marksmanriflemk2_camo9',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_MARKSMANRIFLE_MK2_CAMO_10',
			hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_10'),
			model = 'w_sr_marksmanriflemk2_camo10',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_MARKSMANRIFLE_MK2_CAMO_IND_01',
			hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_IND_01'),
			model = 'w_sr_marksmanriflemk2_camo_ind',
			type = 'default',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 32
}

config.weapon_pistol_mk2 = {
	name = 'weapon_pistol_mk2',
	hash = GetHashKey('WEAPON_PISTOL_MK2'),
	clipSize = 12,
	category = 'pistol',
	model = 'w_pi_pistolmk2',
	ammo = {
		name = 'ammo_pistol',
		hash = GetHashKey('AMMO_PISTOL'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_PISTOL_MK2_CLIP_01',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CLIP_01'),
			model = 'w_pi_pistolmk2_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_PISTOL_MK2_CLIP_02',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CLIP_02'),
			model = 'w_pi_pistolmk2_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL_MK2_CLIP_FMJ',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CLIP_FMJ'),
			model = 'w_pi_pistolmk2_mag_fmj',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL_MK2_CLIP_HOLLOWPOINT',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CLIP_HOLLOWPOINT'),
			model = 'w_pi_pistolmk2_mag_hp',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL_MK2_CLIP_INCENDIARY',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CLIP_INCENDIARY'),
			model = 'w_pi_pistolmk2_mag_inc',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL_MK2_CLIP_TRACER',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CLIP_TRACER'),
			model = 'w_pi_pistolmk2_mag_tr',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_PI_RAIL',
			hash = GetHashKey('COMPONENT_AT_PI_RAIL'),
			model = 'w_at_pi_rail_1',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_PI_FLSH_02',
			hash = GetHashKey('COMPONENT_AT_PI_FLSH_02'),
			model = 'w_at_pi_flsh_2',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_PI_SUPP_02',
			hash = GetHashKey('COMPONENT_AT_PI_SUPP_02'),
			model = 'w_at_pi_supp_2',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_PI_COMP',
			hash = GetHashKey('COMPONENT_AT_PI_COMP'),
			model = 'w_at_pi_comp_1',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL_MK2_CAMO_SLIDE',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_SLIDE'),
			model = 'W_PI_PistolMK2_Slide_Camo1',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL_MK2_CAMO_02_SLIDE',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_02_SLIDE'),
			model = 'W_PI_PistolMK2_Slide_Camo2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL_MK2_CAMO_03_SLIDE',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_03_SLIDE'),
			model = 'W_PI_PistolMK2_Slide_Camo3',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL_MK2_CAMO_04_SLIDE',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_04_SLIDE'),
			model = 'W_PI_PistolMK2_Slide_Camo4',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL_MK2_CAMO_05_SLIDE',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_05_SLIDE'),
			model = 'W_PI_PistolMK2_Slide_Camo5',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL_MK2_CAMO_06_SLIDE',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_06_SLIDE'),
			model = 'W_PI_PistolMK2_Slide_Camo6',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL_MK2_CAMO_07_SLIDE',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_07_SLIDE'),
			model = 'W_PI_PistolMK2_Slide_Camo7',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL_MK2_CAMO_08_SLIDE',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_08_SLIDE'),
			model = 'W_PI_PistolMK2_Slide_Camo8',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL_MK2_CAMO_09_SLIDE',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_09_SLIDE'),
			model = 'W_PI_PistolMK2_Slide_Camo9',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL_MK2_CAMO_10_SLIDE',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_10_SLIDE'),
			model = 'W_PI_PistolMK2_Slide_Camo10',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL_MK2_CAMO_IND_01_SLIDE',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_IND_01_SLIDE'),
			model = 'W_PI_PistolMK2_Camo_Sl_Ind1',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL_MK2_CAMO',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO'),
			model = 'w_pi_pistolmk2_camo1',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL_MK2_CAMO_02',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_02'),
			model = 'w_pi_pistolmk2_camo2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL_MK2_CAMO_03',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_03'),
			model = 'w_pi_pistolmk2_camo3',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL_MK2_CAMO_04',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_04'),
			model = 'w_pi_pistolmk2_camo4',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL_MK2_CAMO_05',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_05'),
			model = 'w_pi_pistolmk2_camo5',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL_MK2_CAMO_06',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_06'),
			model = 'w_pi_pistolmk2_camo6',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL_MK2_CAMO_07',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_07'),
			model = 'w_pi_pistolmk2_camo7',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL_MK2_CAMO_08',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_08'),
			model = 'w_pi_pistolmk2_camo8',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL_MK2_CAMO_09',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_09'),
			model = 'w_pi_pistolmk2_camo9',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL_MK2_CAMO_10',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_10'),
			model = 'w_pi_pistolmk2_camo10',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PISTOL_MK2_CAMO_IND_01',
			hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_IND_01'),
			model = 'w_pi_pistolmk2_camo_ind1',
			type = 'default',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 32
}

config.weapon_pumpshotgun_mk2 = {
	name = 'weapon_pumpshotgun_mk2',
	hash = GetHashKey('WEAPON_PUMPSHOTGUN_MK2'),
	clipSize = 8,
	category = 'shotgun',
	model = 'w_sg_pumpshotgunmk2',
	ammo = {
		name = 'ammo_shotgun',
		hash = GetHashKey('AMMO_SHOTGUN'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_PUMPSHOTGUN_MK2_CLIP_01',
			hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CLIP_01'),
			model = 'w_sg_pumpshotgunmk2_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_PUMPSHOTGUN_MK2_CLIP_ARMORPIERCING',
			hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CLIP_ARMORPIERCING'),
			model = 'w_sg_pumpshotgunmk2_mag_ap',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_PUMPSHOTGUN_MK2_CLIP_EXPLOSIVE',
			hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CLIP_EXPLOSIVE'),
			model = 'w_sg_pumpshotgunmk2_mag_exp',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_PUMPSHOTGUN_MK2_CLIP_HOLLOWPOINT',
			hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CLIP_HOLLOWPOINT'),
			model = 'w_sg_pumpshotgunmk2_mag_hp',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_PUMPSHOTGUN_MK2_CLIP_INCENDIARY',
			hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CLIP_INCENDIARY'),
			model = 'w_sg_pumpshotgunmk2_mag_inc',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_SIGHTS',
			hash = GetHashKey('COMPONENT_AT_SIGHTS'),
			model = 'w_at_sights_1',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_MACRO_MK2',
			hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_MK2'),
			model = 'w_at_scope_macro',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_SMALL_MK2',
			hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL_MK2'),
			model = 'w_at_scope_small',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_FLSH',
			hash = GetHashKey('COMPONENT_AT_AR_FLSH'),
			model = 'w_at_ar_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_SR_SUPP_03',
			hash = GetHashKey('COMPONENT_AT_SR_SUPP_03'),
			model = 'w_at_sr_supp3',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_08',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_08'),
			model = 'w_at_muzzle_8',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_PUMPSHOTGUN_MK2_CAMO',
			hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO'),
			model = 'w_sg_pumpshotgunmk2_camo1',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PUMPSHOTGUN_MK2_CAMO_02',
			hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_02'),
			model = 'w_sg_pumpshotgunmk2_camo2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PUMPSHOTGUN_MK2_CAMO_03',
			hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_03'),
			model = 'w_sg_pumpshotgunmk2_camo3',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PUMPSHOTGUN_MK2_CAMO_04',
			hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_04'),
			model = 'w_sg_pumpshotgunmk2_camo4',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PUMPSHOTGUN_MK2_CAMO_05',
			hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_05'),
			model = 'w_sg_pumpshotgunmk2_camo5',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PUMPSHOTGUN_MK2_CAMO_06',
			hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_06'),
			model = 'w_sg_pumpshotgunmk2_camo6',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PUMPSHOTGUN_MK2_CAMO_07',
			hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_07'),
			model = 'w_sg_pumpshotgunmk2_camo7',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PUMPSHOTGUN_MK2_CAMO_08',
			hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_08'),
			model = 'w_sg_pumpshotgunmk2_camo8',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PUMPSHOTGUN_MK2_CAMO_09',
			hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_09'),
			model = 'w_sg_pumpshotgunmk2_camo9',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PUMPSHOTGUN_MK2_CAMO_10',
			hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_10'),
			model = 'w_sg_pumpshotgunmk2_camo10',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_PUMPSHOTGUN_MK2_CAMO_IND_01',
			hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_IND_01'),
			model = 'w_sg_pumpshotgunmk2_camo_ind1',
			type = 'default',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 22
}

config.weapon_revolver_mk2 = {
	name = 'weapon_revolver_mk2',
	hash = GetHashKey('WEAPON_REVOLVER_MK2'),
	clipSize = 6,
	category = 'pistol',
	model = 'w_pi_revolvermk2',
	ammo = {
		name = 'ammo_pistol',
		hash = GetHashKey('AMMO_PISTOL'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_REVOLVER_MK2_CLIP_01',
			hash = GetHashKey('COMPONENT_REVOLVER_MK2_CLIP_01'),
			model = 'w_pi_revolvermk2_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_REVOLVER_MK2_CLIP_FMJ',
			hash = GetHashKey('COMPONENT_REVOLVER_MK2_CLIP_FMJ'),
			model = 'w_pi_revolvermk2_mag5',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_REVOLVER_MK2_CLIP_HOLLOWPOINT',
			hash = GetHashKey('COMPONENT_REVOLVER_MK2_CLIP_HOLLOWPOINT'),
			model = 'w_pi_revolvermk2_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_REVOLVER_MK2_CLIP_INCENDIARY',
			hash = GetHashKey('COMPONENT_REVOLVER_MK2_CLIP_INCENDIARY'),
			model = 'w_pi_revolvermk2_mag3',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_REVOLVER_MK2_CLIP_TRACER',
			hash = GetHashKey('COMPONENT_REVOLVER_MK2_CLIP_TRACER'),
			model = 'w_pi_revolvermk2_mag4',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_SIGHTS',
			hash = GetHashKey('COMPONENT_AT_SIGHTS'),
			model = 'w_at_sights_1',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_MACRO_MK2',
			hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_MK2'),
			model = 'w_at_scope_macro',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_PI_FLSH',
			hash = GetHashKey('COMPONENT_AT_PI_FLSH'),
			model = 'w_at_pi_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_PI_COMP_03',
			hash = GetHashKey('COMPONENT_AT_PI_COMP_03'),
			model = 'w_at_pi_comp_3',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_REVOLVER_MK2_CAMO',
			hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO'),
			model = 'w_pi_revolvermk2_camo1',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_REVOLVER_MK2_CAMO_02',
			hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_02'),
			model = 'w_pi_revolvermk2_camo2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_REVOLVER_MK2_CAMO_03',
			hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_03'),
			model = 'w_pi_revolvermk2_camo3',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_REVOLVER_MK2_CAMO_04',
			hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_04'),
			model = 'w_pi_revolvermk2_camo4',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_REVOLVER_MK2_CAMO_05',
			hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_05'),
			model = 'w_pi_revolvermk2_camo5',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_REVOLVER_MK2_CAMO_06',
			hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_06'),
			model = 'w_pi_revolvermk2_camo6',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_REVOLVER_MK2_CAMO_07',
			hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_07'),
			model = 'w_pi_revolvermk2_camo7',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_REVOLVER_MK2_CAMO_08',
			hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_08'),
			model = 'w_pi_revolvermk2_camo8',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_REVOLVER_MK2_CAMO_09',
			hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_09'),
			model = 'w_pi_revolvermk2_camo9',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_REVOLVER_MK2_CAMO_10',
			hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_10'),
			model = 'w_pi_revolvermk2_camo10',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_REVOLVER_MK2_CAMO_IND_01',
			hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_IND_01'),
			model = 'w_pi_revolvermk2_camo_ind',
			type = 'default',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 20
}

config.weapon_smg_mk2 = {
	name = 'weapon_smg_mk2',
	hash = GetHashKey('WEAPON_SMG_MK2'),
	clipSize = 30,
	category = 'smg',
	model = 'w_sb_smgmk2',
	ammo = {
		name = 'ammo_smg',
		hash = GetHashKey('AMMO_SMG'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_SMG_MK2_CLIP_01',
			hash = GetHashKey('COMPONENT_SMG_MK2_CLIP_01'),
			model = 'w_sb_smgmk2_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_SMG_MK2_CLIP_02',
			hash = GetHashKey('COMPONENT_SMG_MK2_CLIP_02'),
			model = 'w_sb_smgmk2_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_SMG_MK2_CLIP_FMJ',
			hash = GetHashKey('COMPONENT_SMG_MK2_CLIP_FMJ'),
			model = 'w_sb_smgmk2_mag_fmj',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_SMG_MK2_CLIP_HOLLOWPOINT',
			hash = GetHashKey('COMPONENT_SMG_MK2_CLIP_HOLLOWPOINT'),
			model = 'w_sb_smgmk2_mag_hp',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_SMG_MK2_CLIP_INCENDIARY',
			hash = GetHashKey('COMPONENT_SMG_MK2_CLIP_INCENDIARY'),
			model = 'w_sb_smgmk2_mag_inc',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_SMG_MK2_CLIP_TRACER',
			hash = GetHashKey('COMPONENT_SMG_MK2_CLIP_TRACER'),
			model = 'w_sb_smgmk2_mag_tr',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_FLSH',
			hash = GetHashKey('COMPONENT_AT_AR_FLSH'),
			model = 'w_at_ar_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_SIGHTS_SMG',
			hash = GetHashKey('COMPONENT_AT_SIGHTS_SMG'),
			model = 'w_at_sights_smg',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2',
			hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2'),
			model = 'w_at_scope_macro_2_mk2',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_SMALL_SMG_MK2',
			hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL_SMG_MK2'),
			model = 'w_at_scope_small_mk2',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_PI_SUPP',
			hash = GetHashKey('COMPONENT_AT_PI_SUPP'),
			model = 'w_at_pi_supp',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_01',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_01'),
			model = 'w_at_muzzle_1',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_02',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_02'),
			model = 'w_at_muzzle_2',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_03',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_03'),
			model = 'w_at_muzzle_3',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_04',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_04'),
			model = 'w_at_muzzle_4',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_05',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_05'),
			model = 'w_at_muzzle_5',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_06',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_06'),
			model = 'w_at_muzzle_6',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_07',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_07'),
			model = 'w_at_muzzle_7',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_SB_BARREL_01',
			hash = GetHashKey('COMPONENT_AT_SB_BARREL_01'),
			model = 'w_at_sb_barrel_1',
			type = 'default',
			default = true
		},
		{
			name = 'COMPONENT_AT_SB_BARREL_02',
			hash = GetHashKey('COMPONENT_AT_SB_BARREL_02'),
			model = 'w_at_sb_barrel_2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SMG_MK2_CAMO',
			hash = GetHashKey('COMPONENT_SMG_MK2_CAMO'),
			model = 'w_at_smgmk2_camo1',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SMG_MK2_CAMO_02',
			hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_02'),
			model = 'w_at_smgmk2_camo2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SMG_MK2_CAMO_03',
			hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_03'),
			model = 'w_at_smgmk2_camo3',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SMG_MK2_CAMO_04',
			hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_04'),
			model = 'w_at_smgmk2_camo4',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SMG_MK2_CAMO_05',
			hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_05'),
			model = 'w_at_smgmk2_camo5',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SMG_MK2_CAMO_06',
			hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_06'),
			model = 'w_at_smgmk2_camo6',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SMG_MK2_CAMO_07',
			hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_07'),
			model = 'w_at_smgmk2_camo7',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SMG_MK2_CAMO_08',
			hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_08'),
			model = 'w_at_smgmk2_camo8',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SMG_MK2_CAMO_09',
			hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_09'),
			model = 'w_at_smgmk2_camo9',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SMG_MK2_CAMO_10',
			hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_10'),
			model = 'w_at_smgmk2_camo10',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SMG_MK2_CAMO_IND_01',
			hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_IND_01'),
			model = 'w_at_smgmk2_camo_ind1',
			type = 'default',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 31
}

config.weapon_snspistol_mk2 = {
	name = 'weapon_snspistol_mk2',
	hash = GetHashKey('WEAPON_SNSPISTOL_MK2'),
	clipSize = 6,
	category = 'pistol',
	model = 'w_pi_sns_pistolmk2',
	ammo = {
		name = 'ammo_pistol',
		hash = GetHashKey('AMMO_PISTOL'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CLIP_01',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CLIP_01'),
			model = 'w_pi_sns_pistolmk2_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CLIP_02',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CLIP_02'),
			model = 'w_pi_sns_pistolmk2_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CLIP_TRACER',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CLIP_TRACER'),
			model = 'W_PI_SNS_PistolMK2_Mag_TR',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CLIP_INCENDIARY',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CLIP_INCENDIARY'),
			model = 'W_PI_SNS_PistolMK2_Mag_INC',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CLIP_HOLLOWPOINT',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CLIP_HOLLOWPOINT'),
			model = 'W_PI_SNS_PistolMK2_Mag_HP',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CLIP_FMJ',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CLIP_FMJ'),
			model = 'W_PI_SNS_PistolMK2_Mag_FMJ',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_PI_FLSH_03',
			hash = GetHashKey('COMPONENT_AT_PI_FLSH_03'),
			model = 'w_at_pi_snsmk2_flsh_1',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_PI_RAIL_02',
			hash = GetHashKey('COMPONENT_AT_PI_RAIL_02'),
			model = 'w_at_pi_rail_2',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_PI_SUPP_02',
			hash = GetHashKey('COMPONENT_AT_PI_SUPP_02'),
			model = 'w_at_pi_supp_2',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_PI_COMP_02',
			hash = GetHashKey('COMPONENT_AT_PI_COMP_02'),
			model = 'w_at_pi_comp_2',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CAMO_SLIDE',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_SLIDE'),
			model = 'W_PI_SNS_PistolMk2_SL_Camo1',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CAMO_02_SLIDE',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_02_SLIDE'),
			model = 'W_PI_SNS_PistolMk2_SL_Camo2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CAMO_03_SLIDE',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_03_SLIDE'),
			model = 'W_PI_SNS_PistolMk2_SL_Camo3',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CAMO_04_SLIDE',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_04_SLIDE'),
			model = 'W_PI_SNS_PistolMk2_SL_Camo4',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CAMO_05_SLIDE',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_05_SLIDE'),
			model = 'W_PI_SNS_PistolMk2_SL_Camo5',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CAMO_06_SLIDE',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_06_SLIDE'),
			model = 'W_PI_SNS_PistolMk2_SL_Camo6',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CAMO_07_SLIDE',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_07_SLIDE'),
			model = 'W_PI_SNS_PistolMk2_SL_Camo7',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CAMO_08_SLIDE',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_08_SLIDE'),
			model = 'W_PI_SNS_PistolMk2_SL_Camo8',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CAMO_09_SLIDE',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_09_SLIDE'),
			model = 'W_PI_SNS_PistolMk2_SL_Camo9',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CAMO_10_SLIDE',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_10_SLIDE'),
			model = 'W_PI_SNS_PistolMk2_SL_Camo10',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CAMO_IND_01_SLIDE',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_IND_01_SLIDE'),
			model = 'W_PI_SNS_PistolMK2_SL_Camo_Ind1',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CAMO',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO'),
			model = 'W_PI_SNS_PistolMk2_Camo1',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CAMO_02',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_02'),
			model = 'W_PI_SNS_PistolMk2_Camo2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CAMO_03',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_03'),
			model = 'W_PI_SNS_PistolMk2_Camo3',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CAMO_04',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_04'),
			model = 'W_PI_SNS_PistolMk2_Camo4',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CAMO_05',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_05'),
			model = 'W_PI_SNS_PistolMk2_Camo5',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CAMO_06',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_06'),
			model = 'W_PI_SNS_PistolMk2_Camo6',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CAMO_07',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_07'),
			model = 'W_PI_SNS_PistolMk2_Camo7',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CAMO_08',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_08'),
			model = 'W_PI_SNS_PistolMk2_Camo8',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CAMO_09',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_09'),
			model = 'W_PI_SNS_PistolMk2_Camo9',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CAMO_10',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_10'),
			model = 'W_PI_SNS_PistolMk2_Camo10',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SNSPISTOL_MK2_CAMO_IND_01',
			hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_IND_01'),
			model = 'w_pi_sns_pistolmk2_camo_ind1',
			type = 'default',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 32
}

config.weapon_raypistol = {
	name = 'weapon_raypistol',
	hash = GetHashKey('WEAPON_RAYPISTOL'),
	clipSize = 1,
	category = 'pistol',
	model = 'w_pi_raygun',
	ammo = {
		name = 'ammo_raypistol',
		hash = GetHashKey('AMMO_RAYPISTOL'),
		max = 20
	},
	components = {
		{
			name = 'COMPONENT_RAYPISTOL_VARMOD_XMAS18',
			hash = GetHashKey('COMPONENT_RAYPISTOL_VARMOD_XMAS18'),
			model = 'w_pi_raygun_ev',
			type = 'variant',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 1
}

config.weapon_raycarbine = {
	name = 'weapon_raycarbine',
	hash = GetHashKey('WEAPON_RAYCARBINE'),
	clipSize = 9999,
	category = 'mg',
	model = 'w_ar_srifle',
	ammo = {
		name = 'ammo_mg',
		hash = GetHashKey('AMMO_MG'),
		max = 500
	},
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_rayminigun = {
	name = 'weapon_rayminigun',
	hash = GetHashKey('WEAPON_RAYMINIGUN'),
	clipSize = 15000,
	category = 'heavy',
	model = 'w_mg_sminigun',
	ammo = {
		name = 'ammo_minigun',
		hash = GetHashKey('AMMO_MINIGUN'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_MINIGUN_CLIP_01',
			hash = GetHashKey('COMPONENT_MINIGUN_CLIP_01'),
			model = '',
			type = 'clip',
			default = true
		}
	},
	hasAttachments = true,
	numberOfAttachments = 1
}

config.weapon_specialcarbine_mk2 = {
	name = 'weapon_specialcarbine_mk2',
	hash = GetHashKey('WEAPON_SPECIALCARBINE_MK2'),
	clipSize = 30,
	category = 'rifle',
	model = 'w_ar_specialcarbinemk2',
	ammo = {
		name = 'ammo_rifle',
		hash = GetHashKey('AMMO_RIFLE'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_SPECIALCARBINE_MK2_CLIP_01',
			hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CLIP_01'),
			model = 'w_ar_specialcarbinemk2_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_SPECIALCARBINE_MK2_CLIP_02',
			hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CLIP_02'),
			model = 'w_ar_specialcarbinemk2_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_SPECIALCARBINE_MK2_CLIP_TRACER',
			hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CLIP_TRACER'),
			model = 'w_ar_specialcarbinemk2_mag_tr',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_SPECIALCARBINE_MK2_CLIP_INCENDIARY',
			hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CLIP_INCENDIARY'),
			model = 'w_ar_specialcarbinemk2_mag_inc',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_SPECIALCARBINE_MK2_CLIP_ARMORPIERCING',
			hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CLIP_ARMORPIERCING'),
			model = 'w_ar_specialcarbinemk2_mag_ap',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_SPECIALCARBINE_MK2_CLIP_FMJ',
			hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CLIP_FMJ'),
			model = 'w_ar_specialcarbinemk2_mag_fmj',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_FLSH',
			hash = GetHashKey('COMPONENT_AT_AR_FLSH'),
			model = 'w_at_ar_flsh',
			type = 'flashlight',
			default = false
		},
		{
			name = 'COMPONENT_AT_SIGHTS',
			hash = GetHashKey('COMPONENT_AT_SIGHTS'),
			model = 'w_at_sights_1',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_MACRO_MK2',
			hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_MK2'),
			model = 'w_at_scope_macro',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_SCOPE_MEDIUM_MK2',
			hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM_MK2'),
			model = 'w_at_scope_medium_2',
			type = 'scope',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_SUPP_02',
			hash = GetHashKey('COMPONENT_AT_AR_SUPP_02'),
			model = 'w_at_ar_supp_02',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_01',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_01'),
			model = 'w_at_muzzle_1',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_02',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_02'),
			model = 'w_at_muzzle_2',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_03',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_03'),
			model = 'w_at_muzzle_3',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_04',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_04'),
			model = 'w_at_muzzle_4',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_05',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_05'),
			model = 'w_at_muzzle_5',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_06',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_06'),
			model = 'w_at_muzzle_6',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_MUZZLE_07',
			hash = GetHashKey('COMPONENT_AT_MUZZLE_07'),
			model = 'w_at_muzzle_7',
			type = 'suppressor',
			default = false
		},
		{
			name = 'COMPONENT_AT_AR_AFGRIP_02',
			hash = GetHashKey('COMPONENT_AT_AR_AFGRIP_02'),
			model = 'w_at_afgrip_2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_AT_SC_BARREL_01',
			hash = GetHashKey('COMPONENT_AT_SC_BARREL_01'),
			model = 'w_ar_sc_barrel_1',
			type = 'default',
			default = true
		},
		{
			name = 'COMPONENT_AT_SC_BARREL_02',
			hash = GetHashKey('COMPONENT_AT_SC_BARREL_02'),
			model = 'w_ar_sc_barrel_2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SPECIALCARBINE_MK2_CAMO',
			hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO'),
			model = 'w_ar_specialcarbinemk2_camo1',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SPECIALCARBINE_MK2_CAMO_02',
			hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_02'),
			model = 'w_ar_specialcarbinemk2_camo2',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SPECIALCARBINE_MK2_CAMO_03',
			hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_03'),
			model = 'w_ar_specialcarbinemk2_camo3',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SPECIALCARBINE_MK2_CAMO_04',
			hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_04'),
			model = 'w_ar_specialcarbinemk2_camo4',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SPECIALCARBINE_MK2_CAMO_05',
			hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_05'),
			model = 'w_ar_specialcarbinemk2_camo5',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SPECIALCARBINE_MK2_CAMO_06',
			hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_06'),
			model = 'w_ar_specialcarbinemk2_camo6',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SPECIALCARBINE_MK2_CAMO_07',
			hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_07'),
			model = 'w_ar_specialcarbinemk2_camo7',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SPECIALCARBINE_MK2_CAMO_08',
			hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_08'),
			model = 'w_ar_specialcarbinemk2_camo8',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SPECIALCARBINE_MK2_CAMO_09',
			hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_09'),
			model = 'w_ar_specialcarbinemk2_camo9',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SPECIALCARBINE_MK2_CAMO_10',
			hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_10'),
			model = 'w_ar_specialcarbinemk2_camo10',
			type = 'default',
			default = false
		},
		{
			name = 'COMPONENT_SPECIALCARBINE_MK2_CAMO_IND_01',
			hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_IND_01'),
			model = 'w_ar_specialcarbinemk2_camo_ind',
			type = 'default',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 32
}

config.weapon_vintagepistol = {
	name = 'weapon_vintagepistol',
	hash = GetHashKey('WEAPON_VINTAGEPISTOL'),
	clipSize = 7,
	category = 'pistol',
	model = 'w_pi_vintage_pistol',
	ammo = {
		name = 'ammo_pistol',
		hash = GetHashKey('AMMO_PISTOL'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_VINTAGEPISTOL_CLIP_01',
			hash = GetHashKey('COMPONENT_VINTAGEPISTOL_CLIP_01'),
			model = 'w_pi_vintage_pistol_mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_VINTAGEPISTOL_CLIP_02',
			hash = GetHashKey('COMPONENT_VINTAGEPISTOL_CLIP_02'),
			model = 'w_pi_vintage_pistol_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_AT_PI_SUPP',
			hash = GetHashKey('COMPONENT_AT_PI_SUPP'),
			model = 'w_at_pi_supp',
			type = 'suppressor',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 3
}

config.weapon_wrench = {
	name = 'weapon_wrench',
	hash = GetHashKey('WEAPON_WRENCH'),
	clipSize = 0,
	category = 'melee',
	model = 'w_me_wrench',
	ammo = nil,
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_ceramicpistol = {
	name = 'weapon_ceramicpistol',
	hash = GetHashKey('WEAPON_CERAMICPISTOL'),
	clipSize = 12,
	category = 'pistol',
	model = 'w_pi_ceramic_pistol',
	ammo = {
		name = 'ammo_pistol',
		hash = GetHashKey('AMMO_PISTOL'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_CERAMICPISTOL_CLIP_01',
			hash = GetHashKey('COMPONENT_CERAMICPISTOL_CLIP_01'),
			model = 'W_PI_Ceramic_Mag1',
			type = 'clip',
			default = true
		},
		{
			name = 'COMPONENT_CERAMICPISTOL_CLIP_02',
			hash = GetHashKey('COMPONENT_CERAMICPISTOL_CLIP_02'),
			model = 'w_pi_sns_pistol_mag2',
			type = 'clip',
			default = false
		},
		{
			name = 'COMPONENT_CERAMICPISTOL_SUPP',
			hash = GetHashKey('COMPONENT_CERAMICPISTOL_SUPP'),
			model = 'W_PI_Ceramic_Supp',
			type = 'suppressor',
			default = false
		}
	},
	hasAttachments = true,
	numberOfAttachments = 3
}

config.weapon_hazardcan = {
	name = 'weapon_hazardcan',
	hash = GetHashKey('WEAPON_HAZARDCAN'),
	clipSize = 4500,
	category = 'petrolcan',
	model = 'w_ch_jerrycan',
	ammo = {
		name = 'ammo_hazardcan',
		hash = GetHashKey('AMMO_HAZARDCAN'),
		max = 4500
	},
	components = {},
	hasAttachments = false,
	numberOfAttachments = 0
}

config.weapon_navyrevolver = {
	name = 'weapon_navyrevolver',
	hash = GetHashKey('WEAPON_NAVYREVOLVER'),
	clipSize = 6,
	category = 'pistol',
	model = 'w_pi_wep2_gun',
	ammo = {
		name = 'ammo_pistol',
		hash = GetHashKey('AMMO_PISTOL'),
		max = 250
	},
	components = {
		{
			name = 'COMPONENT_NAVYREVOLVER_CLIP_01',
			hash = GetHashKey('COMPONENT_NAVYREVOLVER_CLIP_01'),
			model = 'w_pi_wep2_gun_mag1',
			type = 'clip',
			default = true
		}
	},
	hasAttachments = true,
	numberOfAttachments = 1
}