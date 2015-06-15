//
//  SnowSoundPicker.m
//  snow
//
//  Created by samuel maura on 6/10/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowSoundPicker.h"
#import "UIImage+SnowImageUtils.h"

@interface SnowSoundPicker ()

@end

@implementation SnowSoundPicker {
  UIView *_previewContainer;
  UIView *_playerContainer;
  UIView *_wrapper;
  UIButton *_playPause;
  UILabel *_previewSoundName;
  AVAudioPlayer *_aPlayer;
  AVAudioSession *_session;
  BOOL _isPlayerUp;

  BOOL _isAnimationOngoing;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  /*
_session = [AVAudioSession sharedInstance];
[_session setCategory:AVAudioSessionCategoryPlayback error:nil];
*/

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(audioInterrupt:)
             name:AVAudioSessionInterruptionNotification
           object:nil];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(audioInterrupt:)
             name:UIApplicationDidEnterBackgroundNotification
           object:nil];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(audioInterrupt:)
             name:UIApplicationWillResignActiveNotification
           object:nil];

  _selectedSound = [[SnowAppearanceManager sharedInstance] currentAlertTone];

  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:@"basic"];

  _soundList = @{
    SNOW_ALERT_LONG_RAILS : [SnowSound nameForKey:SNOW_ALERT_LONG_RAILS],
    SNOW_ALERT_LONG_POLICE_BRIT :
       [SnowSound nameForKey:SNOW_ALERT_LONG_POLICE_BRIT],
    SNOW_ALERT_LONG_SCHOOL_ALARM :
       [SnowSound nameForKey:SNOW_ALERT_LONG_SCHOOL_ALARM],
    SNOW_ALERT_SHORT_INDUSTRIAL_ALARM :
       [SnowSound nameForKey:SNOW_ALERT_SHORT_INDUSTRIAL_ALARM],
    SNOW_ALERT_SHORT_PHONE_VIBRATE :
       [SnowSound nameForKey:SNOW_ALERT_SHORT_PHONE_VIBRATE]

  };

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;

  // Uncomment the following line to display an Edit button in the navigation
  // bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;

  [self createAndAddPreviewPanel];

    _previewSoundName.text =  [SnowSound nameForKey:_selectedSound.soundName];

  [self togglePlayerFor:nil];

  [self presentPlayer];
}

- (void)viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [self audioInterrupt:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [[_soundList allValues] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"basic"
                                      forIndexPath:indexPath];

  // Configure the cell...
  cell.backgroundColor = [UIColor clearColor];
  cell.tintColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].primary;
  cell.textLabel.textColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].textColor;

  if ([_selectedSound.soundName
          isEqualToString:[[_soundList allKeys] objectAtIndex:indexPath.row]]) {
    cell.textLabel.font =
        [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    cell.textLabel.font =
        [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:28];
    //_selectedCell = cell;
  } else {
    cell.textLabel.font =
        [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  }

  cell.textLabel.text = [[_soundList allValues] objectAtIndex:indexPath.row];

  return cell;
}

#pragma mark - Table view delegates

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  [self.tableView deselectRowAtIndexPath:indexPath animated:NO];

  if ([_aPlayer isPlaying]) {
    [_aPlayer stop];
    _playPause.selected = NO;
  }

  /*
 UITableViewCell *cell =
  [self tableView:tableView cellForRowAtIndexPath:indexPath];
  */

  if ([_selectedSound.soundName
          isEqualToString:[[_soundList allKeys] objectAtIndex:indexPath.row]]) {
    // [self togglePlayerFor:indexPath];
    if (_isPlayerUp) {
      [self dismissPlayer];
    } else {
      [self presentPlayer];
    }
    return;

  } else {

    _selectedSound = [[SnowSound alloc]
        initWithSoundName:[[_soundList allKeys] objectAtIndex:indexPath.row]];

    [[SnowAppearanceManager sharedInstance] setCurrentAlertTone:_selectedSound];
    [[SnowAppearanceManager sharedInstance]
        saveDefaultAlertTone:_selectedSound];

    [self.tableView reloadData];

    [self togglePlayerFor:indexPath];
    [self presentPlayer];
  }
}

#pragma mark - VIEWS

- (void)createAndAddPreviewPanel {

  // ======== WRAPPER ===========================================

  UIView *wrapper = [[UIView alloc] initWithFrame:self.tableView.bounds];
  _wrapper = wrapper;

  wrapper.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
                             UIViewAutoresizingFlexibleRightMargin |
                             UIViewAutoresizingFlexibleTopMargin |
                             UIViewAutoresizingFlexibleBottomMargin;

  wrapper.backgroundColor = [UIColor whiteColor];

  CGRect hiddenPlayerFrame =
      CGRectMake(0, self.tableView.bounds.size.height + 10,
                 self.tableView.bounds.size.width, 60);

  _wrapper.frame = hiddenPlayerFrame;

  
    
  [self.tableView addSubview:wrapper];

  // ================ PLAYER CONTAINER =========================

  _playerContainer = [[UIView alloc] initWithFrame:_wrapper.bounds];
  _playerContainer.backgroundColor =
      [UIColor colorWithRed:.95 green:.95 blue:.95 alpha:.85];
    
    _playerContainer.layer.masksToBounds = YES;
    _playerContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    _playerContainer.layer.shadowOffset = CGSizeMake(0, 0);
    _playerContainer.layer.shadowRadius = 10;
    _playerContainer.layer.shadowOpacity = 0.5;

  [wrapper addSubview:_playerContainer];

  // ========== PREVIEW LABEL  ==============================

  _previewContainer = [[UIView alloc] init];

  _previewSoundName =
      [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 40)];
   //_previewSoundName.layer.borderWidth = 1;
   //_previewSoundName.layer.borderColor = [UIColor blackColor].CGColor;
  _previewSoundName.textColor = [UIColor darkGrayColor];
  _previewSoundName.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];

  [_playerContainer addSubview:_previewSoundName];

  // ============  PLAY BUTTON ============================

  _playPause = [[UIButton alloc]
      initWithFrame:CGRectMake(_previewSoundName.bounds.size.width + 5, 5, 50,
                               50)];

  [_playPause
      setImage:[UIImage getTintedImage:
                            [UIImage imageNamed:@"snow_preview_play_black"]
                             withColor:[[SnowAppearanceManager
                                                sharedInstance] currentTheme]
                                           .primary]
      forState:UIControlStateNormal];
    
    [_playPause
     setImage:[UIImage getTintedImage:
               [UIImage imageNamed:@"snow_preview_pause_black"]
                            withColor:[[SnowAppearanceManager
                                        sharedInstance] currentTheme]
               .primary]
     forState:UIControlStateSelected];

    
    
    
    

  /*
    
  [_playPause setImage:[UIImage imageNamed:@"snow_preview_play_black"]
              forState:UIControlStateNormal];
  [_playPause setImage:[UIImage imageNamed:@"snow_preview_pause_black"]
              forState:UIControlStateSelected];
   */
    
    

  [_playPause addTarget:self
                 action:@selector(playSound:)
       forControlEvents:UIControlEventTouchUpInside];

  // _playPause.layer.borderWidth = 1;
  //_playPause.layer.borderColor = [UIColor redColor].CGColor;
  [_playerContainer addSubview:_playPause];
}

