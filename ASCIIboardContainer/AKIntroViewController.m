//
//  AKIntroViewController.m
//  ASCIIboardContainer
//
//  Created by Matt Condon on 1/6/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import "AKIntroViewController.h"
#import "NSString+FontAwesome.h"
#import "Config.h"
#import <Masonry/Masonry.h>
#include "UIImage+ASCII.h"
#import "AKCharacterPackManager.h"
#import "AKLargeButton.h"
#import "AskeyHeaderViewController.h"

#define NUM_PAGES 9
#define NUM_PICTURES 8
#define SCREENSHOT_W_H_RATIO (.490640953f)
#define SCREENSHOT_HEIGHT_RATIO 0.7

#define INTRO_VIDEO_EXTRA_SCALE 1.12

// percentage of the screen to move the screenshot up to make room for text below it

static int ARROW_SIZE = 210;

@implementation AKIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _container = [[UIView alloc] initWithFrame:self.view.bounds];

    [self.view addSubview:_container];

    _container.backgroundColor = ASKEY_BACKGROUND_COLOR;
    self.view.backgroundColor = ASKEY_BACKGROUND_COLOR;

    ARROW_SIZE = floor(self.view.frame.size.height * 0.28);

    _imgHeight = SCREENSHOT_HEIGHT_RATIO * self.view.frame.size.height;
    _imgWidth = SCREENSHOT_W_H_RATIO * _imgHeight;

    // SCROLL VIEW
    // create the scrollview with the clear background - set it to have sections for 8 views
    // load the 7 images at the correct intervals and set up JazzHands
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                 SMALL_HEADER_HEIGHT,
                                                                 self.view.frame.size.width,
                                                                 self.view.frame.size.height - SMALL_HEADER_HEIGHT)];
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * NUM_PAGES, _scrollView.frame.size.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [_container addSubview:_scrollView];

    _originalCenter = [self.view convertPoint:self.view.center toView:_scrollView];

}

- (void)viewWillAppear:(BOOL)animated
{
    // INTRO VIDEO
    [self loadIntroVideo];
}

- (void)viewDidAppear:(BOOL)animated
{

    // IMAGES
    _introImages = [[NSMutableArray alloc] initWithCapacity:NUM_PICTURES];
    for (int i = 1; i < NUM_PICTURES; i++) {
        // for each page, load from disk, create a UIImageView, and place accordingly
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[@"intro" stringByAppendingString:[NSString stringWithFormat:@"%i", i]]]];
        iv.frame = CGRectMake(0, 0, _imgWidth, _imgHeight);
        iv.center = CGPointMake(_originalCenter.x + (i * self.view.frame.size.width),
                                _originalCenter.y);

        [_scrollView addSubview:iv];
        [_introImages addObject:iv];

        // create text for each image
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        [textLabel setText:[self textForStep:i]];
        textLabel.numberOfLines = 3;
        textLabel.textColor = [UIColor grayColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        [_scrollView addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iv.mas_bottom).offset(5);
            make.left.equalTo(iv).offset(-50);
            make.right.equalTo(iv).offset(50);
            make.height.equalTo(@50);
        }];

        // carat for each image
        UIButton *carat = [[UIButton alloc] init];
        [carat setTitle:[NSString fa_stringForFontAwesomeIcon:FACaretRight] forState:UIControlStateNormal];
        [carat setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [carat.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFont size:30]];
        [carat addTarget:self action:@selector(incrementPage) forControlEvents:UIControlEventTouchDown];
        [_scrollView addSubview:carat];

        [carat mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(iv);
            make.left.equalTo(iv.mas_right).offset(20);
        }];
    }


//    // ARROW
//    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
//    arrow.userInteractionEnabled = NO;
//    [self.view addSubview:arrow];
//
//    // JAZZ HANDS
//    self.animator = [IFTTTAnimator new];
//    IFTTTFrameAnimation *frameAnimation = [IFTTTFrameAnimation new];
//    frameAnimation.view = arrow;
//    [self.animator addAnimation:frameAnimation];
//
////    self.transformAnimator = [IFTTTAnimator new];
////    IFTTTTransform3DAnimation *arrowRotationAnimation = [IFTTTTransform3DAnimation new];
////    arrowRotationAnimation.view = arrow;
////    [self.transformAnimator addAnimation:arrowRotationAnimation];
////
////    [arrowRotationAnimation addKeyFrame:[[IFTTTAnimationKeyFrame alloc] initWithTime:0 andTransform3D:[IFTTTTransform3D]]];
//    [frameAnimation addKeyFrame:[[IFTTTAnimationKeyFrame alloc] initWithTime:0 andFrame:arrow.frame]];
//    for (int i = 0; i < NUM_PICTURES; i++) {
//        //intro
//        [frameAnimation addKeyFrame:[[IFTTTAnimationKeyFrame alloc] initWithTime:self.view.frame.size.width*i
//                                                                        andFrame:[self magRectForIntro:i]]];
//    }
//    int arbitraryOffset = 50;
//    [frameAnimation addKeyFrame:[[IFTTTAnimationKeyFrame alloc] initWithTime:self.view.frame.size.width*NUM_PICTURES
//                                                                    andFrame:CGRectMake(-ARROW_SIZE - arbitraryOffset,
//                                                                                        self.view.frame.size.height - ARROW_SIZE - arbitraryOffset,
//                                                                                        ARROW_SIZE,
//                                                                                        ARROW_SIZE)]];

    // LAST PAGE
    [self getThanksText];

    AKLargeButton *getStartedButton = [[AKLargeButton alloc] initWithText:@"Get Started"];
    [getStartedButton addTarget:self action:@selector(getStartedButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [getStartedButton sizeToFit];
    [self.view addSubview:getStartedButton];

    [getStartedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
    }];

    NSLayoutConstraint *btnBottom = [NSLayoutConstraint constraintWithItem:getStartedButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:80];
    [self.view addConstraint:btnBottom];
    self.offsetAnimator = [IFTTTAnimator new];
    IFTTTConstraintsAnimation *bottomAnimation = [IFTTTConstraintsAnimation new];
    bottomAnimation.constraint = btnBottom;
    [self.offsetAnimator addAnimation:bottomAnimation];

    [bottomAnimation addKeyFrames:@[
                                    [[IFTTTAnimationKeyFrame alloc] initWithTime:(NUM_PICTURES-1)*self.view.frame.size.width + (self.view.frame.size.width / 4) andConstraint:80],
                                    [[IFTTTAnimationKeyFrame alloc] initWithTime:(NUM_PICTURES)*self.view.frame.size.width andConstraint:-40],
                                    ]];


}

