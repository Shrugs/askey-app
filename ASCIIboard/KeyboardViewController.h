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

// DEBUG
#define DEBUG_SPACERS NO

// BRUSH SIZES
#define BRUSH_SIZE_SMALL 11.0f
#define BRUSH_SIZE_MEDIUM 15.0f
#define BRUSH_SIZE_LARGE 20.0f


// ASKEY VALUES
#define ASKEY_HEIGHT 300.0
// same ratio as 8.5x11 paper
#define ASKEY_WIDTH_RATIO 0.772727273f
// ratio of sheet height to view height
#define ASKEY_HEIGHT_FRACTION 0.8f

// size of buttons relative to a fouth of the view height
#define RELATIVE_BUTTON_SIZE 0.75
#define BUTTON_HEIGHT (ASKEY_HEIGHT * 0.25 * RELATIVE_BUTTON_SIZE)

// height of exposed portion of sheet, relative to keyboard height
#define RELATIVE_SHEET_EXPOSED_HEIGHT 0.15
// base velocity of sheets
#define SHEET_VELOCITY 10
// initial delay in seconds for first sheet to slide in
#define INITIAL_SHEET_DELAY 0.3f

@interface KeyboardViewController : UIInputViewController  <LIVBubbleButtonDelegate, ACEDrawingViewDelegate, MCDrawSheetDelegate>
{
    LIVBubbleMenu *brushMenu;
    NSLayoutConstraint *_heightConstraint;
    UIView *kludge;
}

// BUTTONS
@property (nonatomic, strong) AKButton *brushButton;
@property (nonatomic, strong) AKButton *nextKeyboardButton;
@property (nonatomic, strong) AKButton *clearButton;
@property (nonatomic, strong) AKButton *enterButton;
@property (nonatomic, strong) AKButton *backspaceButton;
@property (nonatomic, strong) AKButton *undoButton;
@property (nonatomic, strong) AKButton *eraserButton;
// SHEETS
@property (nonatomic, strong) MCDrawSheet *currentSheet;
@property (nonatomic, strong) MCDrawSheet *previousSheet;
@property (nonatomic, strong) UIView *sheetBackground;

// array of images that must be retained
@property (nonatomic, retain) NSArray *brushImagesArray;


// array of characters that were inserted (I should use a queue for this)
@property (nonatomic, strong) NSMutableArray *insertHistory;
// array of lines drawn that they can undo
@property (nonatomic, strong) NSMutableArray *drawHistory;

@end