- (void)viewWillLayoutSubviews {

  if (_isAnimationOngoing) {
    return;
  }

  CGRect visiblePlayerFrame =
      CGRectMake(0, self.tableView.bounds.size.height - 60,
                 self.tableView.bounds.size.width, 60);

  CGRect hiddenPlayerFrame =
      CGRectMake(0, self.tableView.bounds.size.height + 10,
                 self.tableView.bounds.size.width, 60);

  if (_isPlayerUp) {
    _wrapper.frame = visiblePlayerFrame;
  } else {

    _wrapper.frame = hiddenPlayerFrame;
  }

  //    _wrapper.frame = hiddenPlayerFrame;

  // _playerContainer.frame = _wrapper.bounds;

  /*
  CGRectMake(0, _wrapper.bounds.size.height - 60,
                                    _wrapper.bounds.size.width, 60);
*/
}

#pragma mark - PLAYER MANAGEMENT

- (void)presentPlayer {
    
    _wrapper.alpha =1;

  CGRect visiblePlayerFrame =
      CGRectMake(0, self.tableView.bounds.size.height - 60,
                 self.tableView.bounds.size.width, 60);

  if (_isPlayerUp) {
    return;
  }

  _isAnimationOngoing = YES;

  [UIView animateWithDuration:.2
      delay:.1
      options:UIViewAnimationOptionCurveEaseIn
      animations:^{
        _wrapper.frame = visiblePlayerFrame;
      }
      completion:^(BOOL finished) {
        _isPlayerUp = YES;
        _isAnimationOngoing = NO;
      }];
}

- (void)dismissPlayer {
  CGRect hiddenPlayerFrame =
      CGRectMake(0, self.tableView.bounds.size.height + 10,
                 self.tableView.bounds.size.width, 60);

  if (!_isPlayerUp) {
    return;
  }

  _isAnimationOngoing = YES;

  [UIView animateWithDuration:.1
      delay:.1
      options:UIViewAnimationOptionCurveEaseIn
      animations:^{
        _wrapper.frame = hiddenPlayerFrame;
      }
      completion:^(BOOL finished) {
        _isPlayerUp = NO;
        _isAnimationOngoing = NO;
          _wrapper.alpha = 0;
      }];
}

- (void)togglePlayerFor:(NSIndexPath *)index {

  if (index) {
    _previewSoundName.text =  [SnowSound nameForKey:  [[_soundList allKeys ] objectAtIndex:index.row] ];
  }

  [self prepPlayer];
}

- (void)playSound:(id)sender {
  UIButton *button = (UIButton *)sender;
  button.selected = !button.selected;

  if ([_aPlayer isPlaying]) {
    [_aPlayer stop];
  } else {
    [_aPlayer play];
  }
}

- (void)prepPlayer {

  _aPlayer = nil;

  NSError *audioErr;

  NSString *defaultSoundFileNameWithExtension =
      [[SnowAppearanceManager sharedInstance] currentAlertTone].soundName;

  NSString *defaultSoundFileNameExtension =
      [[defaultSoundFileNameWithExtension componentsSeparatedByString:@"."]
          objectAtIndex:1];
  NSString *defaultSoundFileName =
      [[defaultSoundFileNameWithExtension componentsSeparatedByString:@"."]
          objectAtIndex:0];


  NSString *alertSoundFilePath =
      [[NSBundle mainBundle] pathForResource:defaultSoundFileName
                                      ofType:defaultSoundFileNameExtension];

  if (!alertSoundFilePath) {
    NSLog(@"Could not find sound file ");
  }

  NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:alertSoundFilePath];

  _aPlayer =
      [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&audioErr];

  _aPlayer.delegate = self;

  [_aPlayer prepareToPlay];

  _aPlayer.numberOfLoops = 1; // infinite
}

#pragma mark - AVAUDIO DELEGATE

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag {
  _playPause.selected = NO;
}

#pragma mark - AVAudioSessionNotifications callback
- (void)audioInterrupt:(NSNotification *)notif {
  NSLog(@"AUDIO INTERRUPT ...... >>>>>>>>>>>>>>>>>>>>>>");
  if (_aPlayer) {
    [_aPlayer stop];
    [_playPause setSelected:NO];
  }
}

@end
