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
#import "AKLargeButton.h"
#import "AKCharacterPackManager.h"
#import "NSString+FontAwesome.h"

#define BUTTON_OFFSET 25
#define BUTTON_SIZE 70

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view removeConstraints:self.view.constraints];

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





















