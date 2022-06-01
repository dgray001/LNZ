static class Constants {

  // Program constants
  static final String credits =
  "Liberal Nazi Zombies" +
  "\nCreated by Daniel Gray" +
  "\nAlpha v0.7.4p: 20220601" +
  "\n\nLines: 44536 (v0.7.4j)" +
  "\nImages: 1175 (v0.7.4)" +
  "\nSounds: 322 (v0.7.4)" +
  "";
  static final String version_history =
  "Liberal Nazi Zombies" +
  "\nCreated by Daniel Gray" +
  "\n202205: v0.7: Alpha Version" +
  "\n202203: v0.6: Advanced Mechanics" +
  "\n202202: v0.5: Recreated Logic" +
  "\n202201: v0.4: Recreated Program" +
  "\n2019: v0.3: Legacy Version" +
  "";
  static final int frameUpdateTime = 401; // prime number
  static final int frameAverageCache = 3;
  static final int maxFPS = 120;
  static final int exit_delay = 300;
  static final float default_cursor_size = 35;
  static final float small_number = 0.001; // for float miscalculations
  static final float inverse_root_two = 0.70710678;
  static final float errorForm_width = 400;
  static final float errorForm_height = 400;
  static final color color_black = -16777216;
  static final color color_fog = 1688906410;
  static final color color_transparent = 65793;
  static final int notification_slide_time = 200;
  static final int notification_display_time = 3000;
  static final float notification_achievement_width = 220;
  static final float notification_achievement_height = 120;
  static final float esc_button_height = 30;
  static final float escFormWidth = 350;
  static final float escFormHeight = 350;

  // Initial Interface
  static final int initialInterface_size = 400;
  static final int initialInterface_buttonWidth = 80;
  static final int initialInterface_buttonGap = 25;

  // Profile
  static final float profile_treeForm_width = 300;
  static final float profile_treeForm_height = 340;
  static final float profile_tree_nodeHeight = 80;
  static final float profile_heroesFormWidth = 850;
  static final float profile_heroesFormHeight = 600;
  static final float profile_heroFormWidth = 400;
  static final float profile_heroFormHeight = 500;

  // MainMenu Interface
  static final float profileForm_width = 400;
  static final float profileForm_height = 500;
  static final float newProfileForm_width = 400;
  static final float newProfileForm_height = 500;
  static final float optionsForm_widthOffset = 300;
  static final float optionsForm_heightOffset = 100;
  static final float optionsForm_threshhold_master = 0.12;
  static final float optionsForm_threshhold_other = 0.15;
  static final float achievementsForm_widthOffset = 300;
  static final float achievementsForm_heightOffset = 100;
  static final float banner_maxWidthRatio = 0.8;
  static final float banner_maxHeightRatio = 0.2;
  static final float creditsForm_width = 300;
  static final float creditsForm_height = 320;
  static final float playButton_scaleFactor = 1.7;
  static final float profileButton_offset = 45;
  static final float profileButton_growfactor = 1.6;

  // Options
  static final int options_defaultVolume = 50;
  static final int options_defaultMusicVolume = 30;
  static final float options_volumeMin = 0.01;
  static final int options_volumeMax = 100;
  static final float options_volumeGainMultiplier = 8;

  // MapEditor Interface
  static final float mapEditor_panelMinWidth = 220;
  static final float mapEditor_panelMaxWidth = 400;
  static final float mapEditor_panelStartWidth = 300;
  static final float mapEditor_buttonGapSize = 10;
  static final float mapEditor_listBoxGap = 5;
  static final float mapEditor_formWidth = 400;
  static final float mapEditor_formHeight = 500;
  static final float mapEditor_formWidth_small = 250;
  static final float mapEditor_formHeight_small = 250;
  static final float mapEditor_rightClickBoxWidth = 100;
  static final float mapEditor_rightClickBoxMaxHeight = 100;

  // Help strings
  static final String help_mapEditor_maps = "Maps\n\nThis view displays the " +
    "maps you've made. Double-click a map to edit it, or right click one to " +
    "see more options.";
  static final String help_mapEditor_levels = "Levels\n\nThis view displays the " +
    "levels you've made. Double-click a level to edit it, or right click one to " +
    "see more options.";
  static final String help_mapEditor_terrain = "Terrain\n\nIn this view you " +
    "can select terrain to add to the map.\n\nHotkeys:\n z: Toggle grid\n x: " +
    "Toggle fog\n c: Toggle rectangle mode\n v: Toggle square mode\n b: Edit " +
    "selected object on map.";
  static final String help_mapEditor_features = "Features\n\nIn this view you " +
    "can select features to add to the map.\n\nHotkeys:\n z: Toggle grid\n x: " +
    "Toggle fog\n c: Toggle rectangle mode\n v: Toggle square mode\n b: Edit " +
    "selected object on map.";
  static final String help_mapEditor_units = "Units\n\nIn this view you " +
    "can select units to add to the map.\n\nHotkeys:\n z: Toggle grid\n x: " +
    "Toggle fog\n c: Toggle rectangle mode\n v: Toggle square mode\n b: Edit " +
    "selected object on map.";
  static final String help_mapEditor_items = "Items\n\nIn this view you " +
    "can select items to add to the map.\n\nHotkeys:\n z: Toggle grid\n x: " +
    "Toggle fog\n c: Toggle rectangle mode\n v: Toggle square mode\n b: Edit " +
    "selected object on map.";
  static final String help_mapEditor_levelInfo = "Level Editor\n\nIn this " +
    "view you see an overview of your level and the maps in it.\nDouble-click " +
    "a map to view it.\n\nHotkeys:\n z: Toggle grid\n x: Toggle fog\n c: Toggle " +
    "rectangle mode\n v: Toggle square mode\n s: Save last rectangle\n S: Set " +
    "player start/respawn location";
  static final String help_mapEditor_levelMaps = "Maps\n\nIn this view you " +
    "can see the maps that can be added to your level.\nDouble-click a map " +
    "to add it to your level.\n\nHotkeys:\n z: Toggle grid\n x: Toggle fog\n c: " +
    "Toggle rectangle mode\n v: Toggle square mode\n s: Save last rectangle\n S: " +
    "Set player start/respawn location\n d: Remove selected map from level";
  static final String help_mapEditor_linkers = "Linkers\n\nIn this view you " +
    "see the linkers in your level.\n\nHotkeys:\n z: Toggle grid\n x: Toggle " +
    "fog\n c: Toggle rectangle mode\n v: Toggle square mode\n s: Save last " +
    "rectangle\n S: Set player start/respawn location\n a: Add linker from current " +
    "rectangles\n d: Delete selected linker from level";
  static final String help_mapEditor_triggers = "Triggers\n\nIn this view " +
    "you see the triggers in your level.\nDouble-click a trigger to open the " +
    "trigger editor.\n\nHotkeys:\n z: Toggle grid\n x: Toggle fog\n c: Toggle " +
    "rectangle mode\n v: Toggle square mode\n s: Save last rectangle\n S: Set " +
    "player start/respawn location\n a: Add a new trigger to level\n d: Delete selected " +
    "trigger from level";
  static final String help_mapEditor_triggerEditor = "Trigger Editor\n\nIn " +
    "this view you can edit the trigger you selected.\n\nHotkeys:\n z: " +
    "Toggle grid\n x: Toggle fog\n c: Toggle rectangle mode\n v: Toggle square " +
    "mode\n s: Save last rectangle\n S: Set player start/respawn location\n d: Delete " +
    "selected trigger component from trigger";
  static final String help_mapEditor_conditionEditor = "Condition Editor\n\nIn " +
    "this view you can edit the condition you selected.\n\nHotkeys:\n z: " +
    "Toggle grid\n x: Toggle fog\n c: Toggle rectangle mode\n v: Toggle square " +
    "mode\n s: Save last rectangle\n S: Set player start/respawn location\n a: Add " +
    "current rectangle to condition\n d: Delete selected trigger component " +
    "from trigger";
  static final String help_mapEditor_effectEditor = "Effect Editor\n\nIn " +
    "this view you can edit the effect you selected.\n\nHotkeys:\n z: " +
    "Toggle grid\n x: Toggle fog\n c: Toggle rectangle mode\n v: Toggle square " +
    "mode\n s: Save last rectangle\n S: Set player start/respawn location\n a: Add " +
    "current rectangle to effect\n d: Delete selected trigger component " +
    "from trigger";

  // GameMap
  static final float map_borderSize = 30;
  static final int map_terrainResolutionDefault = 70;
  static final int map_fogResolution = 4;
  static final float map_defaultZoom = 100;
  static final float map_minZoom = 60;
  static final float map_maxZoom = 150;
  static final float map_scrollZoomFactor = -1.5;
  static final float map_minCameraSpeed = 0.001;
  static final float map_maxCameraSpeed = 0.1;
  static final float map_defaultCameraSpeed = 0.01;
  static final float map_defaultHeaderMessageTextSize = 28;
  static final int map_headerMessageFadeTime = 250;
  static final int map_headerMessageShowTime = 3000;
  static final float map_selectedObjectTitleTextSize = 22;
  static final float map_selectedObjectPanelGap = 4;
  static final float map_selectedObjectImageGap = 8;
  static final float map_moveLogicCap = 0.12; // longest movable distance at one logical go
  static final float map_tierImageHeight = 50;
  static final float map_statusImageHeight = 30;
  static final int map_maxHeaderMessages = 5;
  static final float map_defaultMaxSoundDistance = 8;
  static final float map_timer_refresh_fog_default = 350;
  static final float map_timer_refresh_fog_min = 50;
  static final float map_timer_refresh_fog_max = 950;
  static final int map_maxHeight = 10;
  static final float map_lightDecay = 0.8; // per square
  static final int map_lightUpdateIterations = 8; // per refresh

  // Features
  static final float feature_defaultInteractionDistance = 0.3;
  static final int feature_woodenTableHealth = 4;
  static final int feature_woodenDeskHealth = 10;
  static final int feature_woodenChairHealth = 2;
  static final int feature_furnitureInteractionTime = 200;
  static final int feature_couchHealth = 4;
  static final int feature_woodenBenchSmallHealth = 4;
  static final int feature_woodenBenchLargeHealth = 8;
  static final int feature_bedHealth = 8;
  static final int feature_wardrobeHealth = 10;
  static final int feature_signCooldown = 2000;
  static final String feature_signDescriptionDelimiter = "***";
  static final int feature_showerStallCooldown = 6000;
  static final int feature_urinalCooldown = 6000;
  static final int feature_toiletCooldown = 10000;
  static final int feature_pickleJarCooldown = 2000;
  static final int feature_movableBrickWallInteractionTime = 1500;
  static final int feature_gravelInteractionTime = 300;
  static final float feature_gravelMaxNumberRocks = 4;
  static final int feature_wireFenceInteractionTime = 400;
  static final int feature_treeInteractionTime = 350;
  static final int feature_treeHealth = 8;
  static final int feature_treeBigHealth = 12;
  static final float feature_treeDropChance = 0.5;
  static final float feature_treeChanceEndBranches = 0.6;
  static final int feature_bushInteractionTime = 350;
  static final int feature_bushHealth = 3;
  static final float feature_bushDropChance = 0.5;
  static final float feature_vendingEatMoneyChance = 0.3;
  static final int feature_bedSleepTimer = 5000;
  static final float feature_workbenchMinimumToolsButtonWidth = 350;

  // Units
  static final float unit_defaultSize = 0.35;
  static final int unit_defaultHeight = 5;
  static final float unit_defaultSight = 6.5;
  static final float unit_sneakSpeed = 0.5;
  static final float unit_moveCollisionStopActionTime = 300;
  static final float unit_small_facing_threshhold = 0.01;
  static final float unit_defaultBaseAttackCooldown = 1200;
  static final float unit_defaultBaseAttackTime = 300;
  static final float unit_defaultBaseAttackRange = 0.2;
  static final float unit_weaponDisplayScaleFactor = 0.8;
  static final float unit_attackAnimation_ratio1 = 0.6;
  static final float unit_attackAnimation_ratio2 = 0.85;
  static final float unit_attackAnimation_amount1 = 0.33 * PI;
  static final float unit_attackAnimation_amount2 = -0.5 * PI;
  static final float unit_attackAnimation_amount3 = Constants.unit_attackAnimation_amount1 + Constants.unit_attackAnimation_amount2;
  static final float unit_attackAnimation_multiplier1 =
    Constants.unit_attackAnimation_amount1 / Constants.unit_attackAnimation_ratio1;
  static final float unit_attackAnimation_multiplier2 = Constants.unit_attackAnimation_amount2 /
    (Constants.unit_attackAnimation_ratio2 - Constants.unit_attackAnimation_ratio1);
  static final float unit_attackAnimationAngle(float timerRatio) {
    if (timerRatio < Constants.unit_attackAnimation_ratio1) {
      return timerRatio * Constants.unit_attackAnimation_multiplier1;
    }
    else if (timerRatio < Constants.unit_attackAnimation_ratio2) {
      return Constants.unit_attackAnimation_amount1 + (timerRatio -
        Constants.unit_attackAnimation_ratio1) * Constants.unit_attackAnimation_multiplier2;
    }
    else {
      return Constants.unit_attackAnimation_amount3 * (1 - timerRatio) / (1 - Constants.unit_attackAnimation_ratio2);
    }
  }
  static final float unit_healthbarWidth = 0.9;
  static final float unit_healthbarHeight = 0.15;
  static final float unit_healthbarDamageAnimationTime = 150;
  static final float unit_fallTimer = 100;
  static final int unit_maxAgility = 5;
  static final int unit_noDamageFallHeight = 3;
  static final float unit_fallDamageMultiplier = 0.015;
  static final int unit_timer_talk = 9000;
  static final int unit_timer_walk = 380;
  static final float unit_footgearDurabilityDistance = 100;

  // Resistances
  static final float resistance_default = 1;
  static final float resistance_blue_blue = 0.85;
  static final float resistance_blue_red = 0.8;
  static final float resistance_blue_brown = 1.2;
  static final float resistance_red_red = 0.85;
  static final float resistance_red_cyan = 0.8;
  static final float resistance_red_blue = 1.2;
  static final float resistance_cyan_cyan = 0.85;
  static final float resistance_cyan_orange = 0.8;
  static final float resistance_cyan_red = 1.2;
  static final float resistance_orange_orange = 0.85;
  static final float resistance_orange_brown = 0.8;
  static final float resistance_orange_cyan = 1.2;
  static final float resistance_brown_brown = 0.85;
  static final float resistance_brown_blue = 0.8;
  static final float resistance_brown_orange = 1.2;
  static final float resistance_purple_purple = 0.85;
  static final float resistance_purple_yellow = 0.8;
  static final float resistance_purple_magenta = 1.2;
  static final float resistance_yellow_yellow = 0.85;
  static final float resistance_yellow_magenta = 0.8;
  static final float resistance_yellow_purple = 1.2;
  static final float resistance_magenta_magenta = 0.85;
  static final float resistance_magenta_purple = 0.8;
  static final float resistance_magenta_yellow = 1.2;

  // Status Effects
  static final float status_hunger_tickTimer = 1400;
  static final float status_hunger_dot = 0.02;
  static final float status_hunger_damageLimit = 0.5;
  static final float status_hunger_weakPercentage = 0.1;
  static final float status_weak_multiplier = 0.9;
  static final float status_thirst_tickTimer = 1400;
  static final float status_thirst_dot = 0.02;
  static final float status_thirst_damageLimit = 0.35;
  static final float status_thirst_woozyPercentage = 0.07;
  static final float status_thirst_confusedPercentage = 0.07;
  static final float status_woozy_tickMaxTimer = 10000;
  static final float status_woozy_maxAmount = HALF_PI;
  static final float status_confused_tickMaxTimer = 10000;
  static final float status_confused_maxAmount = 3;
  static final float status_bleed_tickTimer = 1200;
  static final float status_bleed_dot = 0.02;
  static final float status_bleed_damageLimit = 0.1;
  static final float status_bleed_hemorrhagePercentage = 0.1;
  static final float status_hemorrhage_tickTimer = 900;
  static final float status_hemorrhage_dot = 0.04;
  static final float status_hemorrhage_damageLimit = 0;
  static final float status_hemorrhage_bleedPercentage = 0.7;
  static final float status_wilted_multiplier = 0.8;
  static final float status_withered_multiplier = 0.7;
  static final float status_running_multiplier = 1.35;
  static final float status_relaxed_multiplier = 0.85;
  static final float status_relaxed_healMultiplier = 0.01;
  static final float status_drenched_multiplier = 1.3;
  static final float status_drenched_tickTimer = 1200;
  static final float status_drenched_dot = 0.025;
  static final float status_drenched_damageLimit = 0.2;
  static final float status_drowning_tickTimer = 500;
  static final float status_drowning_dot = 0.05;
  static final float status_drowning_damageLimit = 0;
  static final float status_drowning_damageLimitBlue = 0.05;
  static final float status_drowning_drenchedPercentage = 0.7;
  static final float status_burnt_tickTimer = 1200;
  static final float status_burnt_dot = 0.025;
  static final float status_burnt_damageLimit = 0;
  static final float status_burnt_damageLimitRed = 0.1;
  static final float status_burnt_charredPercentage = 0.1;
  static final float status_charred_tickTimer = 600;
  static final float status_charred_dot = 0.03;
  static final float status_charred_damageLimit = 0;
  static final float status_charred_damageLimitRed = 0.05;
  static final float status_chilled_speedMultiplier = 0.5;
  static final float status_chilled_speedMultiplierCyan = 0.8;
  static final float status_chilled_cooldownMultiplier = 0.5;
  static final float status_chilled_cooldownMultiplierCyan = 0.8;
  static final float status_frozen_tickTimer = 1600;
  static final float status_frozen_dot = 0.025;
  static final float status_frozen_damageLimit = 0.1;
  static final float status_sick_damageMultiplier = 1.15;
  static final float status_sick_defenseMultiplier = 0.85;
  static final float status_diseased_damageMultiplier = 1.3;
  static final float status_diseased_defenseMultiplier = 0.7;
  static final float status_rotting_tickTimer = 1000;
  static final float status_rotting_dot = 0.015;
  static final float status_rotting_damageLimit = 0.1;
  static final float status_rotting_damageLimitBrown = 0.2;
  static final float status_rotting_damageLimitBlue = 0.0;
  static final float status_rotting_decayedPercentage = 0.1;
  static final float status_decayed_tickTimer = 1000;
  static final float status_decayed_dot = 0.025;
  static final float status_decayed_damageLimit = 0;
  static final float status_decayed_damageLimitBrown = 0.1;

  // AI
  static final float ai_chickenMoveDistance = 2;
  static final float ai_chickenTimer1 = 3000;
  static final float ai_chickenTimer2 = 45000;

  // Items
  static final int item_disappearTimer = 300000; // 5 minutes
  static final float item_defaultSize = 0.25;
  static final int item_bounceConstant = 800;
  static final float item_bounceOffset = 0.15;
  static final int item_starPieceFrames = 4;
  static final float item_starPieceAnimationTime = 450;
  static final float item_defaultInteractionDistance = 0.3;
  static final float item_stackTextSizeRatio = 0.25;
  static final int item_cigarLitTime = 200000;

  // Projectiles
  static final float projectile_defaultSize = 0.25;
  static final float projectile_threshholdSpeed = 3;
  static final float projectile_grenadeExplosionRadius = 2;
  static final float projectile_mustangAndSallyExplosionRadius = 2.6;
  static final float projectile_rpgExplosionRadius = 1.6;
  static final float projectile_rpgIIExplosionRadius = 1.8;
  static final float projectile_rayGunExplosionRadius = 1;
  static final float projectile_rayGunIIExplosionRadius = 1.2;

  // Gifs
  static final int gif_move_frames = 35;
  static final int gif_move_time = 1200;
  static final int gif_poof_frames = 8;
  static final int gif_poof_time = 900;
  static final int gif_amphibiousLeap_frames = 10;
  static final int gif_amphibiousLeap_time = 400;
  static final int gif_quizmoQuestion_frames = 3;
  static final int gif_quizmoQuestion_time = 400;
  static final int gif_explosionBig_frames = 23;
  static final int gif_explosionBig_time = 850;
  static final int gif_explosionCrackel_frames = 17;
  static final int gif_explosionCrackel_time = 600;
  static final int gif_explosionFire_frames = 23;
  static final int gif_explosionFire_time = 600;
  static final int gif_explosionNormal_frames = 14;
  static final int gif_explosionNormal_time = 550;
  static final int gif_explosionGreen_frames = 102;
  static final int gif_explosionGreen_time = 650;
  static final int gif_fire_frames = 31;
  static final int gif_fire_time = 2500;
  static final int gif_lava_frames = 37;
  static final int gif_lava_time = 3200;
  static final int gif_drenched_frames = 4;
  static final int gif_drenched_time = 500;
  static final int gif_arrow_frames = 3;
  static final int gif_arrow_time = 350;
  static final int gif_loading_frames = 30;
  static final int gif_loading_time = 950;

  // Hero
  static final float hero_defaultInventoryButtonSize = 50;
  static final int hero_inventoryMaxRows = 6;
  static final int hero_inventoryMaxCols = 9;
  static final int hero_inventoryDefaultStartSlots = 0;
  static final float hero_experienceNextLevel_level = 1.4;
  static final float hero_experienceNextLevel_power = 2.0;
  static final float hero_experienceNextLevel_tier = 3.0;
  static final float hero_killExponent = 1.5;
  static final int hero_maxLevel = 100;
  static final float hero_defaultInventoryBarHeight = 120;
  static final float hero_inventoryBarGap = 10;
  static final float hero_abilityDescriptionMinWidth = 250;
  static final int hero_maxHunger = 100;
  static final int hero_maxThirst = 100;
  static final int hero_hungerTimer = 4500;
  static final int hero_thirstTimer = 2000;
  static final int hero_abilityNumber = 5;
  static final int hero_hungerThreshhold = 20;
  static final int hero_thirstThreshhold = 20;
  static final float hero_statusDescription_width = 160;
  static final float hero_statusDescription_height = 120;
  static final float hero_leftPanelBarHeight = 10;
  static final float hero_leftPanelButtonHoverTimer = 400;
  static final float hero_treeButtonDefaultRadius = 60;
  static final float hero_treeButtonCenterRadius = 90;
  static final float hero_treeForm_width = 300;
  static final float hero_treeForm_height = 340;
  static final float hero_manabarHeight = 0.05;
  static final float hero_experienceRespawnMultiplier = 0.3;
  static final float hero_passiveHealPercent = 0.002;
  static final int hero_multicraftTimer = 50;

  // Upgrade
  static final int upgrade_inventoryI = 2;
  static final int upgrade_inventoryII = 4;
  static final int upgrade_inventory_bar_slots = 3;
  static final float upgrade_healthI = 4;
  static final float upgrade_attackI = 3;
  static final float upgrade_defenseI = 2;
  static final float upgrade_piercingI = 0.05;
  static final float upgrade_speedI = 0.3;
  static final float upgrade_sightI = 1.5;
  static final float upgrade_tenacityI = 0.05;
  static final int upgrade_agilityI = 1;
  static final float upgrade_magicI = 5;
  static final float upgrade_resistanceI = 3;
  static final float upgrade_penetrationI = 0.05;
  static final float upgrade_healthII = 25;
  static final float upgrade_attackII = 10;
  static final float upgrade_defenseII = 5;
  static final float upgrade_piercingII = 0.07;
  static final float upgrade_speedII = 0.5;
  static final float upgrade_sightII = 2;
  static final float upgrade_tenacityII = 0.07;
  static final int upgrade_agilityII = 1;
  static final float upgrade_magicII = 20;
  static final float upgrade_resistanceII = 7;
  static final float upgrade_penetrationII = 0.07;
  static final float upgrade_healthIII = 120;

  // Abilities
  // Ben Nelson
  static final int ability_101_rageGain = 2;
  static final int ability_101_rageGainKill = 6;
  static final float ability_101_cooldownTimer = 4000;
  static final float ability_101_tickTimer = 500;
  static final float ability_101_bonusAmount = 0.0025;
  static final float ability_102_powerBase = 1;
  static final float ability_102_powerRatio = 0.35;
  static final float ability_102_distance = 5;
  static final float ability_102_powerBasePen = 5;
  static final float ability_102_powerRatioPen = 0.7;
  static final float ability_102_healRatio = 0.2;
  static final float ability_103_range = 2;
  static final float ability_103_castTime = 800;
  static final float ability_103_coneAngle = 0.15 * PI;
  static final float ability_103_debuff = 0.85;
  static final float ability_103_time = 3000;
  static final float ability_104_passiveHealAmount = 0.01;
  static final float ability_104_passiveHealTimer = 2000;
  static final float ability_104_activeHealAmount = 0.2;
  static final float ability_104_speedBuff = 1.25;
  static final float ability_104_speedBuffTimer = 3000;
  static final int ability_105_rageGain = 40;
  static final float ability_105_buffAmount = 1.4;
  static final float ability_105_buffTime = 4500;
  static final float ability_105_rageGainBonus = 1.8;
  static final float ability_105_fullRageBonus = 1.3;
  static final float ability_105_shakeConstant = 4;
  static final int ability_106_rageGain = 5;
  static final int ability_106_rageGainKill = 10;
  static final float ability_106_cooldownTimer = 6000;
  static final float ability_106_tickTimer = 800;
  static final float ability_106_bonusAmount = 0.004;
  static final float ability_107_powerBase = 10;
  static final float ability_107_powerRatio = 0.5;
  static final float ability_107_distance = 5;
  static final float ability_107_powerBasePen = 50;
  static final float ability_107_powerRatioPen = 1;
  static final float ability_107_healRatio = 0.3;
  static final float ability_108_range = 3;
  static final float ability_108_castTime = 800;
  static final float ability_108_coneAngle = 0.15 * PI;
  static final float ability_108_debuff = 0.75;
  static final float ability_108_time = 5000;
  static final float ability_109_passiveHealAmount = 0.01;
  static final float ability_109_passiveHealTimer = 1500;
  static final float ability_109_activeHealAmount = 0.25;
  static final float ability_109_speedBuff = 1.35;
  static final float ability_109_speedBuffTimer = 4500;
  static final int ability_110_rageGain = 60;
  static final float ability_110_buffAmount = 1.5;
  static final float ability_110_buffTime = 7000;
  static final float ability_110_rageGainBonus = 1.6;
  static final float ability_110_fullRageBonus = 1.5;
  static final float ability_110_shakeConstant = 6;
  // Daniel Gray
  static final float ability_111_stillTime = 3500;
  static final float ability_111_distance = 0.2;
  static final float ability_111_powerBuff = 1.4;
  static final float ability_111_regenTime = 1400;
  static final float ability_112_basePower = 5;
  static final float ability_112_physicalRatio = 0.15;
  static final float ability_112_magicalRatio = 0.4;
  static final float ability_112_distance = 2;
  static final float ability_112_castTime = 500;
  static final float ability_112_slowAmount = 0.7;
  static final float ability_112_slowTime = 3000;
  static final float ability_113_jumpDistance = 2;
  static final float ability_113_jumpHeight = 5;
  static final float ability_113_jumpSpeed = 4.5;
  static final float ability_113_basePower = 3;
  static final float ability_113_physicalRatio = 0.1;
  static final float ability_113_magicalRatio = 0.7;
  static final float ability_113_stunTime = 1000;
  static final float ability_113_splashRadius = 0.5;
  static final float ability_113_killCooldownReduction = 0.5;
  static final float ability_113_drenchedJumpDistance = 3;
  static final float ability_113_drenchedSplashRadius = 0.8;
  static final float ability_114_currHealth = 0.01;
  static final float ability_114_basePower = 1;
  static final float ability_114_magicRatio = 0.05;
  static final float ability_114_range = 0.8;
  static final float ability_114_rotTime = 1200;
  static final float ability_114_tickTime = 500;
  static final float ability_115_range = 0.4;
  static final float ability_115_maxTime = 3500;
  static final float ability_115_basePower = 8;
  static final float ability_115_physicalRatio = 0.1;
  static final float ability_115_magicalRatio = 0.7;
  static final float ability_115_regurgitateSpeed = 5;
  static final float ability_115_regurgitateDistance = 2.5;
  static final float ability_116_stillTime = 2000;
  static final float ability_116_distance = 0.1;
  static final float ability_116_powerBuff = 1.7;
  static final float ability_116_regenTime = 1200;
  static final float ability_117_basePower = 15;
  static final float ability_117_physicalRatio = 0.20;
  static final float ability_117_magicalRatio = 0.8;
  static final float ability_117_distance = 2.5;
  static final float ability_117_slowTime = 4000;
  static final float ability_118_jumpDistance = 2.5;
  static final float ability_118_basePower = 12;
  static final float ability_118_physicalRatio = 0.2;
  static final float ability_118_magicalRatio = 1.2;
  static final float ability_118_stunTime = 1200;
  static final float ability_118_splashRadius = 0.6;
  static final float ability_118_killCooldownReduction = 0.2;
  static final float ability_118_drenchedJumpDistance = 4;
  static final float ability_118_drenchedSplashRadius = 1;
  static final float ability_119_currHealth = 0.015;
  static final float ability_119_basePower = 2;
  static final float ability_119_magicRatio = 0.08;
  static final float ability_119_range = 1;
  static final float ability_120_maxTime = 5000;
  static final float ability_120_basePower = 15;
  static final float ability_120_physicalRatio = 0.2;
  static final float ability_120_magicalRatio = 1.4;

  // Level
  static final float level_questBoxHeightRatio = 0.25;
  static final float level_decisionFormWidth = 500;
  static final float level_decisionFormHeight = 500;
  static final float level_vendingFormWidth = 300;
  static final float level_vendingFormHeight = 600;
  static final float level_quizmoFormWidth = 400;
  static final float level_quizmoFormHeight = 500;
  static final float level_quizmoTimeDelay = 900;
  static final float level_khalilFormWidth = 400;
  static final float level_khalilFormHeight = 500;
  static final int level_questBlinkTime = 500;
  static final int level_questBlinks = 3;
  static final float level_timeConstants = 0.00002; // 20 minute day / night cycles
  static final float level_dayLightLevel = 9.5;
  static final float level_nightLightLevel = 3.5;
  static final float level_zombieSpawnLightThreshhold = 5;
  static final int level_defaultRespawnTimer = 5000;
}
