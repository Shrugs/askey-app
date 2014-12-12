//
//  KeyboardViewController.m
//  ASCIIboard
//
//  Created by Matt Condon on 9/22/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import "KeyboardViewController.h"
#import "Masonry.h"
#import "UIImage+ASCII.h"
#import <ACEDrawingView/ACEDrawingView.h>
#import <LIVBubbleMenu/LIVBubbleMenu.h>

#define BRUSH_SIZE_SMALL 11.0f
#define BRUSH_SIZE_MEDIUM 15.0f
#define BRUSH_SIZE_LARGE 20.0f

#define ASCIIBOARD_LANDSCAPE_HEIGHT 203
#define ASCIIBOARD_PORTRAIT_HEIGHT 256


@interface KeyboardViewController () <LIVBubbleButtonDelegate, ACEDrawingViewDelegate>
{
    BOOL mouseSwiped;
    CGPoint lastPoint;
    LIVBubbleMenu *brushMenu;
}



@property (nonatomic, strong) UIButton    *brushButton;
@property (nonatomic, strong) UIButton    *nextKeyboardButton;
@property (nonatomic, strong) UIButton    *clearButton;
@property (nonatomic, strong) UIButton    *enterButton;
@property (nonatomic, strong) UIButton    *backspaceButton;
 @property (nonatomic, strong) UIButton    *undoButton;
@property (nonatomic, strong) ACEDrawingView *drawImage;
@property (nonatomic) float brushSize;

@property (nonatomic, retain) NSArray *brushImagesArray;


// array of characters that were inserted (I should use a queue for this)
@property (nonatomic, strong) NSMutableArray *insertHistory;
// array of lines drawn that they can undo
@property (nonatomic, strong) NSMutableArray *drawHistory;

@end

