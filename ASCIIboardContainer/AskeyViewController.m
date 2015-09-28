//
//  ViewController.m
//  ASCIIboardContainer
//
//  Created by Matt Condon on 9/22/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import "AskeyViewController.h"
#import "Masonry.h"
#import <MCBouncyButton/MCBouncyButton.h>
#import <Crashlytics/Crashlytics.h>
#import "Flurry.h"
#import "Config.h"
#import "AKLargeButton.h"
#import "AKCharacterPackManager.h"
#import "CharacterPackViewController.h"
#import "MKStoreKit.h"
#import "AKLogManager.h"

#define CONTAINER_PADDING 20
#define BUTTON_PADDING 15
#define TWITTER_BUTTON_HEIGHT 40

@implementation AskeyViewController

- (void)viewDidLoad {
    

    [super viewDidLoad];

    self.view.backgroundColor = ASKEY_BACKGROUND_COLOR;
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setDelegate:self];

    self.automaticallyAdjustsScrollViewInsets = NO;
    scrollView = [[AskeyScrollView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];

    scrollView.delaysContentTouches = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];

    _header = [AskeyHeaderViewController sharedHeader];
    _header.delegate = self;
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    currentWindow.backgroundColor = ASKEY_BACKGROUND_COLOR;
    [currentWindow addSubview:_header.view];

    [_header.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(currentWindow);
        make.top.equalTo(currentWindow);
    }];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];


    [self updatePurchased];


    textBtn = [[CharacterPackButton alloc] initWithText:NSLocalizedString(@"TEXT_PACK", nil)
                                                               andBackground:@"textbg"
                                                                   purchased:textPurchased];
    [textBtn addTarget:self action:@selector(textPackPressed:) forControlEvents:UIControlEventTouchUpInside];
    emojiBtn = [[CharacterPackButton alloc] initWithText:NSLocalizedString(@"EMOJI_PACK", nil)
                                                                andBackground:@"emojibg"
                                                                    purchased:emojiPurchased];
    [emojiBtn addTarget:self action:@selector(emojiPackPressed:) forControlEvents:UIControlEventTouchUpInside];
    mailBtn = [[CharacterPackButton alloc] initWithText:NSLocalizedString(@"MAIL_PACK", nil)
                                                               andBackground:@"mailbg"
                                                                   purchased:mailPurchased];
    [mailBtn addTarget:self action:@selector(mailPackPressed:) forControlEvents:UIControlEventTouchUpInside];
    bundleBtn = [[CharacterPackButton alloc] initWithText:NSLocalizedString(@"BUNDLE_PACK", nil)
                                                                 andBackground:@"bundlebg"
                                                                     purchased:bundlePurchased];
    [bundleBtn addTarget:self action:@selector(bundlePackPressed:) forControlEvents:UIControlEventTouchUpInside];

    UIView *buttonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, LARGE_HEADER_HEIGHT, self.view.frame.size.width, 150)];
    buttonContainer.userInteractionEnabled = YES;
    [buttonContainer addSubview:textBtn];
    [buttonContainer addSubview:emojiBtn];
    [buttonContainer addSubview:mailBtn];
    [buttonContainer addSubview:bundleBtn];

    [scrollView addSubview:buttonContainer];

    [textBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonContainer);
        make.left.equalTo(buttonContainer).offset(CONTAINER_PADDING);
        make.height.equalTo(@NORMAL_BUTTON_HEIGHT);
        make.right.equalTo(buttonContainer.mas_centerX).offset(-CONTAINER_PADDING/2.0);
    }];
    [emojiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonContainer);
        make.right.equalTo(buttonContainer).offset(-CONTAINER_PADDING);
        make.height.equalTo(@NORMAL_BUTTON_HEIGHT);
        make.left.equalTo(buttonContainer.mas_centerX).offset(CONTAINER_PADDING/2.0);
    }];
    [mailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(buttonContainer);
        make.left.equalTo(buttonContainer).offset(CONTAINER_PADDING);
        make.height.equalTo(@NORMAL_BUTTON_HEIGHT);
        make.right.equalTo(buttonContainer.mas_centerX).offset(-CONTAINER_PADDING/2.0);
    }];
    [bundleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(buttonContainer);
        make.right.equalTo(buttonContainer).offset(-CONTAINER_PADDING);
        make.height.equalTo(@NORMAL_BUTTON_HEIGHT);
        make.left.equalTo(buttonContainer.mas_centerX).offset(CONTAINER_PADDING/2.0);
    }];


    AKLargeButton *faqBtn = [[AKLargeButton alloc] initWithText:NSLocalizedString(@"FAQ", nil)];
    [faqBtn addTarget:self action:@selector(showFAQ) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:faqBtn];

    AKLargeButton *introBtn = [[AKLargeButton alloc] initWithText:NSLocalizedString(@"LAUNCH_INTRO", nil)];
    [introBtn addTarget:self action:@selector(launchIntro) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:introBtn];

    [faqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonContainer.mas_bottom).offset(CONTAINER_PADDING);
        make.height.equalTo(@NORMAL_BUTTON_HEIGHT);
        make.width.equalTo(self.view).multipliedBy(LARGE_BUTTON_RATIO);
        make.centerX.equalTo(self.view);
    }];

    [introBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(faqBtn.mas_bottom).offset(BUTTON_PADDING);
        make.height.equalTo(@NORMAL_BUTTON_HEIGHT);
        make.width.equalTo(self.view).multipliedBy(LARGE_BUTTON_RATIO);
        make.centerX.equalTo(self.view);
    }];

    matt = [[AKTwitterButton alloc] initWithText:@"@matt" username:@"mattgcondon" andPic:@"matt"];
    [scrollView addSubview:matt];

    AKTwitterButton *ben = [[AKTwitterButton alloc] initWithText:@"@ben" username:@"tfzweig" andPic:@"ben"];
    [scrollView addSubview:ben];

    [matt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(introBtn.mas_bottom).offset(CONTAINER_PADDING);
        make.left.equalTo(introBtn);
        make.height.equalTo(@TWITTER_BUTTON_HEIGHT);
        make.right.equalTo(self.view.mas_centerX).offset(-BUTTON_PADDING/2.0);
    }];

    [ben mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(introBtn.mas_bottom).offset(CONTAINER_PADDING);
        make.right.equalTo(introBtn);
        make.height.equalTo(@TWITTER_BUTTON_HEIGHT);
        make.left.equalTo(self.view.mas_centerX).offset(BUTTON_PADDING/2.0);
    }];



    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchasedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      [self updatePurchased];
                                                      [Flurry logEvent:@"ANY_PRODUCT_PURCHASED"];
                                                  }];

    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoredPurchasesNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      [self updatePurchased];
                                                      [Flurry logEvent:@"PURCHASES_RESTORED"];
                                                  }];

    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoringPurchasesFailedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      [self updatePurchased];
                                                      [Flurry logEvent:@"RESTORING_PURCHASES_FAILED"];
                                                  }];

    [Flurry logEvent:@"CONTAINER_APP_OPENED"];
    [AKLogManager dumpLogsToFlurry];

}

