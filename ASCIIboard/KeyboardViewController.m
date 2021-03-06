//
//  KeyboardViewController.m
//  ASCIIboard
//
//  Created by Matt Condon on 9/22/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import "KeyboardViewController.h"
#import "Masonry.h"
#import "UIImage+ASCII.h"
#import "UIColor+Random.h"
#import "POP.h"
#import "AKBrushButton.h"
#import "Config.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "AKCharacterPackManager.h"
#import "RKDropdownAlert.h"
#import "AKLogManager.h"

@implementation KeyboardViewController

#pragma mark - KeyboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _hasFullAccess = [self isFullAccessGranted];
    if (_hasFullAccess) {
        // if we have open access, we can access the network / filesystem, so enable logging
        [Fabric with:@[CrashlyticsKit]];
    }

    // LOAD KLUDGE so that height can change -_-
    [self loadKludge];

    // INITS
    self.insertHistory = [[NSMutableArray alloc] init];

    // LAYOUT

    // bg color
    [self.view setBackgroundColor:ASKEY_KEYBOARD_BACKGROUND_COLOR];

    // setup draw sheets

    self.sheetBackground = [[UIView alloc] init];
    self.sheetBackground.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.sheetBackground];

    // set up top border thing
    UIView *borderView = [[UIView alloc] init];
    [borderView setBackgroundColor:[UIColor blackColor]];
    borderView.alpha = 0.1f;
    [self.view addSubview:borderView];

    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(1.0f));
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
    }];

    [self saveLog:@"ASKEY_OPENED" withParams:nil];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self createButtons];

    // add constraints
    [self establishConstraints];

    [self makeKeyboardHeight:ASKEY_HEIGHT];

    [self updateButtonStatus];


    MCDrawSheet *firstSheet = [self generateDrawSheet];

    // sheet constraints (they're actually not shitty)
    [self.sheetBackground mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.view);
        make.width.equalTo(firstSheet.mas_height).multipliedBy(ASKEY_WIDTH_RATIO);
        make.center.equalTo(self.view);
    }];

    [NSTimer scheduledTimerWithTimeInterval:INITIAL_SHEET_DELAY target:self selector:@selector(animateSheetInWithTimer:) userInfo:firstSheet repeats:NO];


    if (_hasFullAccess) {
        self.characterSets = [[AKCharacterPackManager sharedManager] characterSets];
    } else {
        // The original pack must be completely filled out (because we can't load it from disk)
        // -> everything else just needs to be presented as a button that they can't select
        self.characterSets = [NSMutableArray arrayWithArray:@[
                                                              @{
                                                                  @"enabled": @YES,
                                                                  @"purchased": @NO,
                                                                  @"keyName": @"text",
                                                                  @"icon": @"!;'",
                                                                  @"packs": @[
                                                                              @{
                                                                                  @"keyName": @"original",
                                                                                  @"displayName": @"Original",
                                                                                  @"icon": @"!;'",
                                                                                  @"enabled": @YES,
                                                                                  @"width": @32,
                                                                                  @"height": @11,
                                                                                  @"chars": @{
                                                                                          @"0": @[@" "],
                                                                                          @"1": @[@"."],
                                                                                          @"2": @[@"."],
                                                                                          @"3": @[@","],
                                                                                          @"4": @[@","],
                                                                                          @"5": @[@"'"],
                                                                                          @"6": @[@"'"],
                                                                                          @"7": @[@":"],
                                                                                          @"8": @[@":"],
                                                                                          @"9": @[@"!", @";"],
                                                                                          }
                                                                                  },
                                                                              @{
                                                                                  @"enabled": @NO,
                                                                                  @"purchased": @NO,
                                                                                  @"keyName": @"code",
                                                                                  @"icon": @"#!"
                                                                                  }
                                                                          ]
                                                                  },
                                                                @{
                                                                    @"enabled": @NO,
                                                                    @"purchased": @NO,
                                                                    @"keyName": @"emoji",
                                                                    @"icon": @"😀",
                                                                    @"packs": @[
                                                                            @{
                                                                                @"enabled": @NO,
                                                                                @"purchased": @NO,
                                                                                @"keyName": @"emojiface",
                                                                                @"icon": @"😄"
                                                                            },
                                                                            @{
                                                                                @"enabled": @NO,
                                                                                @"purchased": @NO,
                                                                                @"keyName": @"emojifood",
                                                                                @"icon": @"🍕"
                                                                                },
                                                                            @{
                                                                                @"enabled": @NO,
                                                                                @"purchased": @NO,
                                                                                @"keyName": @"emojianimals",
                                                                                @"icon": @"🐋"
                                                                                },
                                                                            @{
                                                                                @"enabled": @NO,
                                                                                @"purchased": @NO,
                                                                                @"keyName": @"emojihearts",
                                                                                @"icon": @"💖"
                                                                                }
                                                                        ]
                                                                },
                                                              @{
                                                                  @"enabled": @NO,
                                                                  @"purchased": @NO,
                                                                  @"keyName": @"mail",
                                                                  @"icon": @"📧",
                                                                  @"packs": @[
                                                                          @{
                                                                              @"enabled": @NO,
                                                                              @"purchased": @NO,
                                                                              @"keyName": @"originalmail",
                                                                              @"icon": @"!;'"
                                                                              },
                                                                          @{
                                                                              @"enabled": @NO,
                                                                              @"purchased": @NO,
                                                                              @"keyName": @"emojimail",
                                                                              @"icon": @"😄"
                                                                              }
                                                                          ]
                                                                  }
                                                              ]];
    }
    if ([self.characterSets count] == 0) {
        CLS_LOG(@"No character packs found.");
    }

    // set to first pack
    if (_hasFullAccess) {
        NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:ASKEY_CONTAINER_GROUP_NAME];

        if (![defaults objectForKey:@"_currentCharacterSet"]) {
            [defaults setObject:[NSNumber numberWithInt:0] forKey:@"_currentCharacterSet"];
        }

        if (![defaults objectForKey:@"_currentPackIndex"]) {
            [defaults setObject:[NSNumber numberWithInt:0] forKey:@"_currentPackIndex"];
        }

        [defaults synchronize];

        _currentCharacterSet = [[defaults objectForKey:@"_currentCharacterSet"] intValue];
        int currentPackIndex = [[defaults objectForKey:@"_currentPackIndex"] intValue];
        [self setCurrentCharacterPack:[[[self.characterSets objectAtIndex:_currentCharacterSet] objectForKey:@"packs"] objectAtIndex:currentPackIndex]];
    } else {
        // else default to original
        [self setCurrentCharacterPack:[[[self.characterSets objectAtIndex:0] objectForKey:@"packs"] objectAtIndex:0]];
        _currentCharacterSet = 0;
    }

}

