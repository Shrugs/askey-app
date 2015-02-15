//
//  ViewController.m
//  ASCIIboardContainer
//
//  Created by Matt Condon on 9/22/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import <MCBouncyButton/MCBouncyButton.h>
#import <Crashlytics/Crashlytics.h>
#import "Flurry.h"
#import "Config.h"
#import "AKFullWidthButton.h"
#import "AKCharacterPackManager.h"
#import "AKCharacterPackCollectionViewCell.h"
#import <POP.h>
#import "NSString+FontAwesome.h"
#import "AKCreditView.h"

#define BUTTON_OFFSET 25
#define BUTTON_SIZE 70

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view removeConstraints:self.view.constraints];

    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

}

- (void)viewDidAppear:(BOOL)animated
{
    [self setStatusBarBlack];

    // update character packs
    [self updateCharacterPacks];

    // header
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 100)];
    header.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:header];

    // header icon
    UIImageView *iconHeader = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon1024"]];
    iconHeader.layer.cornerRadius = 25.0f;
    iconHeader.layer.masksToBounds = YES;
    // iconHeader.layer.borderColor = [ASKEY_BLUE_COLOR CGColor];
    // iconHeader.layer.borderWidth = 2.0f;
    [header addSubview:iconHeader];

    // header label
    UILabel *labelHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    labelHeader.text = @"Askey";
    labelHeader.textColor = ASKEY_BLUE_COLOR;
    labelHeader.adjustsFontSizeToFitWidth = YES;
    labelHeader.textAlignment = NSTextAlignmentCenter;
    labelHeader.font = [UIFont fontWithName:ASKEY_FONT size:30];
    [header addSubview:labelHeader];

    // content container
    UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 500)];
    content.backgroundColor = ASKEY_BLUE_COLOR;
    content.layer.shadowColor = [ASKEY_BUTTON_SHADOW_COLOR CGColor];
    content.layer.masksToBounds = NO;
    content.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    content.layer.shadowOpacity = 1.0f;
    content.layer.shadowRadius = 0.0f;
    [self.scrollView addSubview:content];

    // character pack text
    UILabel *characterSetsHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 20)];
    [characterSetsHeader setText:@"Character Sets"];
    characterSetsHeader.font = [UIFont fontWithName:ASKEY_FONT size:20];
    characterSetsHeader.textAlignment = NSTextAlignmentCenter;
    characterSetsHeader.textColor = [UIColor whiteColor];
    [content addSubview:characterSetsHeader];

    // character pack collection view
    _characterSetButtons = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 200)
                                               collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    [_characterSetButtons registerClass:[AKCharacterPackCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_characterSetButtons setDataSource:self];
    [_characterSetButtons setDelegate:self];
    _characterSetButtons.backgroundColor = ASKEY_BLUE_COLOR;

    [content addSubview:_characterSetButtons];

    // try out button
    AKFullWidthButton *tryoutButton = [[AKFullWidthButton alloc] initWithText:@"Try Askey"];
    [tryoutButton registerHandlers];
    [tryoutButton addTarget:self action:@selector(tryoutAskey) forControlEvents:UIControlEventTouchUpInside];
    [content addSubview:tryoutButton];

    // intro button
    AKFullWidthButton *introButton = [[AKFullWidthButton alloc] initWithText:@"Launch Intro"];
    [introButton registerHandlers];
    [introButton addTarget:self action:@selector(launchIntro) forControlEvents:UIControlEventTouchUpInside];
    [content addSubview:introButton];

    // FAQ Button
    AKFullWidthButton *faqButton = [[AKFullWidthButton alloc] initWithText:@"FAQ"];
    [faqButton registerHandlers];
    [faqButton addTarget:self action:@selector(showFAQ) forControlEvents:UIControlEventTouchUpInside];
    [content addSubview:faqButton];

    // Matt Condon
    AKCreditView *matt = [[AKCreditView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70) text:@"Matt Condon" twitter:@"mattgcondon" andWeb:@"http://mat.tc"];
    [content addSubview:matt];

    // Benjamin Zweig
    AKCreditView *ben = [[AKCreditView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70) text:@"Ben Zweig" twitter:@"tfzweig" andWeb:@"http://www.tfzweig.com/"];
    [content addSubview:ben];

    // Blue view at bottom
    int blueThingWidth = 100;
    UIView *blueThing = [[UIView alloc] initWithFrame:CGRectMake(0, self.scrollView.frame.size.height - blueThingWidth, self.view.frame.size.width, self.view.frame.size.height)];
    [blueThing setBackgroundColor:ASKEY_BLUE_COLOR];
    [self.scrollView.layer insertSublayer:blueThing.layer atIndex:0];

    // CONSTRAINTS
    [iconHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header).offset(40);
        make.centerX.equalTo(header);
        make.height.and.width.equalTo(header.mas_width).multipliedBy(0.6f);
    }];
    [labelHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(header);
        make.top.equalTo(iconHeader.mas_bottom).offset(0);
    }];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.and.top.equalTo(self.scrollView);
        make.bottom.equalTo(labelHeader.mas_bottom).offset(20);
    }];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ben).offset(50);
        make.top.equalTo(header.mas_bottom);
        make.centerX.left.and.right.equalTo(self.scrollView);
    }];
    [characterSetsHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(content).offset(15);
        make.left.right.and.width.equalTo(self.scrollView);
    }];
    [_characterSetButtons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.scrollView).multipliedBy(0.9);
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(characterSetsHeader.mas_bottom).offset(10);
        make.height.equalTo(@120).multipliedBy(ceilf([_characterSets count]/2.0));
    }];
    [tryoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(@BUTTON_SIZE);
        make.top.equalTo(_characterSetButtons.mas_bottom).offset(50);
    }];
    [introButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(@BUTTON_SIZE);
        make.top.equalTo(tryoutButton.mas_bottom).offset(BUTTON_OFFSET);
    }];
    [faqButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(@BUTTON_SIZE);
        make.top.equalTo(introButton.mas_bottom).offset(BUTTON_OFFSET);
    }];
    [matt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(faqButton.mas_bottom).offset(BUTTON_OFFSET + 20);
        make.left.and.right.equalTo(self.scrollView);
        make.height.equalTo(@(BUTTON_SIZE));
    }];
    [ben mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(matt.mas_bottom).offset(BUTTON_OFFSET);
        make.left.and.right.equalTo(self.scrollView);
        make.height.equalTo(@BUTTON_SIZE);
    }];
