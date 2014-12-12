//
//  MCDrawSheet.h
//  ASCIIboardContainer
//
//  Created by Matt Condon on 12/12/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ACEDrawingView/ACEDrawingView.h>

@interface MCDrawSheet : UIView
{
    UIPanGestureRecognizer *panGestureRecognizer;
    UIView *coverView;
}

@property (nonatomic, retain) ACEDrawingView *drawView;


- (void)listenForPanGestureWithTarget:(id)target action:(SEL)selector;
- (void)unlistenForPanGesture;

@end
