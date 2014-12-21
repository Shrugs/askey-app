//
//  AKNumPadView.h
//  ASCIIboardContainer
//
//  Created by Matt Condon on 12/19/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MCBouncyButton/MCBouncyButton.h>

@interface AKNumPadView : UIView

@property (nonatomic, strong) MCBouncyButton *nextKeyboardButton;
@property (nonatomic, strong) MCBouncyButton *backButton;
@property (nonatomic, strong) MCBouncyButton *deleteButton;
@property (nonatomic, strong) NSMutableArray *numpadButtons;

@end
