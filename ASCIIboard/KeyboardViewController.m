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

@implementation KeyboardViewController

#pragma mark - KeyboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // LOAD KLUDGE so that height can change -_-
    [self loadKludge];

    // INITS
    self.insertHistory = [[NSMutableArray alloc] init];
    self.brushImagesArray = [NSArray arrayWithObjects:
                                [UIImage imageNamed:@"Brush-Button-Up-1.png"],
                                [UIImage imageNamed:@"Brush-Button-Up-2.png"],
                                [UIImage imageNamed:@"Brush-Button-Up-3.png"],
                                nil];

    // LAYOUT
    // set bg color
    [self.view setBackgroundColor:[UIColor whiteColor]];

    // setup draw image

    self.currentSheet = [[MCDrawSheet alloc] init];
    self.currentSheet.drawView.lineWidth = BRUSH_SIZE_MEDIUM;
    self.currentSheet.drawView.delegate = self;
    [self.view addSubview:self.currentSheet];
    [self.currentSheet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.view);
        make.width.equalTo(self.view.mas_height).multipliedBy(0.9);
        make.center.equalTo(self.view);
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

    // ERASER BUTTON
    self.eraserButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.eraserButton setImage:[UIImage imageNamed:@"Edit-Button-Up.png"] forState:UIControlStateNormal];
    [self.eraserButton setImage:[UIImage imageNamed:@"Edit-Button-Down.png"] forState:UIControlStateHighlighted];
    [self.eraserButton addTarget:self action:@selector(eraserButtonPressed:) forControlEvents:UIControlEventTouchDown];

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
    [self.view addSubview:self.eraserButton];
    [self.view addSubview:self.clearButton];
    [self.view addSubview:self.enterButton];
    [self.view addSubview:self.backspaceButton];
    [self.view addSubview:self.undoButton];

    [self establishConstraints];

}

// - (void)viewDidAppear:(BOOL)animated
// {
//     [self makeKeyboardHeight:250];
// }

- (void)makeKeyboardHeight:(float)height
{
    [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
}

- (void)loadKludge
{
    if (kludge == nil) {
        kludge = [[UIView alloc] init];
        [self.view addSubview:kludge];
        kludge.translatesAutoresizingMaskIntoConstraints = NO;
        kludge.hidden = YES;

        [kludge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view.mas_left);
            make.top.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_top);
        }];

    }
}

- (void)establishPortraitIPhoneConstraints
{

    [self.brushButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.view).multipliedBy(0.25*0.95);
        make.width.equalTo(self.brushButton.mas_height);
        make.left.equalTo(self.view).offset(2);
        make.top.equalTo(self.view).offset(2);
    }];
    [self.eraserButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.view).multipliedBy(0.25*0.95);
        make.width.equalTo(self.eraserButton.mas_height);
        make.left.equalTo(self.view).offset(2);
        make.top.equalTo(self.brushButton.mas_bottom).offset(2);
    }];
    [self.nextKeyboardButton mas_remakeConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(self.view).multipliedBy(0.25*0.95);
        make.width.equalTo(self.nextKeyboardButton.mas_height);
        make.left.equalTo(self.view.mas_left).offset(2);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.enterButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.view).multipliedBy(0.25*0.95);
        make.width.equalTo(self.enterButton.mas_height);
        make.right.equalTo(self.view).offset(-2);
        make.top.equalTo(self.view).offset(2);
    }];
    [self.backspaceButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.view).multipliedBy(0.25*0.95);
        make.width.equalTo(self.backspaceButton.mas_height);
        make.right.equalTo(self.enterButton.mas_right);
        make.top.equalTo(self.enterButton.mas_bottom).offset(2);
    }];
     [self.undoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
         make.height.equalTo(self.view).multipliedBy(0.25*0.95);
         make.width.equalTo(self.undoButton.mas_height);
         make.right.equalTo(self.clearButton.mas_right);
         make.bottom.equalTo(self.clearButton.mas_top).offset(-2);
     }];
    [self.clearButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.view).multipliedBy(0.25*0.95);
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

#pragma mark - TextInput Delegate

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

#pragma mark - Button Handlers

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
    [self.currentSheet.drawView clear];
    [self updateButtonStatus];
}

- (void)eraserButtonPressed:(UIButton *)sender
{
    // change to eraser here
    NSLog(@"ERASER YAY");
}

- (void)enterButtonPressed:(UIButton *)sender
{
    CGSize numBlocks = CGSizeMake(40, 10);
    NSString *text = [self.currentSheet.drawView.image getASCIIWithResolution:numBlocks];

    // only insert period at beginning of string if necessary
    NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedString = [[self.textDocumentProxy documentContextBeforeInput] stringByTrimmingCharactersInSet:charSet];
    NSLog(@"before:%@:", [self.textDocumentProxy documentContextBeforeInput]);
    NSLog(@"beforeTrimmed:%@:", trimmedString);

    // so this condition is broken because textDocumentProxy isn't behaving
    // if ((trimmedString == nil || [trimmedString isEqualToString:@""]) && [text hasPrefix:@" "]) {
    // so for now, use this
    if ([self.insertHistory count] == 0) {
        // it's empty or contains only white spaces
        // therefore, strip extra white space
        text = [self removeExtraWhiteSpaceLinesFromText:text withSize:numBlocks];
        // and insert period if necessary
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
    [self.currentSheet.drawView undoLatestStep];
    [self updateButtonStatus];
}

- (void)updateButtonStatus
{
    self.undoButton.enabled = [self.currentSheet.drawView canUndo];
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
            self.currentSheet.drawView.lineWidth = BRUSH_SIZE_SMALL;
            break;
        case 1:
            self.currentSheet.drawView.lineWidth = BRUSH_SIZE_MEDIUM;
            break;
        case 2:
            self.currentSheet.drawView.lineWidth = BRUSH_SIZE_LARGE;
            break;
        default:
            self.currentSheet.drawView.lineWidth = BRUSH_SIZE_MEDIUM;
            break;
    }
}

//The bubble menu has been hidden
-(void)livBubbleMenuDidHide:(LIVBubbleMenu *)bubbleMenu {

}

#pragma mark - Utils


- (NSString *)removeExtraWhiteSpaceLinesFromText:(NSString *)text withSize:(CGSize)size
{
    NSRange range = NSMakeRange(0, size.width);
    while (YES) {
        // for each line of width size.width, discard it if it's whitespace
        if (text.length > 2*(size.width) &&
            [self stringIsWhiteSpace:[text substringWithRange:range]] &&
            [self stringIsWhiteSpace:[text substringWithRange:NSMakeRange(size.width, size.width)]]) {
            // if is whitespace, remove if next string is white space as well
            text = [text stringByReplacingCharactersInRange:range withString:@""];

        } else {
            break;
        }

    }

    return text;
}

- (BOOL)stringIsWhiteSpace:(NSString *)str
{
    NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedString = [str stringByTrimmingCharactersInSet:charSet];
    return (trimmedString == nil || [trimmedString isEqualToString:@""]);
}


@end

























