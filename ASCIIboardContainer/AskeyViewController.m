//
//  ViewController.m
//  ASCIIboardContainer
//
//  Created by Matt Condon on 9/22/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import "AskeyViewController.h"
#import "Masonry.h"
#import <MCBouncyButton/MCBouncyButton.h>
#import <Crashlytics/Crashlytics.h>
#import "Flurry.h"
#import "Config.h"
#import "AKLargeButton.h"
#import "AKCharacterPackManager.h"
#import "NSString+FontAwesome.h"
#import "CharacterPackButton.h"
#import "CharacterPackViewController.h"
#import "TryAskeyViewController.h"

#define CONTAINER_PADDING 20
#define NORMAL_BUTTON_HEIGHT 65
#define LARGE_BUTTON_RATIO 0.933
#define BUTTON_PADDING 15
#define TWITTER_BUTTON_HEIGHT 40
#define HEADER_HEIGHT 160
#define SMALL_HEADER_HEIGHT 120

@implementation AskeyViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.view.backgroundColor = ASKEY_BACKGROUND_COLOR;
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setDelegate:self];

    scrollView = [[AskeyScrollView alloc] initWithFrame:CGRectMake(0, HEADER_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - HEADER_HEIGHT)];
    scrollView.delaysContentTouches = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];

    self.view.userInteractionEnabled = YES;
    scrollView.userInteractionEnabled = YES;

    _header = [[AskeyHeaderViewController alloc] init];
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:_header.view];

    [_header.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, HEADER_HEIGHT)];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];


    CharacterPackButton *textBtn = [[CharacterPackButton alloc] initWithText:@"Text" andBackground:@"textbg" purchased:YES];
    [textBtn addTarget:self action:@selector(textPackPressed:) forControlEvents:UIControlEventTouchUpInside];
    CharacterPackButton *emojiBtn = [[CharacterPackButton alloc] initWithText:@"Emoji" andBackground:@"emojibg" purchased:NO];
    [emojiBtn addTarget:self action:@selector(emojiPackPressed:) forControlEvents:UIControlEventTouchUpInside];
    CharacterPackButton *mailBtn = [[CharacterPackButton alloc] initWithText:@"Mail" andBackground:@"mailbg" purchased:NO];
    [mailBtn addTarget:self action:@selector(mailPackPressed:) forControlEvents:UIControlEventTouchUpInside];
    CharacterPackButton *bundleBtn = [[CharacterPackButton alloc] initWithText:@"Bundle" andBackground:@"combobg" purchased:NO];
    [bundleBtn addTarget:self action:@selector(bundlePackPressed:) forControlEvents:UIControlEventTouchUpInside];

    UIView *buttonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    buttonContainer.userInteractionEnabled = YES;
    [buttonContainer addSubview:textBtn];
    [buttonContainer addSubview:emojiBtn];
    [buttonContainer addSubview:mailBtn];
    [buttonContainer addSubview:bundleBtn];

    [scrollView addSubview:buttonContainer];

    [textBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonContainer);
        make.left.equalTo(buttonContainer).offset(CONTAINER_PADDING);
        make.height.equalTo(@NORMAL_BUTTON_HEIGHT);
        make.right.equalTo(buttonContainer.mas_centerX).offset(-CONTAINER_PADDING/2.0);
    }];
    [emojiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonContainer);
        make.right.equalTo(buttonContainer).offset(-CONTAINER_PADDING);
        make.height.equalTo(@NORMAL_BUTTON_HEIGHT);
        make.left.equalTo(buttonContainer.mas_centerX).offset(CONTAINER_PADDING/2.0);
    }];
    [mailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(buttonContainer);
        make.left.equalTo(buttonContainer).offset(CONTAINER_PADDING);
        make.height.equalTo(@NORMAL_BUTTON_HEIGHT);
        make.right.equalTo(buttonContainer.mas_centerX).offset(-CONTAINER_PADDING/2.0);
    }];
    [bundleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(buttonContainer);
        make.right.equalTo(buttonContainer).offset(-CONTAINER_PADDING);
        make.height.equalTo(@NORMAL_BUTTON_HEIGHT);
        make.left.equalTo(buttonContainer.mas_centerX).offset(CONTAINER_PADDING/2.0);
    }];


    AKLargeButton *faqBtn = [[AKLargeButton alloc] initWithText:@"FAQ"];
//    [faqBtn addTarget:self action:@selector(faqBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:faqBtn];

    AKLargeButton *tryBtn = [[AKLargeButton alloc] initWithText:@"Test Askey"];
//    [tryBtn addTarget:self action:@selector(tryBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:tryBtn];

    AKLargeButton *introBtn = [[AKLargeButton alloc] initWithText:@"Launch Intro"];
