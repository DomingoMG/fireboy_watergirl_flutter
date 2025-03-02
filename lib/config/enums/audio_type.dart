enum AudioType { 
  fireboyJump(assetName: 'fireboy_jump.mp3'),
  waterGirlJump(assetName: 'watergirl_jump.mp3'),
  buttonHover(assetName: 'button_hover.mp3'),
  buttonClick(assetName: 'button_click.mp3'),
  fan(assetName: 'fan.mp3'),
  coin(assetName: 'coin.mp3'),
  death(assetName: 'death.mp3'),
  levelComplete(assetName: 'level_complete.mp3'),
  musicIntro(assetName: 'music_intro.mp3'),
  musicLevel(assetName: 'music_level.mp3');

  const AudioType({ required this.assetName });
  final String assetName;  
}
