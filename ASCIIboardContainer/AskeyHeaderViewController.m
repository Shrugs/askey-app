//
//  AskeyHeaderViewController.m
//  ASCIIboardContainer
//
//  Created by Matt Condon on 2/15/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import "AskeyHeaderViewController.h"
#import "Config.h"
#import <Masonry/Masonry.h>
#import "NSString+FontAwesome.h"

#define MIN_DELTA 0
#define MAX_DELTA 100

@interface AskeyHeaderViewController ()

@end

@implementation AskeyHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.view.backgroundColor = ASKEY_BLUE_COLOR;

    // icon
    iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconheader"]];
    iconView.userInteractionEnabled = NO;

    // title
    title = [[UILabel alloc] init];
    title.text = @"Askey";
    title.font = [UIFont fontWithName:ASKEY_TITLE_FONT size:34];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.translatesAutoresizingMaskIntoConstraints = NO;
    [title sizeToFit];
    title.userInteractionEnabled = NO;

    // carat
    _carat = [[UIButton alloc] init];
    [_carat setTitle:[NSString fa_stringForFontAwesomeIcon:FACaretDown] forState:UIControlStateNormal];
    [_carat.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFont size:30]];
    [_carat addTarget:self.delegate action:@selector(headerHasBeenTapped) forControlEvents:UIControlEventTouchUpInside];

    UIPanGestureRecognizer *headerDragRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(headerHasBeenDragged:)];
    headerDragRecognizer.delegate = self.delegate;
    [self.view addGestureRecognizer:headerDragRecognizer];

    // add to views
    [self.view addSubview:iconView];
    [self.view addSubview:title];
    [self.view addSubview:_carat];

    // constraints
    [_carat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(30));
        make.width.equalTo(_carat.mas_height);
        make.left.equalTo(self.view).offset(10);
    }];


    float iconSizeLarge = LARGE_HEADER_HEIGHT * 0.44;

    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.view).multipliedBy(0.44);
        make.width.equalTo(iconView.mas_height);
    }];

    NSLayoutConstraint *_iconLeftConstraint = [NSLayoutConstraint constraintWithItem:iconView
                                                                           attribute:NSLayoutAttributeLeft
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.view
                                                                           attribute:NSLayoutAttributeLeft
                                                                          multiplier:1
                                                                            constant:0];

    NSLayoutConstraint *_iconCenterYConstraint = [NSLayoutConstraint constraintWithItem:iconView
                                                                              attribute:NSLayoutAttributeCenterY
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeCenterY
                                                                             multiplier:1
                                                                               constant:0];

    NSLayoutConstraint *_titleLeftConstraint = [NSLayoutConstraint constraintWithItem:title
                                                                            attribute:NSLayoutAttributeLeft
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.view
                                                                            attribute:NSLayoutAttributeLeft
                                                                           multiplier:1
                                                                             constant:0];

    NSLayoutConstraint *_titleCenterYConstraint = [NSLayoutConstraint constraintWithItem:title
                                                                               attribute:NSLayoutAttributeCenterY
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.view
                                                                               attribute:NSLayoutAttributeCenterY
                                                                              multiplier:1
                                                                                constant:0];

    NSLayoutConstraint *_heightConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                            multiplier:1
                                                                          constant:0];

    // carat top
    NSLayoutConstraint *_caratTopConstraint = [NSLayoutConstraint constraintWithItem:_carat
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.view
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1
                                                                           constant:0];

    [self.view addConstraints:@[
                                _iconLeftConstraint,
                                _iconCenterYConstraint,
                                _titleLeftConstraint,
                                _titleCenterYConstraint,
                                _heightConstraint,
                                _caratTopConstraint
                               ]];


    // JazzHands
    self.animator = [IFTTTAnimator new];
    self.scaleAnimator = [IFTTTAnimator new];

    // icon left
    [self animationWithConstraint:_iconLeftConstraint
                    startConstant:self.view.center.x - iconSizeLarge/2.0
                   andEndConstant:self.view.center.x - iconSizeLarge/2.0 - 17];

    // icon centerY
    [self animationWithConstraint:_iconCenterYConstraint
                    startConstant:-10
                   andEndConstant:0 + 5];

    // title left
    [self animationWithConstraint:_titleLeftConstraint
                    startConstant:self.view.frame.size.width/2.0 - title.frame.size.width/2.0
                   andEndConstant:self.view.frame.size.width/2.0 - title.frame.size.width/2.0 + 10];

    // title centerY
    [self animationWithConstraint:_titleCenterYConstraint
                    startConstant:45
                   andEndConstant:0 + 5];

    // self height
    [self animationWithConstraint:_heightConstraint
                    startConstant:160
                   andEndConstant:60];

    // title scale
    IFTTTScaleAnimation *titleScaleAnimation = [IFTTTScaleAnimation new];
    titleScaleAnimation.view = title;
    [self.scaleAnimator addAnimation:titleScaleAnimation];
    [titleScaleAnimation addKeyFrames:@[
                                        [[IFTTTAnimationKeyFrame alloc] initWithTime:MIN_DELTA andScale:1.0],
                                        [[IFTTTAnimationKeyFrame alloc] initWithTime:MAX_DELTA andScale:0.7]
                                        ]];

    // icon scale
    IFTTTScaleAnimation *iconScaleAnimation = [IFTTTScaleAnimation new];
    iconScaleAnimation.view = iconView;
    [self.scaleAnimator addAnimation:iconScaleAnimation];
    [iconScaleAnimation addKeyFrames:@[
                                        [[IFTTTAnimationKeyFrame alloc] initWithTime:MIN_DELTA andScale:1.0],
                                        [[IFTTTAnimationKeyFrame alloc] initWithTime:MAX_DELTA andScale:0.9]
                                        ]];


    [self animationWithConstraint:_caratTopConstraint startConstant:-30 andEndConstant:(SMALL_HEADER_HEIGHT-10)/2.0 - 5];


    [self.animator animate:0];
    [self.scaleAnimator animate:0];

}

- (void)viewDidAppear:(BOOL)animated
{
    CGRect f = self.view.frame;
    f.size.height = 160;
    self.view.frame = f;

    [self showCarat:NO];
}

- (void)animationWithConstraint:(NSLayoutConstraint *)constraint startConstant:(CGFloat)start andEndConstant:(CGFloat)end
{
    IFTTTConstraintsAnimation *animation = [IFTTTConstraintsAnimation new];
    animation.constraint = constraint;

    [self.animator addAnimation:animation];

    [animation addKeyFrames:@[
                              [[IFTTTAnimationKeyFrame alloc] initWithTime:MIN_DELTA andConstraint:start],
                              [[IFTTTAnimationKeyFrame alloc] initWithTime:MAX_DELTA andConstraint:end]
                            ]];
}

- (void)showCarat:(BOOL)shouldShow
{
    _carat.alpha = shouldShow ? 1.0 : 0.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end















