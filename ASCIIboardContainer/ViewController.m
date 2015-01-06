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

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view removeConstraints:self.view.constraints];

    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.backgroundColor = ASKEY_BLUE_COLOR;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

}

- (void)viewDidAppear:(BOOL)animated
{
    [self setNeedsStatusBarAppearanceUpdate];

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
    [iconHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header).offset(40);
        make.centerX.equalTo(header);
        make.height.and.width.equalTo(header.mas_width).multipliedBy(0.6f);
    }];

    // header label
    UILabel *labelHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    labelHeader.text = @"Askey";
    labelHeader.textColor = ASKEY_BLUE_COLOR;
    labelHeader.adjustsFontSizeToFitWidth = YES;
    labelHeader.textAlignment = NSTextAlignmentCenter;
    labelHeader.font = [UIFont fontWithName:ASKEY_FONT size:30];
    [header addSubview:labelHeader];
    [labelHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(header);
        make.top.equalTo(iconHeader.mas_bottom).offset(0);
    }];

    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.and.top.equalTo(self.scrollView);
        make.bottom.equalTo(labelHeader.mas_bottom).offset(20);
    }];

    UILabel *characterPackHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 20)];
    [characterPackHeader setText:@"Character Packs"];
    characterPackHeader.font = [UIFont fontWithName:ASKEY_FONT size:20];
    characterPackHeader.textAlignment = NSTextAlignmentCenter;
    characterPackHeader.textColor = [UIColor whiteColor];
    [self.scrollView addSubview:characterPackHeader];
    [characterPackHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header.mas_bottom).offset(15);
        make.left.right.and.width.equalTo(self.scrollView);
    }];

    // character pack collection view
    _characterPackButtons = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 200)
                                               collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    [_characterPackButtons registerClass:[AKCharacterPackCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_characterPackButtons setDataSource:self];
    [_characterPackButtons setDelegate:self];
    _characterPackButtons.backgroundColor = ASKEY_BLUE_COLOR;

    [self.scrollView addSubview:_characterPackButtons];
    [_characterPackButtons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.scrollView).multipliedBy(0.9);
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(characterPackHeader.mas_bottom).offset(10);
        make.height.equalTo(@120).multipliedBy(ceilf([_characterPacks count]/2.0));
    }];

    // try out button
    AKFullWidthButton *tryoutButton = [[AKFullWidthButton alloc] initWithText:@"Try Askey"];
    [tryoutButton registerHandlers];
    [tryoutButton addTarget:self action:@selector(tryoutAskey) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:tryoutButton];
    [tryoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(@70);
        make.top.equalTo(_characterPackButtons.mas_bottom).offset(50);
    }];


    // intro button
    AKFullWidthButton *introButton = [[AKFullWidthButton alloc] initWithText:@"Launch Intro"];
    [introButton registerHandlers];
    [introButton addTarget:self action:@selector(launchIntro) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:introButton];
    [introButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(@70);
        make.top.equalTo(tryoutButton.mas_bottom).offset(50);
    }];

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
        [self setNeedsStatusBarAppearanceUpdate];
    };
    [self.tryAskeyVC.view pop_addAnimation:slideIn forKey:@"slide"];

}

- (void)shouldCloseTryAskeyViewController:(TryAskeyViewController *)controller
{
    // animate controller away and set to nil
    POPSpringAnimation *slideIn = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    slideIn.toValue = [NSValue valueWithCGSize:CGSizeMake(0.0, 0.0)];
    slideIn.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        self.tryAskeyVC = nil;
        [self setNeedsStatusBarAppearanceUpdate];
    };
    [self.tryAskeyVC.view pop_addAnimation:slideIn forKey:@"slide"];
}

- (void)updateCharacterPacks
{
    AKCharacterPackManager *myManager = [AKCharacterPackManager sharedManager];
    [myManager refreshCharacterPacks];
    _characterPacks = myManager.characterPacks;
}

- (void)updateCharacterPackUI
{
    [self updateCharacterPacks];
    [_characterPackButtons reloadItemsAtIndexPaths:[_characterPackButtons indexPathsForVisibleItems]];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    // white or black depending on context
    return self.tryAskeyVC ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

- (void)viewDidLayoutSubviews
{
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    contentRect.size.width = self.view.frame.size.width;
    contentRect.size.height += 20;
    self.scrollView.contentSize = contentRect.size;
}

#pragma mark - UICollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_characterPacks count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AKCharacterPackCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setPack:[_characterPacks objectAtIndex:indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((_characterPackButtons.frame.size.width/2)*0.95, 50);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // generate and show cardview by animating in opacity of the card and a blur view
    NSDictionary *pack = [_characterPacks objectAtIndex:indexPath.row];

    [self showCardForPack:pack];

}

#pragma mark - Cards

- (void)showCardForPack:(NSDictionary *)pack
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
    _cardBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    _cardBackgroundView.alpha = 1;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeCard)];
    [_cardBackgroundView addGestureRecognizer:tapRecognizer];
    [_cardBackgroundView addSubview:bgImg];

    int cardWidth = self.scrollView.frame.size.width*0.9;
    AKCardView *card = [[AKCardView alloc] initWithFrame:CGRectMake((self.scrollView.frame.size.width/2.0)-(cardWidth/2.0),
                                                                    self.view.frame.size.height,
                                                                    cardWidth,
                                                                    self.view.frame.size.height*0.75)];
    card.delegate = self;
    [card setPack:pack];
    [_cardBackgroundView addSubview:card];
    [self.view addSubview:_cardBackgroundView];

    // animate blur in
    POPBasicAnimation *fadeIn = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    fadeIn.toValue = @1;
    fadeIn.completionBlock = ^(POPAnimation *anim, BOOL finished) {
    };
    [bgImg pop_addAnimation:fadeIn forKey:@"fadeIn"];

    // animate card in
    POPSpringAnimation *slideIn = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    slideIn.toValue = [NSValue valueWithCGPoint:CGPointMake(_cardBackgroundView.center.x, _cardBackgroundView.center.y)];
    slideIn.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        // create close button and place
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setTitle:@"X" forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeCard) forControlEvents:UIControlEventTouchUpInside];
        [_cardBackgroundView addSubview:closeButton];
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(card.mas_top).offset(-5);
            make.right.equalTo(card.mas_right).offset(-5);
        }];
    };
    [card pop_addAnimation:slideIn forKey:@"slidein"];
}

- (void)closeCard
{
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
    [self updateCharacterPackUI];
}

#pragma mark - Intro

- (void)launchIntro
{
    // ask user to enable keyboard in settings and allow full access
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yo, Enable Askey"
                               message:@"1/ Enable Askey via Settings>General>Keyboard>Keyboards>Add New Keyboard \n2/ Select Askey - Askey \n3/ Allow Askey Full Access \n(This is for character packs and error reports)."
                              delegate:nil cancelButtonTitle:@"K" otherButtonTitles:nil];
    [alert show];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end





