- (void)setCurrentCharacterPack:(NSMutableDictionary *)pack
{
    
    [self.numpadButton setTitle:[pack objectForKey:@"icon"] forState:UIControlStateNormal];
    _currentCharacterPack = pack;
}

- (void)createButtons
{
    // LEFT SIDE

    // BRUSH BUTTON
    self.brushButton = [[MCBouncyButton alloc] initWithImage:[UIImage imageNamed:@"pen"] andRadius:(BUTTON_HEIGHT/2.0f)];
    [self.brushButton addTarget:self action:@selector(brushButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.brushButton setAdjustsImageWhenDisabled:NO];
    [self.brushButton setStyle:MCBouncyButtonStyleSelected animated:NO];

    // ERASER BUTTON
    self.eraserButton = [[MCBouncyButton alloc] initWithImage:[UIImage imageNamed:@"eraser"] andRadius:(BUTTON_HEIGHT/2.0f)];
    [self.eraserButton addTarget:self action:@selector(eraserButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    // NUMPAD BUTTON
    self.numpadButton = [[MCBouncyButton alloc] initWithText:@"123" andRadius:(BUTTON_HEIGHT/2.0f)];
    [self.numpadButton addTarget:self action:@selector(characterSetButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *numpadRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(numpadButtonPressed:)];
    numpadRecognizer.minimumPressDuration = ASKEY_HOLD_DURATION;
    [self.numpadButton addGestureRecognizer:numpadRecognizer];

    // NEXT BUTTON
    self.nextKeyboardButton = [[MCBouncyButton alloc] initWithImage:[UIImage imageNamed:@"globe"] andRadius:(BUTTON_HEIGHT/2.0f)];
    [self.nextKeyboardButton addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];

    // RIGHT SIDE

    // ENTER BUTTON
    self.enterButton = [[MCBouncyButton alloc] initWithImage:[UIImage imageNamed:@"return"] andRadius:(BUTTON_HEIGHT/2.0f)];
    [self.enterButton addTarget:self action:@selector(enterDown:) forControlEvents:UIControlEventTouchDown];
    [self.enterButton addTarget:self action:@selector(enterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *enterRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(enterButtonHeld:)];
    enterRecognizer.minimumPressDuration = ASKEY_HOLD_DURATION;
    [self.enterButton addGestureRecognizer:enterRecognizer];

    // BACKSPACE BUTTON
    self.backspaceButton = [[MCBouncyButton alloc] initWithImage:[UIImage imageNamed:@"backspace"] andRadius:(BUTTON_HEIGHT/2.0f)];
    [self.backspaceButton addTarget:self action:@selector(backspaceButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [self.backspaceButton addTarget:self action:@selector(backspaceButtonReleased:) forControlEvents:UIControlEventTouchUpOutside];
    UILongPressGestureRecognizer *backspaceRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(backspaceButtonHeld:)];
    [self.backspaceButton addGestureRecognizer:backspaceRecognizer];


    // UNDO BUTTON
    self.undoButton = [[MCBouncyButton alloc] initWithImage:[UIImage imageNamed:@"undo"] andRadius:(BUTTON_HEIGHT/2.0f)];
    [self.undoButton addTarget:self action:@selector(undoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    // CLEAR BUTTON
    self.clearButton = [[MCBouncyButton alloc] initWithImage:[UIImage imageNamed:@"trash"] andRadius:(BUTTON_HEIGHT/2.0f)];
    [self.clearButton addTarget:self action:@selector(clearButtonPressed:) forControlEvents:UIControlEventTouchUpInside];


    // ADD VIEWS TO SELF.VIEW
    [self.view addSubview:self.brushButton];
    [self.view addSubview:self.eraserButton];
    [self.view addSubview:self.numpadButton];
    [self.view addSubview:self.nextKeyboardButton];

    [self.view addSubview:self.enterButton];
    [self.view addSubview:self.backspaceButton];
    [self.view addSubview:self.undoButton];
    [self.view addSubview:self.clearButton];
}

- (void)makeKeyboardHeight:(float)height
{
    if (_heightConstraint != nil) {
        [self.view removeConstraint:_heightConstraint];
    }

    _heightConstraint =
        [NSLayoutConstraint constraintWithItem: self.view
                                     attribute: NSLayoutAttributeHeight
                                     relatedBy: NSLayoutRelationEqual
                                        toItem: nil
                                     attribute: NSLayoutAttributeNotAnAttribute
                                    multiplier: 0.0
                                      constant: height];
    [self.view addConstraint: _heightConstraint];

}


- (void)loadKludge
{
    if (kludge == nil) {
        kludge = [[UIView alloc] init];
        [self.view addSubview:kludge];
        kludge.translatesAutoresizingMaskIntoConstraints = NO;
        kludge.hidden = YES;

        [kludge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view.mas_left);
            make.top.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_top);
        }];

    }
}

- (void)establishConstraints
{
    // MAKE SPACERS
    UIView *spacerLeftLeft = [[UIView alloc] init];
    spacerLeftLeft.backgroundColor = [self spacerColor];
    [self.view addSubview:spacerLeftLeft];

    UIView *spacerLeftRight = [[UIView alloc] init];
    spacerLeftRight.backgroundColor = [self spacerColor];
    [self.view addSubview:spacerLeftRight];

    UIView *spacerRightLeft = [[UIView alloc] init];
    spacerRightLeft.backgroundColor = [self spacerColor];
    [self.view addSubview:spacerRightLeft];

    UIView *spacerRightRight = [[UIView alloc] init];
    spacerRightRight.backgroundColor = [self spacerColor];
    [self.view addSubview:spacerRightRight];

    [spacerLeftLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.centerY.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.2f);
        make.width.greaterThanOrEqualTo(@(0));
    }];
    [spacerLeftRight mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(spacerLeftLeft);
        make.right.equalTo(self.sheetBackground.mas_left);
        make.centerY.equalTo(self.view);
    }];
    [spacerRightLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(spacerLeftLeft);
        make.left.equalTo(self.sheetBackground.mas_right);
        make.centerY.equalTo(self.view);
    }];
    [spacerRightRight mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(spacerLeftLeft);
        make.right.and.centerY.equalTo(self.view);
    }];


    int numSpacers = 5;

    NSMutableArray *spacers = [[NSMutableArray alloc] initWithCapacity:numSpacers];

    for (int i = 0; i < numSpacers; ++i) {
        // need 5 spacers on the right
        UIView *spacer = [[UIView alloc] init];
        spacer.backgroundColor = [self spacerColor];
        [self.view addSubview:spacer];

        [spacers addObject:spacer];

        [spacer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.view.mas_width).multipliedBy(0.1);
            if (i == 0) {
                // first
                make.height.greaterThanOrEqualTo(@(0));
                make.top.equalTo(self.view);
            } else if (i == numSpacers - 1) {
                // last
                make.height.and.centerX.equalTo(spacers[0]);
                make.bottom.equalTo(self.view);
            } else {
                // if any but the first one, inherit height and width and centerX
                make.height.and.centerX.equalTo(spacers[0]);
            }
        }];
    }


    [self.brushButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(spacerLeftLeft.mas_right);
        make.right.equalTo(spacerLeftRight.mas_left);
        make.width.equalTo(self.brushButton.mas_height);
        make.height.equalTo(@(BUTTON_HEIGHT));
        make.centerY.equalTo(self.enterButton);
    }];
    [self.eraserButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.height.equalTo(self.brushButton);
        make.centerY.equalTo(self.backspaceButton);
    }];
    [self.numpadButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.height.equalTo(self.brushButton);
        make.centerY.equalTo(self.undoButton);
    }];
    [self.nextKeyboardButton mas_remakeConstraints:^(MASConstraintMaker *make){
        make.left.right.and.height.equalTo(self.brushButton);
        make.centerY.equalTo(self.clearButton);
    }];



    [self.enterButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(spacerRightLeft.mas_right);
        make.right.equalTo(spacerRightRight.mas_left);
        make.width.equalTo(self.enterButton.mas_height);
        make.height.equalTo(@(BUTTON_HEIGHT));

        make.top.equalTo(((UIView *)spacers[0]).mas_bottom);
        make.bottom.equalTo(((UIView *)spacers[1]).mas_top);

    }];
    [self.backspaceButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.and.width.equalTo(self.enterButton);

        make.top.equalTo(((UIView *)spacers[1]).mas_bottom);
        make.bottom.equalTo(((UIView *)spacers[2]).mas_top);
    }];
    [self.undoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.and.width.equalTo(self.enterButton);

        make.top.equalTo(((UIView *)spacers[2]).mas_bottom);
        make.bottom.equalTo(((UIView *)spacers[3]).mas_top);
    }];
    [self.clearButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.and.width.equalTo(self.enterButton);

        make.top.equalTo(((UIView *)spacers[3]).mas_bottom);
        make.bottom.equalTo(((UIView *)spacers[4]).mas_top);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
    [self saveLog:@"DID_RECEIVE_MEMORY_WARNING" withParams:nil];
}

