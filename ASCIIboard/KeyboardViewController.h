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
#import "AKNumPadView.h"
#import <MCBouncyButton/MCBouncyButton.h>

@interface KeyboardViewController : UIInputViewController  <LIVBubbleButtonDelegate, ACEDrawingViewDelegate, MCDrawSheetDelegate>
{
    LIVBubbleMenu *brushMenu;
    LIVBubbleMenu *characterSetMenu;
    LIVBubbleMenu *characterPackMenu;

    // keyboard height stuff
    NSLayoutConstraint *_heightConstraint;
    UIView *kludge;

    // back button timer
    NSTimer* holdTimer;
    BOOL enterButtonWasHeld;

    float lastBrushSize;

    BOOL _hasFullAccess;
    NSMutableDictionary *_currentCharacterPack;
    int _currentCharacterSet;
    int _lastCharacterSet;
}

// BUTTONS
@property (nonatomic, strong) MCBouncyButton *brushButton;
@property (nonatomic, strong) MCBouncyButton *nextKeyboardButton;
@property (nonatomic, strong) MCBouncyButton *clearButton;
@property (nonatomic, strong) MCBouncyButton *enterButton;
@property (nonatomic, strong) MCBouncyButton *backspaceButton;
@property (nonatomic, strong) MCBouncyButton *undoButton;
@property (nonatomic, strong) MCBouncyButton *eraserButton;
@property (nonatomic, strong) MCBouncyButton *numpadButton;

// SHEETS
@property (nonatomic, strong) MCDrawSheet *currentSheet;
@property (nonatomic, strong) MCDrawSheet *previousSheet;
@property (nonatomic, strong) UIView *sheetBackground;

@property (nonatomic, strong) AKNumPadView *numpadView;

// array of images that must be retained
@property (nonatomic, strong) NSArray *brushButtonsArray;
@property (nonatomic, strong) NSArray *characterSetButtonsArray;
@property (nonatomic, strong) NSArray *characterPackButtonsArray;

// character sets
@property (nonatomic, strong) NSMutableArray *characterSets;


// array of characters that were inserted (I should use a queue for this)
@property (nonatomic, strong) NSMutableArray *insertHistory;
// array of lines drawn that they can undo
@property (nonatomic, strong) NSMutableArray *drawHistory;

@end
