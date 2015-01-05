//
//  ViewController.h
//  ASCIIboardContainer
//
//  Created by Matt Condon on 9/22/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>
{
    UICollectionView *_characterPackButtons;
    NSArray *_characterPacks;
    UIView *_cardBackgroundView;
}

@property (nonatomic, strong) UIScrollView *scrollView;

@end

