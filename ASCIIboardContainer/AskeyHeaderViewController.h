//
//  AskeyHeaderViewController.h
//  ASCIIboardContainer
//
//  Created by Matt Condon on 2/15/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IFTTTJazzHands.h>

@interface AskeyHeaderViewController : UIViewController
{
    UIImageView *iconView;
    UILabel *title;
}

@property (nonatomic, strong) IFTTTAnimator *animator;

@end
