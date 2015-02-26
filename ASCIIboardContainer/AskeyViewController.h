//
//  ViewController.h
//  ASCIIboardContainer
//
//  Created by Matt Condon on 9/22/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKIntroViewController.h"
#import "AskeyHeaderViewController.h"
#import "AKTwitterButton.h"
#import "AskeyScrollView.h"
#import <POP.h>
#import "CharacterPackButton.h"

@interface AskeyViewController : UIViewController <UINavigationControllerDelegate, UIScrollViewDelegate, AskeyHeaderDelegate, POPAnimationDelegate, UIGestureRecognizerDelegate>
{
    UICollectionView *_characterSetButtons;
    NSMutableArray *_characterSets;
    AskeyScrollView *scrollView;
    AskeyHeaderViewController *_header;

    AKTwitterButton *matt;

    NSTimer *_scrollTimer;

    UIViewController *_presentedViewController;

    BOOL textPurchased;
    BOOL emojiPurchased;
    BOOL mailPurchased;
    BOOL bundlePurchased;

    CharacterPackButton *textBtn;
    CharacterPackButton *emojiBtn;
    CharacterPackButton *mailBtn;
    CharacterPackButton *bundleBtn;

}

@property (nonatomic, retain) AKIntroViewController *introVC;


@end

