//
//  AKButton.m
//  ASCIIboardContainer
//
//  Created by Matt Condon on 1/4/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import "AKButton.h"
#import <POP.h>

@implementation AKButton

- (void)registerHandlers
{
    [self addTarget:self action:@selector(touchDownInside:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchAll:) forControlEvents:UIControlEventAllTouchEvents];
}

- (void)touchDownInside:(AKButton *)btn
{
    // cancel a previous animation
    POPSpringAnimation *scaleUpAnim = [self.layer pop_animationForKey:@"AKButton_scaleUp"];
    if (scaleUpAnim) {
        [self.layer removeAnimationForKey:@"AKButton_scaleUp"];
    }

    // bounce to smaller size
    POPBasicAnimation *anim = [self.layer pop_animationForKey:@"AKButton_scaleDown"];
    if (!anim) {
        anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    }
    anim.toValue = [NSValue valueWithCGSize:CGSizeMake(0.9, 0.9)];
    // @TODO(Shrugs) this may or may not be a valuable exported variable
    anim.duration = 0.1f;
    [self.layer pop_addAnimation:anim forKey:@"AKButton_scaleDown"];
}
- (void)touchUpInside:(AKButton *)btn
{
    // bounce back to normal size
    POPBasicAnimation *oldAnim = [self.layer pop_animationForKey:@"AKButton_scaleDown"];
    if (oldAnim) {
        // wait for previous animation to finish if necessary
        oldAnim.completionBlock = ^(POPAnimation *oldAnim, BOOL finished) {
            [self scaleUp];
        };
    } else {
        [self scaleUp];
    }

}

// detects when user touches inside button, drags finger outside of the view, and then releases
- (void)touchAll:(AKButton *)btn
{
    if(![btn isTracking]) {
        [self touchUpInside:btn];
    }
}

- (void)scaleUp
{
    // rescale button to 1.0x1.0
    POPSpringAnimation *anim = [self.layer pop_animationForKey:@"AKButton_scaleUp"];
    if (!anim) {
        anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    }
    anim.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    anim.springBounciness = 20.0f;
    anim.springSpeed = 15.0f;
    [self.layer pop_addAnimation:anim forKey:@"AKButton_scaleUp"];
}

@end