- (void)viewDidLayoutSubviews
{
    static ASKEYScreenOrientation previousOrientation = ASKEYScreenOrientationUnknown;

    int appExtensionWidth = (int)round(self.view.frame.size.width);

    int possibleScreenWidthValue1 = (int)round([[UIScreen mainScreen] bounds].size.width);
    int possibleScreenWidthValue2 = (int)round([[UIScreen mainScreen] bounds].size.height);

    int screenWidthValue;

    if (possibleScreenWidthValue1 < possibleScreenWidthValue2) {
        screenWidthValue = possibleScreenWidthValue1;
    } else {
        screenWidthValue = possibleScreenWidthValue2;
    }

    ASKEYScreenOrientation currentOrientation = (appExtensionWidth == screenWidthValue) ? ASKEYScreenOrientationPortrait : ASKEYScreenOrientationLandscape;

    if (currentOrientation != previousOrientation) {
        [characterSetMenu hide];
        [characterPackMenu hide];
        previousOrientation = currentOrientation;
    }

}

#pragma mark - Button Handlers

- (void)brushButtonPressed:(UIButton *)sender
{
    // select brush
    self.currentSheet.drawView.drawTool = ACEDrawingToolTypePen;
    self.currentSheet.drawView.lineWidth = BRUSH_SIZE_LARGE;
    [self setBrushSelected];

    [self saveLog:@"BRUSH_BUTTON_CLICKED" withParams:nil];
}

