//
//  AKIntroViewController.h
//  ASCIIboardContainer
//
//  Created by Matt Condon on 1/6/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AKIntroViewController;

@protocol AKIntroViewControllerDelegate <NSObject>

@required
- (void)shouldCloseIntroViewController:(AKIntroViewController *)controller;

@end


@interface AKIntroViewController : UIViewController

@end