- (void)updatePurchased
{

    if ([[MKStoreKit sharedKit] isProductPurchased:TEXT_IDENTIFIER]) {
        textPurchased = YES;
        [[AKCharacterPackManager sharedManager] setCharacterSetEnabled:@"text"];
    }

    if ([[MKStoreKit sharedKit] isProductPurchased:EMOJI_IDENTIFIER]) {
        emojiPurchased = YES;
        [[AKCharacterPackManager sharedManager] setCharacterSetEnabled:@"emoji"];
    }

    if ([[MKStoreKit sharedKit] isProductPurchased:MAIL_IDENTIFIER]) {
        mailPurchased = YES;
        [[AKCharacterPackManager sharedManager] setCharacterSetEnabled:@"mail"];
    }

    if ([[MKStoreKit sharedKit] isProductPurchased:BUNDLE_IDENTIFIER]) {
        [[AKCharacterPackManager sharedManager] setCharacterSetEnabled:@"text"];
        [[AKCharacterPackManager sharedManager] setCharacterSetEnabled:@"emoji"];
        [[AKCharacterPackManager sharedManager] setCharacterSetEnabled:@"mail"];
        bundlePurchased = YES;
    } else {
        bundlePurchased = textPurchased && emojiPurchased && mailPurchased;
    }


    [textBtn setPurchased:textPurchased];
    [emojiBtn setPurchased:emojiPurchased];
    [mailBtn setPurchased:mailPurchased];
    [bundleBtn setPurchased:bundlePurchased];

}

