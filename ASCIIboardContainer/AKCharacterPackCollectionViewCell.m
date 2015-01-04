//
//  AKCharacterPackCollectionViewCell.m
//  ASCIIboardContainer
//
//  Created by Matt Condon on 1/3/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import "AKCharacterPackCollectionViewCell.h"
#import "Config.h"
#import <Masonry/Masonry.h>
#import <POP.h>

@implementation AKCharacterPackCollectionViewCell

- (void)setText:(NSString *)text
{
    self.layer.backgroundColor = [ASKEY_BUTTON_BODY_COLOR CGColor];
    self.layer.shadowColor = [ASKEY_BUTTON_SHADOW_COLOR CGColor];
    self.layer.cornerRadius = 4.0f;
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius = 0.0f;

    textLabel = [[UILabel alloc] initWithFrame:self.frame];
    [textLabel setText:text];
    [textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18]];
    [textLabel setTextColor:ASKEY_BLUE_COLOR];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    touchDown = YES;
    [self touchDownInside:self];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Triggered when touch is released
    if (touchDown) {
        [self touchUpInside:self];
        touchDown = NO;
    }
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Triggered if touch leaves view
    if (touchDown) {
        [self touchUpInside:self];
        touchDown = NO;
    }
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchDownInside:(AKCharacterPackCollectionViewCell *)btn
{
    // cancel a previous animation
    POPSpringAnimation *scaleUpAnim = [self.layer pop_animationForKey:@"AKCharacterPackCollectionViewCell_scaleUp"];
    if (scaleUpAnim) {
        [self.layer removeAnimationForKey:@"AKCharacterPackCollectionViewCell_scaleUp"];
    }

    // bounce to smaller size
    POPBasicAnimation *anim = [self.layer pop_animationForKey:@"AKCharacterPackCollectionViewCell_scaleDown"];
    if (!anim) {
        anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    }
    anim.toValue = [NSValue valueWithCGSize:CGSizeMake(0.9, 0.9)];
    // @TODO(Shrugs) this may or may not be a valuable exported variable
    anim.duration = 0.1f;
    [self.layer pop_addAnimation:anim forKey:@"AKCharacterPackCollectionViewCell_scaleDown"];
}

- (void)touchUpInside:(AKCharacterPackCollectionViewCell *)btn
{
    // bounce back to normal size
    POPBasicAnimation *oldAnim = [self.layer pop_animationForKey:@"AKCharacterPackCollectionViewCell_scaleDown"];
    if (oldAnim) {
        // wait for previous animation to finish if necessary
        oldAnim.completionBlock = ^(POPAnimation *oldAnim, BOOL finished) {
            [self scaleUp];
        };
    } else {
        [self scaleUp];
    }

}

- (void)scaleUp
{
    // rescale button to 1.0x1.0
    POPSpringAnimation *anim = [self.layer pop_animationForKey:@"AKCharacterPackCollectionViewCell_scaleUp"];
    if (!anim) {
        anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    }
    anim.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    anim.springBounciness = 20.0f;
    anim.springSpeed = 15.0f;
    [self.layer pop_addAnimation:anim forKey:@"AKCharacterPackCollectionViewCell_scaleUp"];
}

@end