@implementation KeyboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    // INITS
    self.insertHistory = [[NSMutableArray alloc] init];
    self.brushSize = 10.0;
    self.brushImagesArray = [NSArray arrayWithObjects:
                                [UIImage imageNamed:@"Brush-Button-Up-1.png"],
                                [UIImage imageNamed:@"Brush-Button-Up-2.png"],
                                [UIImage imageNamed:@"Brush-Button-Up-3.png"],
                                nil];

    // LAYOUT
    // set bg color
    [self.view setBackgroundColor:[UIColor whiteColor]];

    // setup draw image
    UIView *drawImageBackground = [[UIView alloc] initWithFrame:self.view.frame];
    drawImageBackground.backgroundColor = [UIColor whiteColor];
    drawImageBackground.layer.masksToBounds = NO;
    drawImageBackground.layer.shadowColor = [UIColor blackColor].CGColor;
    drawImageBackground.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    drawImageBackground.layer.shadowOpacity = 0.5f;
    drawImageBackground.layer.shadowRadius = 5.0f;

    self.drawImage = [[ACEDrawingView alloc] initWithFrame:drawImageBackground.frame];
    self.drawImage.lineWidth = BRUSH_SIZE_MEDIUM;
    self.drawImage.delegate = self;

    [drawImageBackground addSubview:self.drawImage];
    [self.view addSubview:drawImageBackground];

    [drawImageBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.view);
        make.width.equalTo(drawImageBackground.mas_height).multipliedBy(0.9);
        make.center.equalTo(self.view);
    }];

    [self.drawImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(drawImageBackground);
        make.width.equalTo(drawImageBackground);
        make.center.equalTo(drawImageBackground);
    }];

    // set up top border thing
    UIView *borderView = [[UIView alloc] init];
    [borderView setBackgroundColor:[UIColor blackColor]];
    borderView.alpha = 0.1f;
    [self.view addSubview:borderView];

    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(1.0f));
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
    }];

    // NEXT BUTTON
    self.nextKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextKeyboardButton setImage:[UIImage imageNamed:@"Globe-Button-Up.png"] forState:UIControlStateNormal];
    [self.nextKeyboardButton setImage:[UIImage imageNamed:@"Globe-Button-Down.png"] forState:UIControlStateHighlighted];
    [self.nextKeyboardButton addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];

    // BRUSH BUTTON
    self.brushButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.brushButton setImage:[UIImage imageNamed:@"Edit-Button-Up.png"] forState:UIControlStateNormal];
    [self.brushButton setImage:[UIImage imageNamed:@"Edit-Button-Down.png"] forState:UIControlStateHighlighted];
    [self.brushButton addTarget:self action:@selector(brushButtonPressed:) forControlEvents:UIControlEventTouchDown];

    // CLEAR BUTTON
    self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clearButton setImage:[UIImage imageNamed:@"Clear-Button-Up.png"] forState:UIControlStateNormal];
    [self.clearButton setImage:[UIImage imageNamed:@"Clear-Button-Down.png"] forState:UIControlStateHighlighted];
    [self.clearButton addTarget:self action:@selector(clearButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    // ENTER BUTTON
    self.enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.enterButton setImage:[UIImage imageNamed:@"Up-Button-Up.png"] forState:UIControlStateNormal];
    [self.enterButton setImage:[UIImage imageNamed:@"Up-Button-Down.png"] forState:UIControlStateHighlighted];
    [self.enterButton addTarget:self action:@selector(enterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    // BACKSPACE BUTTON
    self.backspaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backspaceButton setImage:[UIImage imageNamed:@"Delete-Button-Up.png"] forState:UIControlStateNormal];
    [self.backspaceButton setImage:[UIImage imageNamed:@"Delete-Button-Down.png"] forState:UIControlStateHighlighted];
    [self.backspaceButton addTarget:self action:@selector(backspaceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    // UNDO BUTTON
    self.undoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.undoButton setImage:[UIImage imageNamed:@"Undo-Button-Up.png"] forState:UIControlStateNormal];
    [self.undoButton setImage:[UIImage imageNamed:@"Undo-Button-Down.png"] forState:UIControlStateHighlighted];
    [self.undoButton addTarget:self action:@selector(undoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.nextKeyboardButton];
    [self.view addSubview:self.brushButton];
    [self.view addSubview:self.clearButton];
    [self.view addSubview:self.enterButton];
    [self.view addSubview:self.backspaceButton];
    [self.view addSubview:self.undoButton];

    [self establishConstraints];

}

- (void)establishPortraitIPhoneConstraints
{
    [self.brushButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.view.mas_height).multipliedBy(0.25*0.95);
        make.width.equalTo(self.brushButton.mas_height);
        make.left.equalTo(self.view).offset(2);
        make.top.equalTo(self.view).offset(2);
    }];
    [self.nextKeyboardButton mas_remakeConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(self.view.mas_height).multipliedBy(0.25*0.95);
        make.width.equalTo(self.nextKeyboardButton.mas_height);
        make.left.equalTo(self.view.mas_left).offset(2);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.enterButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.view.mas_height).multipliedBy(0.25*0.95);
        make.width.equalTo(self.enterButton.mas_height);
        make.right.equalTo(self.view).offset(-2);
        make.top.equalTo(self.view).offset(2);
    }];
    [self.backspaceButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.view.mas_height).multipliedBy(0.25*0.95);
        make.width.equalTo(self.backspaceButton.mas_height);
        make.right.equalTo(self.enterButton.mas_right);
        make.top.equalTo(self.enterButton.mas_bottom).offset(2);
    }];
     [self.undoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
         make.height.equalTo(self.view.mas_height).multipliedBy(0.25*0.95);
         make.width.equalTo(self.undoButton.mas_height);
         make.right.equalTo(self.clearButton.mas_right);
         make.bottom.equalTo(self.clearButton.mas_top).offset(-2);
     }];
    [self.clearButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.view.mas_height).multipliedBy(0.25*0.95);
        make.width.equalTo(self.clearButton.mas_height);
        make.right.equalTo(self.enterButton.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void)updateViewConstraints {

    [super updateViewConstraints];

    [self establishConstraints];


}