- (void)clearButtonPressed:(UIButton *)sender
{
    [self.currentSheet.drawView clear];
    [self updateButtonStatus];

    [self saveLog:@"CLEAR_BUTTON_CLICKED" withParams:nil];
}

- (void)eraserButtonPressed:(UIButton *)sender
{
    self.currentSheet.drawView.drawTool = ACEDrawingToolTypeEraser;
    [self setEraserSelected];

    [self saveLog:@"ERASER_BUTTON_CLICKED" withParams:nil];
}

- (void)characterSetButtonPressed:(UIButton *)sender
{

    _bubbleWasTapped = NO;

    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:[self.characterSets count]];
    for (NSMutableDictionary *set in self.characterSets) {
        MCBouncyButton *button = [[MCBouncyButton alloc] initWithText:[set objectForKey:@"icon"] andRadius:(BUTTON_HEIGHT * BRUSH_BUTTON_RELATIVE_SIZE / 2.0f)];
        if (![[set objectForKey:@"enabled"] boolValue]) {
            // is not enabled
            [button setStyle:MCBouncyButtonStyleDefault animated:YES];
        } else if ([[set objectForKey:@"keyName"] isEqualToString:[[self.characterSets objectAtIndex:_currentCharacterSet] objectForKey:@"keyName"]]) {
            // if this is the currently selected pack, highlight it
            [button setStyle:MCBouncyButtonStyleSelected animated:YES];
        }
        [buttons addObject:button];

    }
    self.characterSetButtonsArray = [NSArray arrayWithArray:buttons];

    characterSetMenu = [[LIVBubbleMenu alloc] initWithPoint:self.numpadButton.center radius:self.numpadButton.frame.size.width * 1.8f menuItems:self.characterSetButtonsArray inView:self.view];
    characterSetMenu.bubbleStartAngle = -70;
    characterSetMenu.bubbleTotalAngle = 140;
    characterSetMenu.bubbleRadius = (BUTTON_HEIGHT*BRUSH_BUTTON_RELATIVE_SIZE) / 2.0f;
    characterSetMenu.bubbleShowDelayTime = 0.1f;
    characterSetMenu.bubbleHideDelayTime = 0.1f;
    characterSetMenu.bubbleSpringBounciness = 5.0f;
    characterSetMenu.bubblePopInDuration = 0.3f;
    characterSetMenu.bubblePopOutDuration = 0.3f;
    characterSetMenu.backgroundFadeDuration = 0.3f;
    characterSetMenu.backgroundAlpha = 0.3f;
    characterSetMenu.customButtons = YES;
    characterSetMenu.delegate = self;

    [characterSetMenu show];
    self.numpadButton.enabled = NO;
    [self.view bringSubviewToFront:self.numpadButton];

    [self saveLog:@"CHARACTER_SET_BUTTON_CLICKED" withParams:nil];
}

