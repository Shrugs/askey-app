//
//  MCGenericBouncyButton.m
//  ASCIIboardContainer
//
//  Created by Matt Condon on 2/15/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import "MCGenericBouncyButton.h"
#import <POP.h>

@implementation MCGenericBouncyButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)registerHandlers
{
    // handlers
    [self addTarget:self action:@selector(touchDownInside:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchAll:) forControlEvents:UIControlEventAllTouchEvents];

}

- (void)touchDownInside:(MCGenericBouncyButton *)btn
{
    // cancel a previous animation
    POPSpringAnimation *scaleUpAnim = [self.layer pop_animationForKey:@"mcbouncybutton_scaleUp"];
    if (scaleUpAnim) {
        [self.layer removeAnimationForKey:@"mcbouncybutton_scaleUp"];
    }

    // bounce to smaller size
    POPBasicAnimation *anim = [self.layer pop_animationForKey:@"mcbouncybutton_scaleDown"];
    if (!anim) {
        anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    }
    anim.toValue = [NSValue valueWithCGSize:CGSizeMake(0.9f, 0.9f)];
    // @TODO(Shrugs) this may or may not be a valuable exported variable
    anim.duration = 0.1f;
    [self.layer pop_addAnimation:anim forKey:@"mcbouncybutton_scaleDown"];
}
- (void)touchUpInside:(MCGenericBouncyButton *)btn
{
    // bounce back to normal size
    POPBasicAnimation *oldAnim = [self.layer pop_animationForKey:@"mcbouncybutton_scaleDown"];
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
- (void)touchAll:(MCGenericBouncyButton *)btn
{
    if(![btn isTracking]) {
        [self touchUpInside:btn];
    }
}

- (void)scaleUp
{
    // rescale button to 1.0x1.0
    POPSpringAnimation *anim = [self.layer pop_animationForKey:@"mcbouncybutton_scaleUp"];
    if (!anim) {
        anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    }
    anim.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    anim.springBounciness = 10.0f;
    anim.springSpeed = 10.0f;
    [self.layer pop_addAnimation:anim forKey:@"mcbouncybutton_scaleUp"];
}

@end