- (void)getStartedButtonPressed
{
    [[AskeyHeaderViewController sharedHeader].delegate headerHasBeenTapped];
}

- (void)loadIntroVideo
{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"intro" ofType:@"mp4"]];

    _moviePlayer =[[MPMoviePlayerController alloc] initWithContentURL:url];
    [_moviePlayer prepareToPlay];
    [_moviePlayer setShouldAutoplay:YES];
    [_moviePlayer setControlStyle:2];
    [_moviePlayer setRepeatMode:MPMovieRepeatModeOne];
    [_moviePlayer setControlStyle:MPMovieControlStyleNone];
    [_moviePlayer setAllowsAirPlay:NO];
    _moviePlayer.backgroundView.backgroundColor = [UIColor clearColor];
    _moviePlayer.view.backgroundColor = [UIColor clearColor];
    for(UIView *aSubView in _moviePlayer.view.subviews) {
        aSubView.backgroundColor = [UIColor clearColor];
    }
    _moviePlayer.view.frame = CGRectMake(0, 0, _imgWidth*INTRO_VIDEO_EXTRA_SCALE, _imgHeight*INTRO_VIDEO_EXTRA_SCALE);
    _moviePlayer.view.center = CGPointMake(_originalCenter.x, (self.view.frame.size.height-SMALL_HEADER_HEIGHT)/2);
    [_scrollView addSubview:_moviePlayer.view];

    UIButton *carat = [[UIButton alloc] init];
    [carat setTitle:[NSString fa_stringForFontAwesomeIcon:FACaretRight] forState:UIControlStateNormal];
    [carat setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [carat.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFont size:30]];
    [carat addTarget:self action:@selector(incrementPage) forControlEvents:UIControlEventTouchDown];
    [_scrollView addSubview:carat];

    [carat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_moviePlayer.view);
        make.left.equalTo(_moviePlayer.view.mas_right).offset(20);
    }];

}

- (void)incrementPage
{
    [_scrollView setContentOffset:CGPointMake([_scrollView contentOffset].x + self.view.frame.size.width, 0) animated:YES];
}

- (void)getThanksText
{
    UITextView *thanksField = [[UITextView alloc] initWithFrame:CGRectMake(8*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height - 80)];
    thanksField.backgroundColor = [UIColor clearColor];
    [thanksField setEditable:NO];
    [_scrollView addSubview:thanksField];


    NSString* content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"enjoy_askey" ofType:@"txt"]
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];

    [thanksField setText:content];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)textForStep:(int)i {

    NSString *introKey = [NSString stringWithFormat:@"INTRO_STEP_%i", i];
    return NSLocalizedString(introKey, nil);
}

//- (CGRect)magRectForIntro:(int)i
//{
//    float xRatio, yRatio;
//
//    switch (i) {
//        case 1:
//            xRatio = 0.25;
//            yRatio = 0.43;
//            break;
//
//        case 2:
//            xRatio = 0.25;
//            yRatio = 0.57;
//            break;
//
//        case 3:
//            xRatio = 0.25;
//            yRatio = 0.26;
//            break;
//
//        case 4:
//            xRatio = 0.29;
//            yRatio = 0.42;
//            break;
//
//        case 5:
//            xRatio = 0.25;
//            yRatio = 0.45;
//            break;
//
//        case 6:
//            xRatio = 0.25;
//            yRatio = 0.38;
//            break;
//
//        case 7:
//            xRatio = 0.80;
//            yRatio = 0.25;
//            break;
//
//        default:
//            xRatio = 0.5;
//            yRatio = 0.5;
//            break;
//    }
//
//    CGPoint center = [[_introImages objectAtIndex:0] convertPoint:CGPointMake(_imgWidth*xRatio, _imgHeight*yRatio) toView:self.view];
//    return CGRectMake(center.x - ARROW_SIZE/2 - self.view.frame.size.width, center.y - ARROW_SIZE/2, ARROW_SIZE, ARROW_SIZE);
//
//}

#pragma mark - UIScrollViewSelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // animate magnifier
    [self.animator animate:scrollView.contentOffset.x];
    [self.offsetAnimator animate:scrollView.contentOffset.x];
}


@end
