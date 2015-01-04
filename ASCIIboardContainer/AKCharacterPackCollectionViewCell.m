//
//  AKCharacterPackCollectionViewCell.m
//  ASCIIboardContainer
//
//  Created by Matt Condon on 1/3/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import "AKCharacterPackCollectionViewCell.h"
#import "Config.h"
#import <Masonry/Masonry.h>

@implementation AKCharacterPackCollectionViewCell

- (void)setText:(NSString *)text
{
    self.layer.backgroundColor = [ASKEY_BUTTON_BODY_COLOR CGColor];
    self.layer.shadowColor = [ASKEY_BUTTON_SHADOW_COLOR CGColor];
    self.layer.cornerRadius = 4.0f;
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius = 0.0f;


    UILabel *textLabel = [[UILabel alloc] initWithFrame:self.frame];
    [textLabel setText:text];
    [textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18]];
    [textLabel setTextColor:ASKEY_BLUE_COLOR];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

@end