- (void)showMenuForSet:(NSDictionary *)set
{
    _bubbleWasTapped = NO;

    [self saveLog:@"SET_BUTTON_CLICKED" withParams:@{@"set": [set objectForKey:@"keyName"]}];

    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:[[set objectForKey:@"packs"] count]];
    for (NSMutableDictionary *pack in [set objectForKey:@"packs"]) {
        MCBouncyButton *button = [[MCBouncyButton alloc] initWithText:[pack objectForKey:@"icon"] andRadius:(BUTTON_HEIGHT * BRUSH_BUTTON_RELATIVE_SIZE / 2.0f)];
        if ([[pack objectForKey:@"keyName"] isEqualToString:[_currentCharacterPack objectForKey:@"keyName"]]) {
            // if this is the currently selected pack, highlight it
            [button setStyle:MCBouncyButtonStyleSelected animated:YES];
        } else if ([[[self.characterSets objectAtIndex:_currentCharacterSet] objectForKey:@"purchased"] boolValue]) {
            // pack was purchased, don't do anything
        } else if (![[pack objectForKey:@"enabled"] boolValue]) {
            // pack was not purchased and pack is not enabled by default
            [button setStyle:MCBouncyButtonStyleDefault animated:YES];
        }
        [buttons addObject:button];

    }
    self.characterPackButtonsArray = [NSArray arrayWithArray:buttons];

    characterPackMenu = [[LIVBubbleMenu alloc] initWithPoint:self.numpadButton.center radius:self.numpadButton.frame.size.width * 1.8f menuItems:self.characterPackButtonsArray  inView:self.view];
    characterPackMenu.bubbleStartAngle = -70;
    characterPackMenu.bubbleTotalAngle = 140;
    characterPackMenu.bubbleRadius = (BUTTON_HEIGHT*BRUSH_BUTTON_RELATIVE_SIZE) / 2.0f;
    characterPackMenu.bubbleShowDelayTime = 0.1f;
    characterPackMenu.bubbleHideDelayTime = 0.1f;
    characterPackMenu.bubbleSpringBounciness = 5.0f;
    characterPackMenu.bubblePopInDuration = 0.3f;
    characterPackMenu.bubblePopOutDuration = 0.3f;
    characterPackMenu.backgroundFadeDuration = 0.3f;
    characterPackMenu.backgroundAlpha = 0.3f;
    characterPackMenu.customButtons = YES;
    characterPackMenu.delegate = self;

    [characterPackMenu show];
    self.numpadButton.enabled = NO;
    [self.view bringSubviewToFront:self.numpadButton];
}

- (void)enterButtonHeld:(UIButton *)sender
{
    [self enterButtonPressed:sender];
    enterButtonWasHeld = YES;
    [self.textDocumentProxy insertText:@"\n"];
    [self.insertHistory removeAllObjects];
}

- (void)numpadButtonPressed:(UIButton *)sender
{
    // instantiate if necessary
    if (!self.numpadView) {
        self.numpadView = [[AKNumPadView alloc] initWithFrame:self.view.frame];
        // set up button handlers
        // back
        [self.numpadView.backButton addTarget:self action:@selector(removeNumPad:) forControlEvents:UIControlEventTouchDown];
        // next
        [self.numpadView.nextKeyboardButton addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];
        // backspace
        [self.numpadView.deleteButton addTarget:self action:@selector(numpadBackspaceButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [self.numpadView.deleteButton addTarget:self action:@selector(backspaceButtonReleased:) forControlEvents:UIControlEventTouchUpOutside];
        UILongPressGestureRecognizer *backspaceRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(backspaceButtonHeld:)];
        [self.numpadView.deleteButton addGestureRecognizer:backspaceRecognizer];
        // everyone else
        for (MCBouncyButton *btn in self.numpadView.numpadButtons) {
            [btn addTarget:self action:@selector(numpadNumberButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        // add and to view
        [self.view addSubview:self.numpadView];
    } else {
        [self.view addSubview:self.numpadView];
    }
    // constrain
    [self.numpadView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)removeNumPad:(MCBouncyButton *)sender
{
    [self.numpadView removeFromSuperview];
    self.numpadView = nil;
}

- (void)numpadBackspaceButtonPressed:(MCBouncyButton *)sender
{
    [self.textDocumentProxy deleteBackward];
}

- (void)numpadNumberButtonPressed:(MCBouncyButton *)sender
{
    [self.textDocumentProxy insertText:[sender currentTitle]];
}

- (void)enterDown:(UIButton *)sender
{
    enterButtonWasHeld = NO;
}
- (void)enterButtonPressed:(UIButton *)sender
{
    if (enterButtonWasHeld) {
        return;
    }
    CGSize numBlocks = CGSizeMake([[_currentCharacterPack objectForKey:@"width"] integerValue],
                                  [[_currentCharacterPack objectForKey:@"height"] integerValue]);
    BOOL isMail = [[[self.characterSets objectAtIndex:_currentCharacterSet] objectForKey:@"keyName"] isEqualToString:@"mail"];
    NSString *text = [self.currentSheet.drawView.image getASCIIWithResolution:numBlocks andChars:[_currentCharacterPack objectForKey:@"chars"] andIsHardwrapped:isMail];

    // has text, normal space, or unicode space
    if (![self.textDocumentProxy hasText] && ([[text substringToIndex:1] isEqualToString:@" "] || [[text substringToIndex:1] isEqualToString:@" "])) {
        // if textField is empty
        // strip extra white space
        text = [self removeExtraWhiteSpaceLinesFromText:text withSize:numBlocks];
        // and insert period
        text = [text stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"."];
    }

    // insert into textField
    if (text != nil && text.length) {
        [self.insertHistory insertObject:@([text length]) atIndex:0];
        [self.textDocumentProxy insertText:text];

    }
    // update UI
    [self updateButtonStatus];
    [self incrementSheets];

    [self saveLog:@"ASKEY_TEXT" withParams:@{@"pack": [_currentCharacterPack objectForKey:@"keyName"]}];

}

- (void)backspaceButtonReleased:(UIButton *)sender
{
    [holdTimer invalidate];
}

- (void)backspaceButtonPressed:(UIButton *)sender
{
    if ([self.insertHistory count]) {
        NSNumber *lastTextCount = [self.insertHistory objectAtIndex:0];
        [self.insertHistory removeObjectAtIndex:0];
        for (int i = 0; i < [lastTextCount intValue]; i++) {
            [self.textDocumentProxy deleteBackward];
        }
    } else {
        [self.textDocumentProxy deleteBackward];
    }
    [self updateButtonStatus];
    [self backspaceButtonReleased:sender];
}

- (void)backspaceButtonHeld:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        // only repeat delete if we don't have history
        if ([self.insertHistory count]) {
            [self backspaceButtonPressed:nil];
        } else {
            holdTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(backspaceButtonRepeat:) userInfo:nil repeats:YES];
        }
    } else {
        [holdTimer invalidate];
    }
}

- (void)backspaceButtonRepeat:(UIButton *)sender
{
    [self.textDocumentProxy deleteBackward];
    [self updateButtonStatus];
}
- (void)undoButtonPressed:(UIButton *)sender
{
    [self.currentSheet.drawView undoLatestStep];
    [self updateButtonStatus];
}

- (void)updateButtonStatus
{
    // enable button if there is still stuff to backspace
    self.undoButton.enabled = [self.currentSheet.drawView canUndo];
    self.backspaceButton.enabled = (BOOL)[self.insertHistory count] ||
                                   !([self.textDocumentProxy documentContextBeforeInput] == nil ||
                                   [[self.textDocumentProxy documentContextBeforeInput] isEqualToString:@""]) ||
                                    [self.textDocumentProxy hasText];
}

#pragma mark - MCDrawSheet Movement

- (void)incrementSheets
{
    // moves both sheets upwards, making a new sheet after previousSheet is out of the view
    // makes currentSheet previousSheet and then makes _newSheet currentSheet
    if (self.previousSheet != nil) {
        // animate out and then reassign
        MCDrawSheet *tempSheet = self.previousSheet;
        POPSpringAnimation *anim = [self.previousSheet pop_animationForKey:@"previousSheetSlideOut"];
        if (!anim) {
            anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        }
        anim.toValue = @(-ASKEY_HEIGHT);
        anim.velocity = @(SHEET_VELOCITY);
        anim.name = @"previousSheetSlideOut";
        anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
            [tempSheet removeFromSuperview];
        };
        [tempSheet pop_addAnimation:anim forKey:@"previousSheetSlideOut"];
    }
    // now pop them into position!

    // CURRENT SHEET
    [self.currentSheet listenForGestures];
    self.currentSheet.userInteractionEnabled = NO;
    POPSpringAnimation *anim = [self.currentSheet pop_animationForKey:@"currentSheetSlideOut"];
    if (!anim) {
        anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    }
    anim.toValue = @((-self.currentSheet.frame.size.height + RELATIVE_SHEET_EXPOSED_HEIGHT * ASKEY_HEIGHT)/2);
    anim.velocity = @(SHEET_VELOCITY);
    anim.name = @"currentSheetSlideOut";
    [self.currentSheet pop_addAnimation:anim forKey:@"currentSheetSlideOut"];

    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0.65);
    [self.currentSheet.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];

    // NEW SHEET
    MCDrawSheet *newSheet = [self generateDrawSheet];
    [NSTimer scheduledTimerWithTimeInterval:INITIAL_SHEET_DELAY target:self selector:@selector(animateSheetInWithTimer:) userInfo:newSheet repeats:NO];

    self.enterButton.enabled = NO;

}

