static class Constants {

  // Program constants
  static final String credits =
  "Liberal Nazi Zombies" +
  "\nCreated by Daniel Gray" +
  "\n20220410: v0.6.6e" +
  "\nLines: 20919 (v0.6.6)" +
  "";
  static final String version_history =
  "Liberal Nazi Zombies" +
  "\nCreated by Daniel Gray" +
  "\n???: v0.7: Recovery Version" +
  "\n20220228: v0.6: Advanced Mechanics" +
  "\n202202: v0.5: Recreate Logic" +
  "\n202201: v0.4: Recreate Program" +
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

  // Initial Interface
  static final int initialInterface_size = 400;
  static final int initialInterface_buttonWidth = 80;
  static final int initialInterface_buttonGap = 25;

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
  static final int options_defaultVolume = 70;
  static final int options_volumeMin = 0;
  static final int options_volumeMax = 100;
  static final int options_volumeGainAdjustment = -50;

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
    "player start location";
  static final String help_mapEditor_levelMaps = "Maps\n\nIn this view you " +
    "can see the maps that can be added to your level.\nDouble-click a map " +
    "to add it to your level.\n\nHotkeys:\n z: Toggle grid\n x: Toggle fog\n c: " +
    "Toggle rectangle mode\n v: Toggle square mode\n s: Save last rectangle\n S: " +
    "Set player start location";
  static final String help_mapEditor_linkers = "Linkers\n\nIn this view you " +
    "see the linkers in your level.\n\nHotkeys:\n z: Toggle grid\n x: Toggle " +
    "fog\n c: Toggle rectangle mode\n v: Toggle square mode\n s: Save last " +
    "rectangle\n S: Set player start location\n a: Add linker from current " +
    "rectangles\n d: Delete selected linker from level";
  static final String help_mapEditor_triggers = "Triggers\n\nIn this view " +
    "you see the triggers in your level.\nDouble-click a trigger to open the " +
    "trigger editor.\n\nHotkeys:\n z: Toggle grid\n x: Toggle fog\n c: Toggle " +
    "rectangle mode\n v: Toggle square mode\n s: Save last rectangle\n S: Set " +
    "player start location\n a: Add a new trigger to level\n d: Delete selected " +
    "trigger from level";
  static final String help_mapEditor_triggerEditor = "Trigger Editor\n\nIn " +
    "this view you can edit the trigger you selected.\n\nHotkeys:\n z: " +
    "Toggle grid\n x: Toggle fog\n c: Toggle rectangle mode\n v: Toggle square " +
    "mode\n s: Save last rectangle\n S: Set player start location";
  static final String help_mapEditor_conditionEditor = "Condition Editor\n\nIn " +
    "this view you can edit the condition you selected.\n\nHotkeys:\n z: " +
    "Toggle grid\n x: Toggle fog\n c: Toggle rectangle mode\n v: Toggle square " +
    "mode\n s: Save last rectangle\n S: Set player start location";
  static final String help_mapEditor_effectEditor = "Effect Editor\n\nIn " +
    "this view you can edit the effect you selected.\n\nHotkeys:\n z: " +
    "Toggle grid\n x: Toggle fog\n c: Toggle rectangle mode\n v: Toggle square " +
    "mode\n s: Save last rectangle\n S: Set player start location";

  // GameMap
  static final float map_borderSize = 30;
  static final int map_terrainResolution = 60;
  static final int map_fogResolution = 6; // in case in future I decide to use fog images
  static final float map_defaultZoom = 60;
  static final float map_minZoom = 40;
  static final float map_maxZoom = 120;
  static final float map_scrollZoomFactor = -1;
  static final float map_minCameraSpeed = 0.001;
  static final float map_maxCameraSpeed = 0.1;
  static final float map_defaultCameraSpeed = 0.01;
  static final float map_defaultHeaderMessageTextSize = 24;
  static final int map_headerMessageFadeTime = 250;
  static final int map_headerMessageShowTime = 3000;
  static final float map_selectedObjectTitleTextSize = 22;
  static final float map_selectedObjectPanelGap = 4;
  static final float map_selectedObjectImageGap = 8;
  static final float map_moveLogicCap = 0.15; // longest movable distance at one logical go

  // Features
  static final float feature_defaultInteractionDistance = 0.3;
  static final int feature_rummageInteractionTime = 200;
  static final int feature_couchHealth = 2;
  static final int feature_signCooldown = 5000;
  static final String feature_signDescriptionDelimiter = "***";
  static final int feature_showerStallCooldown = 6000;
  static final int feature_urinalCooldown = 6000;
  static final int feature_toiletCooldown = 10000;
  static final int feature_pickleJarCooldown = 2000;
  static final int feature_movableBrickWallInteractionTime = 1500;
  static final int feature_windowInteractionTime = 800;
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

  // Units
  static final float unit_defaultSize = 0.35;
  static final int unit_defaultHeight = 5;
  static final float unit_defaultSight = 5.5;
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
  static final float unit_healthbarHeight = 0.13;
  static final float unit_healthbarDamageAnimationTime = 150;

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
  static final float ai_chickenTimer = 3000;

  // Items
  static final float item_defaultSize = 0.25;
  static final int item_bounceConstant = 800;
  static final float item_bounceOffset = 0.15;
  static final int item_starPieceFrames = 4;
  static final float item_starPieceAnimationTime = 450;
  static final float item_defaultInteractionDistance = 0.3;

  // Projectiles
  static final float projectile_defaultSize = 0.25;
  static final float projectile_threshholdSpeed = 3;

  // gifs
  static final int gif_move_frames = 35;
  static final int gif_move_time = 1200;

  // Hero
  static final float hero_defaultInventoryButtonSize = 45;
  static final int hero_inventoryMaxRows = 6;
  static final int hero_inventoryMaxCols = 10;
  static final int hero_inventoryDefaultStartSlots = 13;
  static final float hero_experienceNextLevel_level = 1.4;
  static final float hero_experienceNextLevel_power = 2.0;
  static final float hero_experienceNextLevel_tier = 3.0;
  static final float hero_killExponent = 3.0;
  static final int hero_maxLevel = 100;
  static final float hero_defaultInventoryBarHeight = 110;
  static final float hero_inventoryBarGap = 10;
  static final int hero_hungerTimer = 4500;
  static final int hero_thirstTimer = 2000;
  static final int hero_abilityNumber = 5;
  static final int hero_hungerThreshhold = 20;
  static final int hero_thirstThreshhold = 20;
  static final float hero_statusDescription_width = 160;
  static final float hero_statusDescription_height = 120;
}
