//
//  AKNumPadView.m
//  ASCIIboardContainer
//
//  Created by Matt Condon on 12/19/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import "AKNumPadView.h"
#import "Masonry.h"
#import "AKConfig.h"
#import "UIColor+Random.h"
#import "AKButton.h"

@implementation AKNumPadView

- (AKNumPadView *)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure
{

    self.backgroundColor = ASKEY_BACKGROUND_COLOR;

    // set up numpad buttons and globe and back buttons with spacers and shit, somehow

    // UP DOWN SPACERS
    int numHeightSpacers = 5;

    NSMutableArray *heightSpacers = [[NSMutableArray alloc] initWithCapacity:numHeightSpacers];

    for (int i = 0; i < numHeightSpacers; ++i) {
        UIView *spacer = [[UIView alloc] init];
        spacer.backgroundColor = [UIColor clearColor];
        [self addSubview:spacer];

        [heightSpacers addObject:spacer];

        [spacer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.mas_width).multipliedBy(0.1);
            if (i == 0) {
                // first
                make.centerX.equalTo(self);
                make.height.greaterThanOrEqualTo(@(0));
                make.top.equalTo(self);
            } else if (i == numHeightSpacers - 1) {
                // last
                make.height.and.centerX.equalTo(heightSpacers[0]);
                make.bottom.equalTo(self);
            } else {
                // if any but the first one, inherit height and width and centerX
                make.height.and.centerX.equalTo(heightSpacers[0]);
            }
        }];
    }

    // LEFT RIGHT SPACERS
    int numWidthSpacers = 5;

    NSMutableArray *widthSpacers = [[NSMutableArray alloc] initWithCapacity:numWidthSpacers];

    for (int i = 0; i < numWidthSpacers; ++i) {
        UIView *spacer = [[UIView alloc] init];
        spacer.backgroundColor = [UIColor clearColor];
        [self addSubview:spacer];

        [widthSpacers addObject:spacer];

        [spacer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.mas_height).multipliedBy(0.1);
            if (i == 0) {
                // first
                make.centerY.equalTo(self);
                make.width.greaterThanOrEqualTo(@(0));
                make.left.equalTo(self);
            } else if (i == numWidthSpacers - 1) {
                // last
                make.width.and.centerY.equalTo(widthSpacers[0]);
                make.right.equalTo(self);
            } else {
                // if any but the first one, inherit height and width and centerX
                make.width.and.centerY.equalTo(widthSpacers[0]);
            }
        }];
    }




    // BUTTONS
    NSArray *numpad = [[NSArray alloc] initWithObjects:
                             [[NSArray alloc] initWithObjects:@"NONE", @"1", @"2", @"3", nil],
                             [[NSArray alloc] initWithObjects:@"NONE", @"4", @"5", @"6", nil],
                             [[NSArray alloc] initWithObjects:@"BACK", @"7", @"8", @"9", nil],
                             [[NSArray alloc] initWithObjects:@"GLOBE", @".", @"0", @"DELETE", nil],
                              nil];

    self.numpadButtons = [[NSMutableArray alloc] initWithCapacity:16]; // 11 = [0-9] + .

    for (int row = 0; row < [numpad count]; row++) {
        // for each row
        for (int col = 0; col < [[numpad objectAtIndex:row] count]; col++) {
            // for each column

            // make a new button and place the correct thing on it
            NSString *val = [[numpad objectAtIndex:row] objectAtIndex:col];
            UIView *thing;

            if ([val isEqualToString:@"NONE"]) {
                UIView *spacer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BUTTON_HEIGHT, BUTTON_HEIGHT)];
                spacer.backgroundColor = [UIColor clearColor];
                thing = spacer;
            } else if ([val isEqualToString:@"BACK"]) {
                self.backButton = [[AKButton alloc] initWithImage:[UIImage imageNamed:@"pen"] andDiameter:BUTTON_HEIGHT];
                thing = self.backButton;
            } else if ([val isEqualToString:@"GLOBE"]) {
                self.nextKeyboardButton = [[AKButton alloc] initWithImage:[UIImage imageNamed:@"globe"] andDiameter:BUTTON_HEIGHT];
                thing = self.nextKeyboardButton;
            } else if ([val isEqualToString:@"DELETE"]) {
                self.deleteButton = [[AKButton alloc] initWithImage:[UIImage imageNamed:@"backspace"] andDiameter:BUTTON_HEIGHT];
                thing = self.deleteButton;
            } else {
                AKButton *button = [[AKButton alloc] initWithText:val andDiameter:BUTTON_HEIGHT];
                [self.numpadButtons addObject:button];
                thing = button;
            }

            [self addSubview:thing];
            [thing mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.and.height.equalTo(@(BUTTON_HEIGHT));
                make.left.equalTo(((UIView *)[widthSpacers objectAtIndex:col]).mas_right);
                make.right.equalTo(((UIView *)[widthSpacers objectAtIndex:col+1]).mas_left);
                make.top.equalTo(((UIView *)[heightSpacers objectAtIndex:row]).mas_bottom);
                make.bottom.equalTo(((UIView *)[heightSpacers objectAtIndex:row+1]).mas_top);
            }];
        }
    }

}

@end







































