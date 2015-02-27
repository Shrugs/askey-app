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

#define NUM_PAGES 9
#define NUM_PICTURES 8
#define SCREENSHOT_W_H_RATIO (.490640953f)
#define SCREENSHOT_HEIGHT_RATIO 0.7

// percentage of the screen to move the screenshot up to make room for text below it

static int MAG_SIZE = 210;

@implementation AKIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _container = [[UIView alloc] initWithFrame:self.view.bounds];

    [self.view addSubview:_container];

    _container.backgroundColor = ASKEY_BACKGROUND_COLOR;
    self.view.backgroundColor = ASKEY_BACKGROUND_COLOR;

    MAG_SIZE = floor(self.view.frame.size.height * 0.28);

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

    CGPoint originalCenter = [self.view convertPoint:self.view.center toView:_scrollView];

    // IMAGES
    _introImages = [[NSMutableArray alloc] initWithCapacity:NUM_PICTURES];
    for (int i = 1; i < NUM_PICTURES; i++) {
        // for each page, load from disk, create a UIImageView, and place accordingly
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[@"intro" stringByAppendingString:[NSString stringWithFormat:@"%i", i]]]];
        iv.frame = CGRectMake(0, 0, _imgWidth, _imgHeight);
        iv.center = CGPointMake(originalCenter.x + (i * self.view.frame.size.width),
                                originalCenter.y);

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
    }


    // MAGNIFIER
    _magnifier = [[ACMagnifyingGlass alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height, MAG_SIZE, MAG_SIZE)];
    _magnifier.layer.shadowColor = [ASKEY_BUTTON_SHADOW_COLOR CGColor];
    _magnifier.layer.shadowRadius = MAG_SIZE * 0.01;
    _magnifier.layer.shadowOffset = CGSizeMake(1, 2);
    _magnifier.viewToMagnify = _container;
    _magnifier.userInteractionEnabled = NO;
    [self.view addSubview:_magnifier];

    // JAZZ HANDS
    self.animator = [IFTTTAnimator new];
    IFTTTFrameAnimation *frameAnimation = [IFTTTFrameAnimation new];
    frameAnimation.view = _magnifier;
    [self.animator addAnimation:frameAnimation];

    [frameAnimation addKeyFrame:[[IFTTTAnimationKeyFrame alloc] initWithTime:0 andFrame:_magnifier.frame]];
    for (int i = 0; i < NUM_PICTURES; i++) {
        //introi
        [frameAnimation addKeyFrame:[[IFTTTAnimationKeyFrame alloc] initWithTime:self.view.frame.size.width*i
                                                                        andFrame:[self magRectForIntro:i]]];
    }
    int arbitraryOffset = 50;
    [frameAnimation addKeyFrame:[[IFTTTAnimationKeyFrame alloc] initWithTime:self.view.frame.size.width*NUM_PICTURES
                                                                    andFrame:CGRectMake(-MAG_SIZE - arbitraryOffset,
                                                                                        self.view.frame.size.height - MAG_SIZE - arbitraryOffset,
                                                                                        MAG_SIZE,
                                                                                        MAG_SIZE)]];


}

- (void)viewDidAppear:(BOOL)animated
{
    // animate stuff into position
    // animate GIF into position and start playing
    // when gif is finished, automatically move to next panel if x translation at 0
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)textForStep:(int)i {

    NSString *introKey = [NSString stringWithFormat:@"INTRO_STEP_%i", i];
    return NSLocalizedString(introKey, nil);
}

- (CGRect)magRectForIntro:(int)i
{
    float xRatio, yRatio;

    switch (i) {
        case 1:
            xRatio = 0.25;
            yRatio = 0.43;
            break;

        case 2:
            xRatio = 0.25;
            yRatio = 0.57;
            break;

        case 3:
            xRatio = 0.25;
            yRatio = 0.26;
            break;

        case 4:
            xRatio = 0.29;
            yRatio = 0.42;
            break;

        case 5:
            xRatio = 0.25;
            yRatio = 0.45;
            break;

        case 6:
            xRatio = 0.25;
            yRatio = 0.38;
            break;

        case 7:
            xRatio = 0.80;
            yRatio = 0.25;
            break;

        default:
            xRatio = 0.5;
            yRatio = 0.5;
            break;
    }

    CGPoint center = [[_introImages objectAtIndex:0] convertPoint:CGPointMake(_imgWidth*xRatio, _imgHeight*yRatio) toView:self.view];
    return CGRectMake(center.x - MAG_SIZE/2 - self.view.frame.size.width, center.y - MAG_SIZE/2, MAG_SIZE, MAG_SIZE);

}

#pragma mark - UIScrollViewSelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // animate magnifier
    [self.animator animate:scrollView.contentOffset.x];
    [_magnifier setNeedsDisplay];
}


@end