- (void)viewDidAppear:(BOOL)animated
{


    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,
                                        MAX(scrollView.frame.size.height + 1, matt.frame.origin.y + TWITTER_BUTTON_HEIGHT + BUTTON_PADDING)
                                        );

}

- (void)textPackPressed:(id)sender
{
    _presentedViewController = [[CharacterPackViewController alloc] initWithCharacterPacks:@[[[AKCharacterPackManager characterSets] objectAtIndex:0]] andPurchased:textPurchased];
    [_header showCarat:YES];
    [self _animateHeaderHeightTo:SMALL_HEADER_HEIGHT];
    [self presentViewController:_presentedViewController animated:YES completion:nil];

    [Flurry logEvent:@"PACK_BUTTON_PRESSED" withParameters:@{@"pack": @"text"}];
}

- (void)emojiPackPressed:(id)sender
{
    _presentedViewController = [[CharacterPackViewController alloc] initWithCharacterPacks:@[[[AKCharacterPackManager characterSets] objectAtIndex:1]] andPurchased:emojiPurchased];
    [_header showCarat:YES];
    [self _animateHeaderHeightTo:SMALL_HEADER_HEIGHT];
    [self presentViewController:_presentedViewController animated:YES completion:nil];

    [Flurry logEvent:@"PACK_BUTTON_PRESSED" withParameters:@{@"pack": @"emoji"}];
}

- (void)mailPackPressed:(id)sender
{
    _presentedViewController = [[CharacterPackViewController alloc] initWithCharacterPacks:@[[[AKCharacterPackManager characterSets] objectAtIndex:2]] andPurchased:mailPurchased];
    [_header showCarat:YES];
    [self _animateHeaderHeightTo:SMALL_HEADER_HEIGHT];
    [self presentViewController:_presentedViewController animated:YES completion:nil];

    [Flurry logEvent:@"PACK_BUTTON_PRESSED" withParameters:@{@"pack": @"mail"}];
}


- (void)bundlePackPressed:(id)sender
{
    _presentedViewController = [[CharacterPackViewController alloc] initWithCharacterPacks:[AKCharacterPackManager characterSets] andPurchased:bundlePurchased];
    [_header showCarat:YES];
    [self _animateHeaderHeightTo:SMALL_HEADER_HEIGHT];
    [self presentViewController:_presentedViewController animated:YES completion:nil];

    [Flurry logEvent:@"PACK_BUTTON_PRESSED" withParameters:@{@"pack": @"bundle"}];
}


- (void)makeHeaderHeight:(float)height
{
    [_header.animator animate:height];
    [_header.scaleAnimator animate:height];
}

- (void)_animateHeaderHeightTo:(float)height
{

    POPBasicAnimation *anim = [POPBasicAnimation animation];

    anim.property = [POPAnimatableProperty propertyWithName:@"com.shrugs.askey.header.height" initializer:^(POPMutableAnimatableProperty *prop) {
        // read value
        prop.readBlock = ^(id obj, CGFloat values[]) {
            values[0] = ((AskeyHeaderViewController *)obj).animator.time;
        };
        // write value
        prop.writeBlock = ^(id obj, const CGFloat values[]) {

            [((AskeyHeaderViewController *)obj).animator animate:values[0]];
            [((AskeyHeaderViewController *)obj).scaleAnimator animate:values[0]];

        };
        // dynamics threshold
        prop.threshold = 0.01;
    }];

    float startVal = _header.animator.time;
    float endVal;
    if (height == SMALL_HEADER_HEIGHT) {
        endVal = 100;
    } else {
        endVal = 0;
    }

    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.fromValue = @(startVal);
    anim.toValue = @(endVal);
    [_header pop_addAnimation:anim forKey:@"headerFrame"];
}

