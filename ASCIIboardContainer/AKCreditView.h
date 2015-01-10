//
//  AKCreditView.h
//  ASCIIboardContainer
//
//  Created by Matt Condon on 1/8/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKCreditView : UIView
{
    NSString *_twitter;
    NSString *_web;
}

- (id)initWithFrame:(CGRect)frame text:(NSString *)text twitter:(NSString *)twitter andWeb:(NSString *)web;

@end
