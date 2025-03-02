
enum HitboxType { 
  blueDoor(assetName: 'doors/blue_door_close.png'),
  redDoor(assetName: 'doors/red_door_close.png'),
  lavaPlatform(assetName: 'pools/large_lava_pool.png'),
  waterPlatform(assetName: 'pools/large_water_pool.png'),
  icePlatform(assetName: 'levels/ice_platform.png'),
  acidPlatform(assetName: 'levels/acid_platform.png'),
  whiteFan(assetName: 'elevators/buttons/white_button_elevator.png');

  const HitboxType({
    required this.assetName
  });
  final String assetName;

}