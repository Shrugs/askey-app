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

@interface AskeyViewController : UIViewController <UINavigationControllerDelegate, UIScrollViewDelegate>
{
    UICollectionView *_characterSetButtons;
    NSMutableArray *_characterSets;
    AskeyScrollView *scrollView;
    AskeyHeaderViewController *_header;

    AKTwitterButton *matt;
}

@property (nonatomic, retain) AKIntroViewController *introVC;


@end