//    [blueThing mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.left.and.right.equalTo(self.view);
//        make.height.equalTo(self.view.mas_height).multipliedBy(0.5);
//    }];

    // launch intro on startup
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        // app already launched
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // This is the first launch ever
        [self launchIntro];
    }

}

- (void)tryoutAskey
{
    self.tryAskeyVC = [[TryAskeyViewController alloc] init];
    self.tryAskeyVC.delegate = self;
    // set initial frame
    CGRect _f = self.view.bounds;
    self.tryAskeyVC.view.frame = _f;
    // offset below screen
    _f.origin.y = self.view.frame.size.height;
    self.tryAskeyVC.view.frame = _f;

    // animate in
    [self.view addSubview:self.tryAskeyVC.view];

    POPSpringAnimation *slideIn = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    slideIn.toValue = [NSValue valueWithCGPoint:self.view.center];
    slideIn.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [self setStatusBarWhite];
    };
    [self.tryAskeyVC.view pop_addAnimation:slideIn forKey:@"slide"];

}

- (void)shouldCloseTryAskeyViewController:(TryAskeyViewController *)controller
{
    // animate controller away and set to nil
    POPBasicAnimation *scaleOut = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleOut.toValue = [NSValue valueWithCGSize:CGSizeMake(0.0, 0.0)];
    scaleOut.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        self.tryAskeyVC = nil;
        [self setStatusBarBlack];
    };
    [self.tryAskeyVC.view pop_addAnimation:scaleOut forKey:@"slide"];
}

- (void)updateCharacterPacks
{
    _characterSets = [[AKCharacterPackManager sharedManager] characterSets];
}

- (void)updateCharacterSetUI
{
    [self updateCharacterPacks];
    [_characterSetButtons reloadItemsAtIndexPaths:[_characterSetButtons indexPathsForVisibleItems]];
}


- (void)showFAQ
{
    [self launchURL:@"http://mat.tc"];
}

- (void)launchURL:(NSString *)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    // white or black depending on context
    return _statusBarShouldBeWhite ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

