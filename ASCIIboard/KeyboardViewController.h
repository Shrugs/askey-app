//
//  KeyboardViewController.h
//  ASCIIboard
//
//  Created by Matt Condon on 9/22/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCDrawSheet.h"
#import <LIVBubbleMenu/LIVBubbleMenu.h>

#define BRUSH_SIZE_SMALL 11.0f
#define BRUSH_SIZE_MEDIUM 15.0f
#define BRUSH_SIZE_LARGE 20.0f

#define ASKEY_HEIGHT 250
// same ratio as 8.5x11 paper
#define ASKEY_WIDTH_RATIO 0.772727273f

@interface KeyboardViewController : UIInputViewController  <LIVBubbleButtonDelegate, ACEDrawingViewDelegate>
{
    BOOL mouseSwiped;
    CGPoint lastPoint;
    LIVBubbleMenu *brushMenu;
    NSLayoutConstraint *_heightConstraint;
    UIView *kludge;
}

// BUTTONS
@property (nonatomic, strong) UIButton *brushButton;
@property (nonatomic, strong) UIButton *nextKeyboardButton;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) UIButton *enterButton;
@property (nonatomic, strong) UIButton *backspaceButton;
@property (nonatomic, strong) UIButton *undoButton;
@property (nonatomic, strong) UIButton *eraserButton;
// SHEETS
@property (nonatomic, strong) MCDrawSheet *currentSheet;
@property (nonatomic, strong) MCDrawSheet *previousSheet;

// array of images that must be retained
@property (nonatomic, retain) NSArray *brushImagesArray;


// array of characters that were inserted (I should use a queue for this)
@property (nonatomic, strong) NSMutableArray *insertHistory;
// array of lines drawn that they can undo
@property (nonatomic, strong) NSMutableArray *drawHistory;

@end