- (void)decrementSheets
{
    // move both sheets down, dropping currentSheet into the void
    // makes previousSheet currentSheet and then makes previousSheet nil

    self.enterButton.enabled = NO;


    // CURRENT SHEET
    POPSpringAnimation *anim = [self.currentSheet pop_animationForKey:@"currentSheetReset"];
    if (!anim) {
        anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    }
    anim.toValue = @(ASKEY_HEIGHT + self.currentSheet.frame.size.height/2);
    anim.velocity = @(SHEET_VELOCITY);
    anim.name = @"currentSheetReset";
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
    };
    [self.currentSheet pop_addAnimation:anim forKey:@"currentSheetReset"];


    // PREVIOUS SHEET
    [self.previousSheet unlistenForGestures];

    // reset opacity
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(1);
    [self.previousSheet.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];

    // move to center
    POPSpringAnimation *previousAnim = [self.previousSheet pop_animationForKey:@"currentSheetSlideOut"];
    if (!previousAnim) {
        previousAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    }
    previousAnim.toValue = @(self.sheetBackground.center.y);
    previousAnim.velocity = @(SHEET_VELOCITY);
    previousAnim.name = @"currentSheetSlideOut";
    previousAnim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        MCDrawSheet *tempSheet = self.currentSheet;
        self.currentSheet = self.previousSheet;

        [self.sheetBackground mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.view);
            make.width.equalTo(self.currentSheet.mas_height).multipliedBy(ASKEY_WIDTH_RATIO);
            make.center.equalTo(self.view);
        }];

        [tempSheet removeFromSuperview];
        self.previousSheet = nil;
        self.enterButton.enabled = YES;

    };
    [self.previousSheet pop_addAnimation:previousAnim forKey:@"currentSheetSlideOut"];

}

