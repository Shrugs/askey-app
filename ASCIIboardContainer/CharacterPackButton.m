//
//  CharacterPackButton.m
//  ASCIIboardContainer
//
//  Created by Matt Condon on 2/15/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import "CharacterPackButton.h"
#import "Config.h"
#import <Masonry/Masonry.h>

@implementation CharacterPackButton


- (id)initWithText:(NSString *)text andBackground:(NSString *)image purchased:(BOOL)purchased
{
    self = [[self class] buttonWithType:UIButtonTypeCustom];
    if (self) {

        UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
        bgView.layer.cornerRadius = 8.0f;
        bgView.layer.masksToBounds = YES;
        [self addSubview:bgView];

        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];

        [self setPurchased:purchased];

        [self setTitle:text forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont fontWithName:ASKEY_BUTTON_FONT size:30];
        [self setTitleColor:ASKEY_BUTTON_TEXT_COLOR forState:UIControlStateNormal];

        self.layer.masksToBounds = NO;
        self.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
        self.layer.shadowOpacity = 1.0f;
        self.layer.shadowRadius = 0.0f;

        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        [self registerHandlers];
    }
    return self;
}

- (void)setPurchased:(BOOL)purchased
{
    self.layer.shadowColor = purchased ? [ASKEY_BUTTON_PURCHASED_SHADOW_COLOR CGColor] : [ASKEY_BLUE_COLOR CGColor];
}

@end
