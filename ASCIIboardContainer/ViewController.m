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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end





















