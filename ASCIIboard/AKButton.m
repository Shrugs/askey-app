//
//  AKButton.m
//  ASCIIboardContainer
//
//  Created by Matt Condon on 12/12/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import "AKButton.h"

@implementation AKButton

- (id)initWithImage:(UIImage *)image andDiameter:(float)diameter
{
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self) {
        // body: 253, 253, 253
        // shadow 132, 133, 136
        // selected 11, 106, 255
        // selected shadow 0, 94, 177
        [self setImage:image forState:UIControlStateNormal];
        [self setAdjustsImageWhenDisabled:YES];

        float inset = 0.2*diameter;
        [self setImageEdgeInsets:UIEdgeInsetsMake(inset, inset, inset, inset)];

        self.layer.backgroundColor = [[UIColor colorWithRed:0.98828125f green:0.98828125f blue:0.98828125f alpha:1.0] CGColor];
        self.layer.cornerRadius = diameter/2.0;
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = [[UIColor colorWithRed:0.515625f green:0.51953125f blue:0.53125f alpha:1.0f] CGColor];
        self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
        self.layer.shadowOpacity = 1.0f;
        self.layer.shadowRadius = 1.0f;

    }
    return self;
}

@end