- (void)resetSheetsWithVelocity:(float)velocity
{
    // moves sheet back to established locations

    // PREVIOUS SHEET
    POPSpringAnimation *previousAnim = [self.previousSheet pop_animationForKey:@"currentSheetSlideOut"];
    if (!previousAnim) {
        previousAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    }
    previousAnim.toValue = @((-self.previousSheet.frame.size.height + RELATIVE_SHEET_EXPOSED_HEIGHT * ASKEY_HEIGHT)/2);
    previousAnim.velocity = @(velocity);
    previousAnim.name = @"currentSheetSlideOut";
    [self.previousSheet pop_addAnimation:previousAnim forKey:@"currentSheetSlideOut"];

    // CURRENT SHEET
    POPSpringAnimation *anim = [self.currentSheet pop_animationForKey:@"currentSheetReset"];
    if (!anim) {
        anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    }
    anim.toValue = @(self.sheetBackground.center.y);
    anim.velocity = @(velocity);
    anim.name = @"currentSheetReset";
    [self.currentSheet pop_addAnimation:anim forKey:@"currentSheetReset"];
}

- (void)drawSheet:(MCDrawSheet *)sheet wasMovedWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer
{

    static CGFloat initialY = 0;
    static CGFloat lastY = 0;

    CGPoint touchLocation = [panGestureRecognizer locationInView:self.view];

    switch ([panGestureRecognizer state]) {
        case UIGestureRecognizerStateBegan: {
            // get initial point
            initialY = touchLocation.y;
            lastY = touchLocation.y;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            // follow finger delta on vertical axis
            CGFloat dy = touchLocation.y - lastY;
            lastY = touchLocation.y;
            self.previousSheet.center = CGPointMake(self.previousSheet.center.x, self.previousSheet.center.y + dy);
            self.currentSheet.center = CGPointMake(self.currentSheet.center.x, self.currentSheet.center.y + dy);
            break;
        }
        case UIGestureRecognizerStateEnded: {
            // if we were throwing with enough velocity in a certain direction, move to that position
            // otherwise, do position threshold to check for new position
            // move to that position with any initial velocity
            float velocity = [panGestureRecognizer velocityInView:self.sheetBackground].y;
            float translation = touchLocation.y - initialY;

            if (velocity > SHEET_VELOCITY_THRESHOLD) {
                [self decrementSheets];
            } else if (translation > SHEET_TRANSLATION_THRESHOLD) {
                [self decrementSheets];
            } else {
                [self resetSheetsWithVelocity:velocity];
            }

            break;
        }
        default: {
            break;
        }
    }

}

- (void)drawSheet:(MCDrawSheet *)sheet wasTappedWithGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer
{
    // if it was tapped at all, that means to decrement sheets
    [self decrementSheets];
}


#pragma mark - ACEDrawing View Delegate

- (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool;
{
    [self updateButtonStatus];
}

#pragma mark - LIVBubbleMenu

//User selected a bubble
-(void)livBubbleMenu:(LIVBubbleMenu *)bubbleMenu tappedBubbleWithIndex:(NSUInteger)index {
    if (bubbleMenu == characterSetMenu) {
        _bubbleWasTapped = YES;
        if ([[[self.characterSets objectAtIndex:index] objectForKey:@"enabled"] boolValue]) {
            // if the set is enabled

            _lastCharacterSet = _currentCharacterSet;
            _currentCharacterSet = (int)index;

            // highlight selected and unselect last one
            for (int i = 0; i < [self.characterSetButtonsArray count]; i++) {
                if (i == index) {
                    [[self.characterSetButtonsArray objectAtIndex:(int)index] setStyle:MCBouncyButtonStyleSelected animated:YES];
                } else {
                    [[self.characterSetButtonsArray objectAtIndex:i] setStyle:MCBouncyButtonStyleDefault animated:YES];
                }
            }

            [self showMenuForSet:[self.characterSets objectAtIndex:_currentCharacterSet]];

        } else {
            // display error
            [self displayAccessError];
            self.numpadButton.enabled = YES;
        }
    } else if (bubbleMenu == characterPackMenu) {
        _bubbleWasTapped = YES;
        if ([[[self.characterSets objectAtIndex:_currentCharacterSet] objectForKey:@"purchased"] boolValue] ||
            [[[[[self.characterSets objectAtIndex:_currentCharacterSet] objectForKey:@"packs"] objectAtIndex:index] objectForKey:@"enabled"] boolValue]) {
            // if set purchased or pack enabled
            CLS_LOG(@"pack: {%i, %i}", _currentCharacterSet, (int)index);
            [self setCurrentCharacterPack:[[[self.characterSets objectAtIndex:_currentCharacterSet] objectForKey:@"packs"] objectAtIndex:(int)index]];

            _lastCharacterSet = _currentCharacterSet;

            if (_hasFullAccess) {
                NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:ASKEY_CONTAINER_GROUP_NAME];
                [defaults setObject:[NSNumber numberWithInt:_currentCharacterSet] forKey:@"_currentCharacterSet"];
                [defaults setObject:[NSNumber numberWithInt:(int)index] forKey:@"_currentPackIndex"];
            }

            // highlight selected and unselect last one
            for (int i = 0; i < [self.characterPackButtonsArray count]; i++) {
                if (i == index) {
                    [[self.characterPackButtonsArray objectAtIndex:index] setStyle:MCBouncyButtonStyleSelected animated:YES];
                } else {
                    [[self.characterPackButtonsArray objectAtIndex:i] setStyle:MCBouncyButtonStyleDefault animated:YES];
                }
            }
        } else {
            // display error
            [self displayAccessError];
        }
    }
}

