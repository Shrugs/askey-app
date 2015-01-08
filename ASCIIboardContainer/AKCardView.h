//
//  AKCardView.h
//  ASCIIboardContainer
//
//  Created by Matt Condon on 1/5/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AKCardView;

@protocol AKCardViewDelegate <NSObject>

- (void)shouldHideCardView:(AKCardView *)cardView;

@end

@interface AKCardView : UIView <UITextViewDelegate, UIAlertViewDelegate>
{
    NSDictionary *_set;
    UITextView *_textView;
}

@property (nonatomic, weak) id <AKCardViewDelegate> delegate;

- (void)setSet:(NSDictionary *)set;

@end
