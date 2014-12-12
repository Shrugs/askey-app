//
//  MCDrawSheet.m
//  ASCIIboardContainer
//
//  Created by Matt Condon on 12/12/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import "MCDrawSheet.h"
#import "Masonry.h"

@implementation MCDrawSheet

- (id)init
{
    self = [super init];
    if (self) {
        [self initialSetup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialSetup];
    }
    return self;
}

- (void)initialSetup
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowRadius = 5.0f;

    self.drawView = [[ACEDrawingView alloc] initWithFrame:self.frame];

    [self addSubview:self.drawView];

    [self.drawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self);
        make.width.equalTo(self);
        make.center.equalTo(self);
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
