//
//  MCDrawSheet.h
//  ASCIIboardContainer
//
//  Created by Matt Condon on 12/12/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ACEDrawingView/ACEDrawingView.h>

@class MCDrawSheet;

@protocol MCDrawSheetDelegate <NSObject>

@optional
- (void)drawSheet:(MCDrawSheet *)sheet wasMovedWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer;
- (void)drawSheet:(MCDrawSheet *)sheet wasTappedWithGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer;

@end

@interface MCDrawSheet : UIView
{
    UIPanGestureRecognizer *panGestureRecognizer;
    UITapGestureRecognizer *tapGestureRecognizer;
    UIView *coverView;
}

//Delegate
@property (nonatomic, assign) id<MCDrawSheetDelegate> delegate;

@property (nonatomic, retain) ACEDrawingView *drawView;


- (void)listenForGestures;
- (void)unlistenForGestures;

@end
