//
//  ViewController.h
//  ASCIIboardContainer
//
//  Created by Matt Condon on 9/22/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKCardView.h"
#import "TryAskeyViewController.h"
#import "AKIntroViewController.h"

@interface ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, AKCardViewDelegate, TryAskeyViewControllerDelegate>
{
    UICollectionView *_characterPackButtons;
    NSArray *_characterPacks;
    UIView *_cardBackgroundView;
    BOOL _statusBarShouldBeWhite;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, retain) TryAskeyViewController *tryAskeyVC;
@property (nonatomic, retain) AKIntroViewController *introVC;

@end

