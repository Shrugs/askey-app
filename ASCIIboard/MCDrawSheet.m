//
//  MCDrawSheet.m
//  ASCIIboardContainer
//
//  Created by Matt Condon on 12/12/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import "MCDrawSheet.h"

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
    self.layer.shadowColor = [[UIColor colorWithRed:0.515625f green:0.51953125f blue:0.53125f alpha:1.0f] CGColor];
    self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius = 1.0f;

    self.drawView = [[ACEDrawingView alloc] initWithFrame:self.frame];

    [self addSubview:self.drawView];

    [self.drawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self);
        make.width.equalTo(self);
        make.center.equalTo(self);
    }];
}

- (void)listenForGestures
{
    coverView = [[UIView alloc] initWithFrame:self.bounds];
    coverView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f];
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [coverView addGestureRecognizer:panGestureRecognizer];
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [coverView addGestureRecognizer:tapGestureRecognizer];
    [self addSubview:coverView];
}

- (void)unlistenForGestures
{
    if (coverView != nil) {
        [coverView removeFromSuperview];
        coverView = nil;
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    // - (void)drawSheet:(MCDrawSheet *)sheet wasMovedWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer
    if([self.delegate respondsToSelector:@selector(drawSheet:wasMovedWithGestureRecognizer:)]) {
        [self.delegate drawSheet:self wasMovedWithGestureRecognizer:pan];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    // - (void)drawSheet:(MCDrawSheet *)sheet wasTappedWithGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer
    if([self.delegate respondsToSelector:@selector(drawSheet:wasTappedWithGestureRecognizer:)]) {
        [self.delegate drawSheet:self wasTappedWithGestureRecognizer:tap];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