- (void)establishConstraints
{
    // @TODO(Shrugs) make iphone only?
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSLog(@"[DEBUG] determineKeyboardNib: Enter iPad");
        // iPad
        if (self.view.frame.size.width > 1000) {
            NSLog(@"[DEBUG] determineKeyboardNib: Enter iPad Landscape");
            // landscape
            NSLog(@"IPAD LANDSCAPE");
        } else {
            NSLog(@"[DEBUG] determineKeyboardNib: Enter iPad Portrait");
            // portrait
            NSLog(@"IPAD PORTRAIT");
        }
    } else {
        // iPhone
        if (self.view.frame.size.width > 500){
            // landscape
            [self advanceToNextInputMode];
        } else if (self.view.frame.size.width > 450){
            NSLog(@"[DEBUG] determineKeyboardNib: Enter iPhone 4 Portrait");
            // portrait
            [self establishPortraitIPhoneConstraints];
        } else {
            // NSLog(@"[DEBUG] determineKeyboardNib: Enter iPhone 5 Portrait");
            [self establishPortraitIPhoneConstraints];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}


- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.

    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
}

- (void)brushButtonPressed:(UIButton *)sender
{

    brushMenu = [[LIVBubbleMenu alloc] initWithPoint:self.brushButton.center radius:self.brushButton.frame.size.width * 2.0f menuItems:self.brushImagesArray inView:self.view];
    brushMenu.bubbleStartAngle = 0;
    brushMenu.bubbleTotalAngle = 90;
    brushMenu.bubbleRadius = self.brushButton.frame.size.width / 2.0f;
    brushMenu.bubbleShowDelayTime = 0.1f;
    brushMenu.bubbleHideDelayTime = 0.1f;
    brushMenu.bubbleSpringBounciness = 5.0f;
    // brushMenu.bubbleSpringSpeed = 10.0f;
    brushMenu.bubblePopInDuration = 0.3f;
    brushMenu.bubblePopOutDuration = 0.3f;
    brushMenu.backgroundFadeDuration = 0.3f;
    brushMenu.backgroundAlpha = 0.3f;
    brushMenu.delegate = self;
    [brushMenu show];
}

- (void)clearButtonPressed:(UIButton *)sender
{
    [self.drawImage clear];
    [self updateButtonStatus];
}

- (void)enterButtonPressed:(UIButton *)sender
{
    NSString *text = [self.drawImage.image getASCII];

    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedString = [[self.textDocumentProxy documentContextBeforeInput] stringByTrimmingCharactersInSet:charSet];
    if ((trimmedString == nil || [trimmedString isEqualToString:@""]) && [text hasPrefix:@" "]) {
        // it's empty or contains only white spaces
        // therefore, insert period
        text = [text stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"."];
    }
    [self.insertHistory insertObject:@([text length]) atIndex:0];
    [self.textDocumentProxy insertText:text];
}

- (void)backspaceButtonPressed:(UIButton *)sender
{
    if ([self.insertHistory count]) {
        NSNumber *lastTextCount = [self.insertHistory objectAtIndex:0];
        [self.insertHistory removeObjectAtIndex:0];
        for (int i = 0; i < [lastTextCount intValue]; i++) {
            [self.textDocumentProxy deleteBackward];
        }
    }
}
- (void)undoButtonPressed:(UIButton *)sender
{
    [self.drawImage undoLatestStep];
    [self updateButtonStatus];
}

- (void)updateButtonStatus
{
    self.undoButton.enabled = [self.drawImage canUndo];
}

#pragma mark - ACEDrawing View Delegate

- (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool;
{
    [self updateButtonStatus];
}

#pragma make - LIVBubbleMenu

//User selected a bubble
-(void)livBubbleMenu:(LIVBubbleMenu *)bubbleMenu tappedBubbleWithIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            self.drawImage.lineWidth = BRUSH_SIZE_SMALL;
            break;
        case 1:
            self.drawImage.lineWidth = BRUSH_SIZE_MEDIUM;
            break;
        case 2:
            self.drawImage.lineWidth = BRUSH_SIZE_LARGE;
            break;
        default:
            self.drawImage.lineWidth = BRUSH_SIZE_MEDIUM;
            break;
    }
}

//The bubble menu has been hidden
-(void)livBubbleMenuDidHide:(LIVBubbleMenu *)bubbleMenu {

}



@end

























