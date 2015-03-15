//
//  AKIntroViewController.h
//  ASCIIboardContainer
//
//  Created by Matt Condon on 1/6/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ACMagnifyingGlass.h>
#import <IFTTTJazzHands.h>
#import <MediaPlayer/MediaPlayer.h>

@class AKIntroViewController;

@protocol AKIntroViewControllerDelegate <NSObject>

@required
- (void)shouldCloseIntroViewController:(AKIntroViewController *)controller;

@end


@interface AKIntroViewController : UIViewController <UIScrollViewDelegate>
{
    ACMagnifyingGlass *_magnifier;
    UIScrollView *_scrollView;
    NSMutableArray *_introImages;
    float _imgWidth;
    float _imgHeight;

    UIView *_container;
    CGPoint _originalCenter;

    MPMoviePlayerController *_moviePlayer;
}

@property (nonatomic, strong) IFTTTAnimator *animator;
@property (nonatomic, strong) IFTTTAnimator *offsetAnimator;

@end
