//
//  AKFullWidthButton.m
//  ASCIIboardContainer
//
//  Created by Matt Condon on 1/3/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import "AKLargeButton.h"
#import <Masonry/Masonry.h>
#import "Config.h"

@implementation AKLargeButton

- (id)initWithText:(NSString *)text
{
    self = [[self class] buttonWithType:UIButtonTypeCustom];
    if (self) {
        self.layer.backgroundColor = [ASKEY_BUTTON_BODY_COLOR CGColor];
        [self setTitle:text forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont fontWithName:ASKEY_BUTTON_FONT size:30.0];
        [self setTitleColor:ASKEY_BUTTON_TEXT_COLOR forState:UIControlStateNormal];

        self.layer.cornerRadius = 8.0f;
        self.layer.masksToBounds = YES;

        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

@end