//    [introBtn addTarget:self action:@selector(launchIntro:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:introBtn];

    [faqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonContainer.mas_bottom).offset(CONTAINER_PADDING);
        make.height.equalTo(@NORMAL_BUTTON_HEIGHT);
        make.width.equalTo(self.view).multipliedBy(LARGE_BUTTON_RATIO);
        make.centerX.equalTo(self.view);
    }];

    [tryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(faqBtn.mas_bottom).offset(BUTTON_PADDING);
        make.height.equalTo(@NORMAL_BUTTON_HEIGHT);
        make.width.equalTo(self.view).multipliedBy(LARGE_BUTTON_RATIO);
        make.centerX.equalTo(self.view);
    }];

    [introBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tryBtn.mas_bottom).offset(BUTTON_PADDING);
        make.height.equalTo(@NORMAL_BUTTON_HEIGHT);
        make.width.equalTo(self.view).multipliedBy(LARGE_BUTTON_RATIO);
        make.centerX.equalTo(self.view);
    }];

    matt = [[AKTwitterButton alloc] initWithText:@"@matt" username:@"mattgcondon" andPic:@"matt"];
    [scrollView addSubview:matt];

    AKTwitterButton *ben = [[AKTwitterButton alloc] initWithText:@"@ben" username:@"tfzweig" andPic:@"ben"];
    [scrollView addSubview:ben];

    [matt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(introBtn.mas_bottom).offset(CONTAINER_PADDING);
        make.left.equalTo(introBtn);
        make.height.equalTo(@TWITTER_BUTTON_HEIGHT);
        make.right.equalTo(self.view.mas_centerX).offset(-BUTTON_PADDING/2.0);
    }];

    [ben mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(introBtn.mas_bottom).offset(CONTAINER_PADDING);
        make.right.equalTo(introBtn);
        make.height.equalTo(@TWITTER_BUTTON_HEIGHT);
        make.left.equalTo(self.view.mas_centerX).offset(BUTTON_PADDING/2.0);
    }];


}

- (void)viewDidAppear:(BOOL)animated
{


//    // character pack collection view
//    _characterSetButtons = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 200)
//                                               collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
//    [_characterSetButtons registerClass:[AKCharacterPackCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
//    [_characterSetButtons setDataSource:self];
//    [_characterSetButtons setDelegate:self];
//    _characterSetButtons.backgroundColor = ASKEY_BLUE_COLOR;
//
//    [content addSubview:_characterSetButtons];


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

    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,
                                        MAX(scrollView.frame.size.height - 19 , matt.frame.origin.y + TWITTER_BUTTON_HEIGHT + BUTTON_PADDING)
                                        );

}

- (void)textPackPressed:(id)sender
{
    CharacterPackViewController *vc = [[CharacterPackViewController alloc] initWithCharacterPack:[[AKCharacterPackManager characterSets] objectAtIndex:0]];
    [self makeHeaderHeight:SMALL_HEADER_HEIGHT animated:YES];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)emojiPackPressed:(id)sender
{
    CharacterPackViewController *vc = [[CharacterPackViewController alloc] initWithCharacterPack:[[AKCharacterPackManager characterSets] objectAtIndex:1]];
    [self makeHeaderHeight:SMALL_HEADER_HEIGHT animated:YES];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)mailPackPressed:(id)sender
{
    CharacterPackViewController *vc = [[CharacterPackViewController alloc] initWithCharacterPack:[[AKCharacterPackManager characterSets] objectAtIndex:2]];
    [self makeHeaderHeight:SMALL_HEADER_HEIGHT animated:YES];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)makeHeaderHeight:(float)height animated:(BOOL)animated
{
    [_header.animator animate:40];
}

- (void)bundlePackPressed:(id)sender
{
    // purchase all of them for $2
}

- (void)tryoutAskey
{

}

- (void)updateCharacterPacks
{

}

- (void)showFAQ
{
    [self launchURL:@"http://mat.tc"];
}

- (void)launchURL:(NSString *)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


- (void)viewDidLayoutSubviews
{

}

#pragma mark - UICollectionView Delegate

//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return [_characterSets count];
//}
//
//// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    AKCharacterPackCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//
//    if (!cell) {
//        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    }
//
//    [cell setSet:[_characterSets objectAtIndex:indexPath.row]];
//    return cell;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake((_characterSetButtons.frame.size.width/2)*0.95, 50);
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    // generate and show cardview by animating in opacity of the card and a blur view
//    NSDictionary *set = [_characterSets objectAtIndex:indexPath.row];
//
//    [self showCardForSet:set];
//
//}

//
//- (UIView *)getBlurredBackgroundView
//{
//    // take screenshot of screen
//    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[self getScreenshot]];
//    bgImg.frame = self.view.bounds;
//    bgImg.alpha = 0;
//    // assign a blur to it
//    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    blurView.frame = bgImg.bounds;
//    [bgImg addSubview:blurView];
//
//    // create the background view and add the blurred image to it
//    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
//    backgroundView.alpha = 1;
//    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeCard)];
//    [backgroundView addGestureRecognizer:tapRecognizer];
//    [backgroundView addSubview:bgImg];
//
//    // animate blur in
//    POPBasicAnimation *fadeIn = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
//    fadeIn.toValue = @1;
//    fadeIn.completionBlock = ^(POPAnimation *anim, BOOL finished) {
//    };
//    [bgImg pop_addAnimation:fadeIn forKey:@"fadeIn"];
//
//    return backgroundView;
//}


#pragma mark - Intro

- (void)launchIntro
{

}

#pragma UINavigationController
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController class] == [self class]) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
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





















