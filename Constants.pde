static class Constants {

  // Program constants
  static final String credits =
  "Liberal Nazi Zombies" +
  "\nCreated by Daniel Gray" +
  "\n20220328: v0.6.3z" +
  "\nLines: 13473 (v0.6.3y)" +
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

  // Units
  static final float unit_defaultSize = 0.35;
  static final int unit_defaultHeight = 5;
  static final float unit_defaultSight = 5.5;
  static final float unit_sneakSpeed = 0.5;
  static final float unit_small_facing_threshhold = 0.01;

  // AI
  static final float ai_chickenMoveDistance = 2;
  static final float ai_chickenTimer = 3000;

  // Items
  static final float item_defaultSize = 0.25;
  static final int item_bounceConstant = 800;
  static final float item_bounceOffset = 0.15;
  static final int item_starPieceFrames = 4;
  static final float item_starPieceAnimationTime = 450;

  // Projectiles
  static final float projectile_defaultSize = 0.25;

  // gifs
  static final int gif_move_frames = 35;
  static final int gif_move_time = 1200;
}
