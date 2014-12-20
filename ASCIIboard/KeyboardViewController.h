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
#import "AKButton.h"
#import "AKNumPadView.h"

@interface KeyboardViewController : UIInputViewController  <LIVBubbleButtonDelegate, ACEDrawingViewDelegate, MCDrawSheetDelegate>
{
    LIVBubbleMenu *brushMenu;
    LIVBubbleMenu *characterPackMenu;
    NSLayoutConstraint *_heightConstraint;
    UIView *kludge;
    NSTimer* holdTimer;
    BOOL enterButtonWasHeld;
}

// BUTTONS
@property (nonatomic, strong) AKButton *brushButton;
@property (nonatomic, strong) AKButton *nextKeyboardButton;
@property (nonatomic, strong) AKButton *clearButton;
@property (nonatomic, strong) AKButton *enterButton;
@property (nonatomic, strong) AKButton *backspaceButton;
@property (nonatomic, strong) AKButton *undoButton;
@property (nonatomic, strong) AKButton *eraserButton;
@property (nonatomic, strong) AKButton *numpadButton;

// SHEETS
@property (nonatomic, strong) MCDrawSheet *currentSheet;
@property (nonatomic, strong) MCDrawSheet *previousSheet;
@property (nonatomic, strong) UIView *sheetBackground;

@property (nonatomic, strong) AKNumPadView *numpadView;

// array of images that must be retained
@property (nonatomic, strong) NSArray *brushButtonsArray;
@property (nonatomic, strong) NSArray *characterPackButtonsArray;


// array of characters that were inserted (I should use a queue for this)
@property (nonatomic, strong) NSMutableArray *insertHistory;
// array of lines drawn that they can undo
@property (nonatomic, strong) NSMutableArray *drawHistory;

@end