- (void)scrollViewDidScroll:(UIScrollView *)theScrollView
{
    [_scrollTimer invalidate];
    [self makeHeaderHeight:theScrollView.contentOffset.y];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)theScrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [_scrollTimer invalidate];
    _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                    target:self
                                                  selector:@selector(resetScrollView:)
                                                  userInfo:[NSNumber numberWithFloat:velocity.y]
                                                   repeats:NO];
}

- (void)headerHasBeenDragged:(UIPanGestureRecognizer *)rec
{

    static CGPoint originalCenter;

    if ([rec state] == UIGestureRecognizerStateBegan) {
        originalCenter = _presentedViewController.view.center;

    } else if ([rec state] == UIGestureRecognizerStateEnded) {
        // once we end, find velocity and move to the correct side
        if ([rec velocityInView:_header.view.superview].y > -1) {
            // dismiss
            [self _animateHeaderHeightTo:LARGE_HEADER_HEIGHT];
            [_presentedViewController dismissViewControllerAnimated:YES completion:^() {
                [_header showCarat:NO];
                _presentedViewController = nil;
                if (scrollView.contentOffset.y > 0) {
                    [self _animateHeaderHeightTo:SMALL_HEADER_HEIGHT];
                }
            }];
        } else {
            [self _animateHeaderHeightTo:SMALL_HEADER_HEIGHT];
            POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
            anim.toValue = [NSValue valueWithCGPoint:originalCenter];
            [_presentedViewController.view pop_addAnimation:anim forKey:@"presentedViewController"];
        }

        return;
    }

    float deltaY = [rec translationInView:_header.view.superview].y;

    CGPoint f = _presentedViewController.view.center;
    f.y = originalCenter.y + MIN(deltaY, 100);
    _presentedViewController.view.center = f;

    [self makeHeaderHeight:[self revertRange:deltaY]];

}

- (float)revertRange:(float)in
{
    // turns a number in [100, 0] to [0, 100]
    float outMax = 100;
    float outMin = 0;
    float inMax = 0;
    float inMin = 100;

    return outMin + (outMax - outMin) * (in - inMin) / (inMax - inMin);
}

- (void)headerHasBeenTapped
{
    [_presentedViewController dismissViewControllerAnimated:YES completion:^(){
        [_header showCarat:NO];
        _presentedViewController = nil;
    }];
    [self _animateHeaderHeightTo:LARGE_HEADER_HEIGHT];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return !(_presentedViewController == nil);
}

- (void)resetScrollView:(NSTimer *)timer
{
    if (scrollView.contentOffset.y > 5) {
        if ([timer.userInfo floatValue] < 0) {
            [scrollView setContentOffset:CGPointMake(0, -20) animated:YES];
        } else {
            [scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
        }
    }
}

- (void)showFAQ
{
    [self launchURL:@"http://askeyapp.com/faq"];
    [Flurry logEvent:@"FAQ_BUTTON_CLICKED"];
}

- (void)launchURL:(NSString *)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

#pragma mark - Intro

- (void)launchIntro
{
    _presentedViewController = [[AKIntroViewController alloc] init];
    [_header showCarat:YES];
    [self _animateHeaderHeightTo:SMALL_HEADER_HEIGHT];
    [self presentViewController:_presentedViewController animated:YES completion:nil];

    [Flurry logEvent:@"LAUNCH_INTRO_BUTTON_CLICKED"];
}

#pragma UINavigationController
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController class] == [self class]) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end





















