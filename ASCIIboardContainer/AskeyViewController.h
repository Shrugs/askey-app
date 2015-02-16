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

@interface AskeyViewController : UIViewController <UINavigationControllerDelegate>
{
    UICollectionView *_characterSetButtons;
    NSMutableArray *_characterSets;
    UIScrollView *scrollView;
    AskeyHeaderViewController *header;

    AKTwitterButton *matt;
}

@property (nonatomic, retain) AKIntroViewController *introVC;


@end

