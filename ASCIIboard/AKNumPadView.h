//
//  AKNumPadView.h
//  ASCIIboardContainer
//
//  Created by Matt Condon on 12/19/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKButton.h"

@interface AKNumPadView : UIView

@property (nonatomic, strong) AKButton *nextKeyboardButton;
@property (nonatomic, strong) AKButton *backButton;
@property (nonatomic, strong) AKButton *deleteButton;
@property (nonatomic, strong) NSMutableArray *numpadButtons;

@end
