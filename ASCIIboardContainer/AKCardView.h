//
//  AKCardView.h
//  ASCIIboardContainer
//
//  Created by Matt Condon on 1/5/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKCardView : UIView
{
    NSDictionary *_pack;
    UITextView *_textView;
}

- (void)setPack:(NSDictionary *)pack;

@end
