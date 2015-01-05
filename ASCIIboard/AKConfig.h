//
//  AKConfig.h
//  ASCIIboardContainer
//
//  Created by Matt Condon on 12/19/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#ifndef ASCIIboardContainer_AKConfig_h
#define ASCIIboardContainer_AKConfig_h


// DEBUG
#define DEBUG_SPACERS NO

// BRUSH SIZES
#define BRUSH_SIZE_SMALL 11.0f
#define BRUSH_SIZE_MEDIUM 15.0f
#define BRUSH_SIZE_LARGE 20.0f

#define BRUSH_BUTTON_RELATIVE_SIZE 0.9f

// ASKEY VALUES
#define ASKEY_HEIGHT 280.0
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
// speed to guarantee decrement
#define SHEET_VELOCITY_THRESHOLD 300
// position thresh to guarantee decrement
#define SHEET_TRANSLATION_THRESHOLD 50

// UI/UX
#define ASKEY_HOLD_DURATION 0.3f
#define ASKEY_BACKGROUND_COLOR [UIColor colorWithRed:0.863 green:.8671875 blue:.8828125 alpha:1.000]
#define ASKEY_BLUE_COLOR [UIColor colorWithRed:11.0/255.0 green:106.0/255.0 blue:1.0 alpha: 1.0]


// CONSTS
#define ASKEY_CONTAINER_GROUP_NAME @"group.io.askey"


typedef enum {
    ASKEYScreenOrientationUnknown,
    ASKEYScreenOrientationPortrait,
    ASKEYScreenOrientationLandscape
} ASKEYScreenOrientation;


#endif
