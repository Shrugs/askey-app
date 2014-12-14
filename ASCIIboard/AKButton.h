//
//  AKButton.h
//  ASCIIboardContainer
//
//  Created by Matt Condon on 12/12/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    AKButtonStyleDefault,
    AKButtonStyleSelected
} AKButtonStyle;

@interface AKButton : UIButton

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) UIImage *iconNegative;

- (id)initWithImage:(UIImage *)image andDiameter:(float)diameter;

- (void)setStyle:(AKButtonStyle)style;


@end
