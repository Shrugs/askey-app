//
//  AKButton.m
//  ASCIIboardContainer
//
//  Created by Matt Condon on 12/12/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import "AKButton.h"
#import "POP.h"
#import "UIImage+NegativeImage.h"

@implementation AKButton

- (id)initWithText:(NSString *)text andDiameter:(float)diameter
{
    self = [[self class] buttonWithType:UIButtonTypeCustom];
    if (self) {
        [self configureWithDiameter:diameter];
        [self setTitle:text forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18]];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return self;
}

- (id)initWithImage:(UIImage *)image andDiameter:(float)diameter
{
    self = [[self class] buttonWithType:UIButtonTypeCustom];
    if (self) {
        // highlighted: 197, 197, 197
        if (image) {
            self.icon = image;
            self.iconNegative = [image negativeImage];
            [self setAdjustsImageWhenDisabled:YES];
        }

        [self configureWithDiameter:diameter];
    }
    return self;
}

- (void)configureWithDiameter:(float)diameter
{
    self.frame = CGRectMake(0, 0, diameter, diameter);

    float inset = 0.2*diameter;
    [self setImageEdgeInsets:UIEdgeInsetsMake(inset, inset, inset, inset)];

    [self setStyle:AKButtonStyleDefault animated:NO];

    self.layer.cornerRadius = diameter/2.0;
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius = 0.0f;
    [self addTarget:self action:@selector(touchDownInside:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchAll:) forControlEvents:UIControlEventAllTouchEvents];
}

- (void)setStyle:(AKButtonStyle)style animated:(BOOL)animated
{
    
    UIColor *bgc;
    UIColor *sc;
    switch (style) {
        case AKButtonStyleDefault: {
            if (self.icon) {
                [self setImage:self.icon forState:UIControlStateNormal];
            }
            // body: 253, 253, 253
            // shadow 132, 133, 136
            bgc = [UIColor colorWithRed:0.98828125f green:0.98828125f blue:0.98828125f alpha:1.0];
            sc = [UIColor colorWithRed:0.515625f green:0.51953125f blue:0.53125f alpha:1.0f];

            break;
        }
        case AKButtonStyleSelected: {

            if (self.icon) {
                [self setImage:self.iconNegative forState:UIControlStateNormal];
            }

            // selected 11, 106, 255
            // selected shadow 0, 94, 177
            bgc = [UIColor colorWithRed:0.04296875f green:0.4140625f blue:0.99609375f alpha:1.0];
            sc = [UIColor colorWithRed:0.0f green:0.3671875f blue:0.69140625f alpha:1.0f];

            break;
        }
        default:
            break;
    }
    if (animated) {
        [self animateToBackgroundColor:bgc
                        andShadowColor:sc];
    } else {
        self.layer.backgroundColor = [bgc CGColor];
        self.layer.shadowColor = [sc CGColor];
    }
}

- (void)touchDownInside:(AKButton *)btn
{
    // cancel a previous animation
    POPSpringAnimation *scaleUpAnim = [self.layer pop_animationForKey:@"askey_scaleUp"];
    if (scaleUpAnim) {
        [self.layer removeAnimationForKey:@"askey_scaleUp"];
    }

    // bounce to smaller size
    POPBasicAnimation *anim = [self.layer pop_animationForKey:@"askey_scaleDown"];
    if (!anim) {
        anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    }
    anim.toValue = [NSValue valueWithCGSize:CGSizeMake(0.9, 0.9)];
    anim.duration = 0.1f;
    [self.layer pop_addAnimation:anim forKey:@"askey_scaleDown"];
}
- (void)touchUpInside:(AKButton *)btn
{
    // bounce back to normal size

    POPBasicAnimation *oldAnim = [self.layer pop_animationForKey:@"askey_scaleDown"];
    if (oldAnim) {
        oldAnim.completionBlock = ^(POPAnimation *oldAnim, BOOL finished) {
            [self scaleUp];
        };
    } else {
        [self scaleUp];
    }

}

- (void)touchAll:(AKButton *)btn
{
    if(![btn isTracking]) {
        [self touchUpInside:btn];
    }
}

- (void)scaleUp
{
    POPSpringAnimation *anim = [self.layer pop_animationForKey:@"askey_scaleUp"];
    if (!anim) {
        anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    }
    anim.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    anim.springBounciness = 20.0f;
    anim.springSpeed = 15.0f;
    [self.layer pop_addAnimation:anim forKey:@"askey_scaleUp"];
}

- (void)animateToBackgroundColor:(UIColor *)bgc andShadowColor:(UIColor *)sc
{
    POPSpringAnimation *colorAnimation = [self.layer pop_animationForKey:@"colorShift"];
    if (!colorAnimation) {
        colorAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBackgroundColor];
    }
    colorAnimation.toValue = (id)[bgc CGColor];
    [self.layer pop_addAnimation:colorAnimation forKey:@"colorShift"];

    POPSpringAnimation *shadowAnimation = [self.layer pop_animationForKey:@"shadowShift"];
    if (!shadowAnimation) {
        shadowAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerShadowColor];
    }
    shadowAnimation.toValue = (id)[sc CGColor];
    [self.layer pop_addAnimation:shadowAnimation forKey:@"shadowShift"];
}

@end
