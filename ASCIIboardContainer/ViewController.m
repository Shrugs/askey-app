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
#import <RKCardView/RKCardView.h>
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
    AKCharacterPackManager *myManager = [AKCharacterPackManager sharedManager];
    [myManager refreshCharacterPacks];
    _characterPacks = myManager.characterPacks;

    // header
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 100)];
    header.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:header];

    // status bar strip
//    UIView *statusBarStrip = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 20)];
//    statusBarStrip.backgroundColor = ASKEY_BLUE_COLOR;
//    [header addSubview:statusBarStrip];
//    [statusBarStrip mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.width.equalTo(header);
//        make.height.equalTo(@30);
//    }];

    // header icon
    UIImageView *iconHeader = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon1024"]];
    // iconHeader.layer.cornerRadius = 25.0f;
    // iconHeader.layer.masksToBounds = YES;
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
    labelHeader.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:30];
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
    characterPackHeader.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20];
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


    // intro button
    AKFullWidthButton *introButton = [[AKFullWidthButton alloc] initWithText:@"Launch Intro"];
    [introButton registerHandlers];
    [self.scrollView addSubview:introButton];
    [introButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(@70);
        make.top.equalTo(_characterPackButtons.mas_bottom).offset(50);

    }];



    [Flurry logEvent:@"APP_OPENED"];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault; // Set status bar color to white
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
    [cell setText:[[_characterPacks objectAtIndex:indexPath.row] objectForKey:@"displayName"]];
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

//    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[self getScreenshot]];
//    bgImg.frame = self.view.frame;

    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _bgBlurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    _bgBlurView.frame = self.view.bounds;
    _bgBlurView.alpha = 0;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeCard)];
    [_bgBlurView addGestureRecognizer:tapRecognizer];

    // CARD
    RKCardView *card = [[RKCardView alloc] initWithFrame:CGRectMake(0,
                                                                    self.view.frame.size.height,
                                                                    self.scrollView.frame.size.width*0.9,
                                                                    self.view.frame.size.width*0.8)];
    card.center = CGPointMake(self.scrollView.center.x, self.view.frame.size.height + card.frame.size.height / 2.0);

    NSLog(@"%@", NSStringFromCGRect(card.frame));

    card.titleLabel.text = [pack objectForKey:@"displayName"];
    [card addShadow];

    AKFullWidthButton *buyButton = [[AKFullWidthButton alloc] initWithText:@"Buy"];
    buyButton.backgroundColor = ASKEY_BLUE_COLOR;
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyButton.layer.shadowColor = [[UIColor clearColor] CGColor];
    [card addSubview:buyButton];
    [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.and.right.equalTo(card);
    }];

    [[_bgBlurView contentView] addSubview:card];
    [self.view addSubview:_bgBlurView];

//    [card mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(_bgBlurView);
//        make.width.equalTo(self.scrollView.mas_width).multipliedBy(0.9);
//        make.height.equalTo(self.view.mas_height).multipliedBy(0.8);
//    }];

    // animate blur in
    POPBasicAnimation *fadeIn = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    fadeIn.toValue = @1;
    fadeIn.completionBlock = ^(POPAnimation *anim, BOOL finished) {
    };
    [_bgBlurView pop_addAnimation:fadeIn forKey:@"fadeIn"];

    // animate card in
    POPSpringAnimation *slideIn = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    slideIn.toValue = [NSValue valueWithCGPoint:CGPointMake(_bgBlurView.center.x, _bgBlurView.center.y)];
    slideIn.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        // create close button and place
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setTitle:@"X" forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeCard) forControlEvents:UIControlEventTouchUpInside];
        [[_bgBlurView contentView] addSubview:closeButton];
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
        [_bgBlurView removeFromSuperview];
        _bgBlurView = nil;
    };
    [_bgBlurView pop_addAnimation:fadeOut forKey:@"fadeOut"];
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





















