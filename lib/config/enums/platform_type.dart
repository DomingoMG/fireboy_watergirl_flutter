enum PlatformType {
  floor(''),   // Plataforma normal donde puede caminar
  wall(''),
  roof(''),
  largeAcid('pools/large_acid_pool.png'),    // Suelo mortal largo para WaterGirl y FireBoy
  smallAcid('pools/small_acid_pool.png'),    // Suelo mortal pequeño para WaterGirl y FireBoy
  largeWater('pools/large_water_pool.png'),   // Suelo mortal largo para WaterGirl
  smallWater('pools/small_water_pool.png'),    // Suelo mortal pequeño para WaterGirl
  largeFire('pools/large_lava_pool.png'),    // Suelo mortal largo para FireBoy
  smallFire('pools/small_lava_pool.png'),    // Suelo mortal pequeño para FireBoy
  ice('');     // Plataforma resbaladiza (si quisieras implementar efecto de hielo)

  const PlatformType(this.assets);
  final String assets;
}