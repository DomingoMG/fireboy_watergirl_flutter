enum HitboxType { 
  box(assetName: 'misc/move_box.png'),
  blueDoor(assetName: 'doors/blue_door_close.png'),
  redDoor(assetName: 'doors/red_door_close.png'),
  lavaPlatform(assetName: 'puddles/large_lava_pool.png'),
  waterPlatform(assetName: 'puddles/large_water_pool.png'),
  acidPlatform(assetName: 'puddles/large_acid_pool.png'),
  whiteFan(assetName: 'elevators/buttons/white_button_elevator.png');

  const HitboxType({
    required this.assetName
  });
  final String assetName;

}