- (void)displayAccessError
{
    RKDropdownAlert *alert = [[RKDropdownAlert alloc] initWithFrame:CGRectMake(0, -30, self.view.frame.size.width, 30)];
    [self.view addSubview:alert];
    [alert title:@"Enable Full Access to Use Character Packs" message:nil backgroundColor:ASKEY_BLUE_COLOR textColor:[UIColor whiteColor] time:1];



}

//The bubble menu has been hidden
-(void)livBubbleMenuDidHide:(LIVBubbleMenu *)bubbleMenu {

    if (bubbleMenu == characterSetMenu || bubbleMenu == characterPackMenu) {
        if (!_bubbleWasTapped) {
            // if the menus were dismissed, reset stuff, otherwise don't
            _currentCharacterSet = _lastCharacterSet;
        }
    }

    self.brushButton.enabled = YES;
    self.numpadButton.enabled = YES;

    // if the set menu was tapped, keep button disabled for the pack menu
    if (bubbleMenu == characterSetMenu && _bubbleWasTapped && characterPackMenu) {
        self.numpadButton.enabled = NO;
    }

}

#pragma mark - Utils


- (NSString *)removeExtraWhiteSpaceLinesFromText:(NSString *)text withSize:(CGSize)size
{
    NSRange range = NSMakeRange(0, size.width);
    while (YES) {
        // for each line of width size.width, discard it if it's whitespace
        if (text.length > 2*(size.width) &&
            [self stringIsWhiteSpace:[text substringWithRange:range]] &&
            [self stringIsWhiteSpace:[text substringWithRange:NSMakeRange(size.width, size.width)]]) {
            // if is whitespace, remove if next string is white space as well
            text = [text stringByReplacingCharactersInRange:range withString:@""];

        } else {
            break;
        }

    }

    return text;
}

- (BOOL)stringIsWhiteSpace:(NSString *)str
{
    NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedString = [str stringByTrimmingCharactersInSet:charSet];
    return (trimmedString == nil || [trimmedString isEqualToString:@""]);
}

- (UIColor *)spacerColor
{
    if (DEBUG_SPACERS) {
        return [UIColor randomColor];
    } else {
        return [UIColor clearColor];
    }
}

- (MCDrawSheet *)generateDrawSheet
{

    MCDrawSheet *sheet = [[MCDrawSheet alloc] initWithFrame:CGRectMake(0,
                                                                       ASKEY_HEIGHT,
                                                                       ASKEY_HEIGHT*ASKEY_HEIGHT_FRACTION*ASKEY_WIDTH_RATIO,
                                                                       ASKEY_HEIGHT*ASKEY_HEIGHT_FRACTION)];
    sheet.delegate = self;
    sheet.drawView.drawTool = ACEDrawingToolTypePen;
    sheet.drawView.lineWidth = BRUSH_SIZE_LARGE;
    sheet.drawView.delegate = self;
    [self.sheetBackground addSubview:sheet];
    [self setBrushSelected];
    return sheet;
}

- (void)animateSheetInWithTimer:(NSTimer *)timer
{
    return [self animateSheetIn:[timer userInfo]];
}

- (void)animateSheetIn:(MCDrawSheet *)sheet
{
    // NEW SHEET
    POPSpringAnimation *inAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    inAnim.toValue = @(self.sheetBackground.center.y);
    inAnim.velocity = @(-SHEET_VELOCITY);
    inAnim.name = @"slideNewSheetIn";
    inAnim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        self.previousSheet = self.currentSheet;
        self.previousSheet.userInteractionEnabled = YES;
        self.currentSheet = sheet;
        self.enterButton.enabled = YES;


        [self setBrushSelected];

        [self.sheetBackground mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.view);
            make.width.equalTo(self.currentSheet.mas_height).multipliedBy(ASKEY_WIDTH_RATIO);
            make.center.equalTo(self.view);
        }];

    };
    [sheet pop_addAnimation:inAnim forKey:@"slideNewSheetIn"];
}

- (void)setBrushSelected
{
    // select brush, deselect eraser
    [self.brushButton setStyle:MCBouncyButtonStyleSelected animated:YES];
    [self.eraserButton setStyle:MCBouncyButtonStyleDefault animated:YES];
}
- (void)setEraserSelected
{
    // select eraser and deselect brush
    [self.brushButton setStyle:MCBouncyButtonStyleDefault animated:YES];
    [self.eraserButton setStyle:MCBouncyButtonStyleSelected animated:YES];
}

// http://stackoverflow.com/questions/26057300/how-can-i-check-does-my-ios8-custom-keyboard-extension-have-open-access
-(BOOL)isFullAccessGranted{

    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *containerPath = [[fm containerURLForSecurityApplicationGroupIdentifier:ASKEY_CONTAINER_GROUP_NAME] path];

    NSError *err;
    [fm contentsOfDirectoryAtPath:containerPath error:&err];

    return err == nil;
}

- (void)saveLog:(NSString *)event withParams:(NSDictionary *)params
{
    if (_hasFullAccess) {
        if (params != nil) {
            [AKLogManager saveLog:event withParams:params];
        } else {
            [AKLogManager saveLog:event];
        }
    }
}

@end

