- (void)viewDidLayoutSubviews
{
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    contentRect.size.width = self.view.frame.size.width;
    self.scrollView.contentSize = contentRect.size;
}

#pragma mark - UICollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_characterSets count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AKCharacterPackCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setSet:[_characterSets objectAtIndex:indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((_characterSetButtons.frame.size.width/2)*0.95, 50);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // generate and show cardview by animating in opacity of the card and a blur view
    NSDictionary *set = [_characterSets objectAtIndex:indexPath.row];

    [self showCardForSet:set];

}

#pragma mark - Cards

- (void)showCardForSet:(NSDictionary *)set
{
    [self setStatusBarWhite];


    _cardBackgroundView = [self getBlurredBackgroundView];


    int cardWidth = self.scrollView.frame.size.width*0.9;
    AKCardView *card = [[AKCardView alloc] initWithFrame:CGRectMake((self.scrollView.frame.size.width/2.0)-(cardWidth/2.0),
                                                                    self.view.frame.size.height,
                                                                    cardWidth,
                                                                    self.view.frame.size.height*0.75)];
    card.delegate = self;
    [card setSet:set];
    [_cardBackgroundView addSubview:card];
    [self.view addSubview:_cardBackgroundView];

    // animate card in
    POPSpringAnimation *slideIn = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    slideIn.toValue = [NSValue valueWithCGPoint:CGPointMake(_cardBackgroundView.center.x, _cardBackgroundView.center.y)];
    slideIn.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        // create close button and place
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setTitle:[NSString fa_stringForFontAwesomeIcon:FAClose] forState:UIControlStateNormal];
        [backButton.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFont size:18]];
        backButton.alpha = 0;
        [backButton addTarget:self action:@selector(closeCard) forControlEvents:UIControlEventTouchUpInside];
        [_cardBackgroundView addSubview:backButton];
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(card);
            make.bottom.equalTo(card.mas_top).offset(-5);
            make.height.and.width.equalTo(@20);
        }];

        POPBasicAnimation *fadeIn = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        fadeIn.toValue = @1;
        [backButton pop_addAnimation:fadeIn forKey:@"fadeIn"];

    };
    [card pop_addAnimation:slideIn forKey:@"slidein"];
}

- (UIView *)getBlurredBackgroundView
{
    // take screenshot of screen
    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[self getScreenshot]];
    bgImg.frame = self.view.bounds;
    bgImg.alpha = 0;
    // assign a blur to it
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = bgImg.bounds;
    [bgImg addSubview:blurView];

    // create the background view and add the blurred image to it
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    backgroundView.alpha = 1;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeCard)];
    [backgroundView addGestureRecognizer:tapRecognizer];
    [backgroundView addSubview:bgImg];

    // animate blur in
    POPBasicAnimation *fadeIn = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    fadeIn.toValue = @1;
    fadeIn.completionBlock = ^(POPAnimation *anim, BOOL finished) {
    };
    [bgImg pop_addAnimation:fadeIn forKey:@"fadeIn"];

    return backgroundView;
}

- (void)closeCard
{
    [self setStatusBarBlack];

    // animate blur in
    POPBasicAnimation *fadeOut = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    fadeOut.toValue = @0;
    fadeOut.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [_cardBackgroundView removeFromSuperview];
        _cardBackgroundView = nil;
    };
    [_cardBackgroundView pop_addAnimation:fadeOut forKey:@"fadeOut"];
}

- (void)shouldHideCardView:(AKCardView *)cardView
{
    [self closeCard];
    [self updateCharacterSetUI];
}

#pragma mark - Intro

- (void)launchIntro
{
    [self setStatusBarWhite];
    self.introVC = [[AKIntroViewController alloc] initWithBackground:[self getBlurredBackgroundView]];
    // set frames
    _cardBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.introVC.view.frame = _cardBackgroundView.bounds;

    // add
    [_cardBackgroundView addSubview:self.introVC.view];
    [self.view addSubview:_cardBackgroundView];
}

#pragma mark - util

- (UIImage *)getScreenshot
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(window.bounds.size);
    }
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)setStatusBarWhite
{
    _statusBarShouldBeWhite = YES;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setStatusBarBlack
{
    _statusBarShouldBeWhite = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end





















