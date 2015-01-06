//
//  TryAskeyViewController.h
//  ASCIIboardContainer
//
//  Created by Matt Condon on 1/6/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TryAskeyViewController;

@protocol TryAskeyViewControllerDelegate <NSObject>

@required
- (void)shouldCloseTryAskeyViewController:(TryAskeyViewController *)controller;

@end

@interface TryAskeyViewController : UIViewController

@property (nonatomic, weak) id <TryAskeyViewControllerDelegate> delegate;

@end
