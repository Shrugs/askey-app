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


@interface KeyboardViewController ()



@property (nonatomic, strong) UIButton    *brushButton;
@property (nonatomic, strong) UIButton    *nextKeyboardButton;
@property (nonatomic, strong) UIButton    *clearButton;
@property (nonatomic, strong) UIButton    *enterButton;
@property (nonatomic, strong) UIButton    *backspaceButton;
@property (nonatomic, strong) UIButton    *undoButton;
@property (nonatomic, strong) UIImageView *drawImage;
@property (nonatomic) float brushSize;


// array of characters that were inserted (I should use a queue for this)
@property (nonatomic, strong) NSMutableArray *insertHistory;
// array of lines drawn that they can undo
@property (nonatomic, strong) NSMutableArray *drawHistory;

@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];

    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
    NSLog(@"viewDidLoad");
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];

    self.drawImage = [[UIImageView alloc] initWithFrame:self.view.frame];
    [self.drawImage setBackgroundColor:[UIColor clearColor]];

    [self.view addSubview:self.drawImage];

    [self.drawImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.view);
        make.width.equalTo(self.view).multipliedBy(0.8);
        make.center.equalTo(self.view);
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
    [self.brushButton addTarget:self action:@selector(brushButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

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

    [self.brushButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).multipliedBy(0.3*0.5).offset(-5);
        make.height.equalTo(self.brushButton.mas_width);
        make.left.equalTo(self.view).offset(2);
        make.top.equalTo(self.view).offset(2);
    }];
    [self.nextKeyboardButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(self.view).multipliedBy(0.3*0.5).offset(-5);
        make.height.equalTo(self.nextKeyboardButton.mas_width);
        make.left.equalTo(self.view.mas_left).offset(2);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).multipliedBy(0.3*0.5).offset(-5);
        make.height.equalTo(self.enterButton.mas_width);
        make.right.equalTo(self.view).offset(-2);
        make.top.equalTo(self.view).offset(2);
    }];
    [self.backspaceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).multipliedBy(0.3*0.5).offset(-5);
        make.height.equalTo(self.backspaceButton.mas_width);
        make.right.equalTo(self.enterButton.mas_right);
        make.top.equalTo(self.enterButton.mas_bottom).offset(2);
    }];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).multipliedBy(0.3*0.5).offset(-5);
        make.height.equalTo(self.clearButton.mas_width);
        make.right.equalTo(self.enterButton.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.undoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).multipliedBy(0.3*0.5).offset(-5);
        make.height.equalTo(self.undoButton.mas_width);
        make.right.equalTo(self.clearButton.mas_right);
        make.bottom.equalTo(self.clearButton.mas_top).offset(-2);
    }];
    NSLog(@"Done Layout");

    self.insertHistory = [[NSMutableArray alloc] init];
    self.brushSize = 10.0;

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
    NSLog(@"Should configure some shit here");
}

- (void)clearButtonPressed:(UIButton *)sender
{
    self.drawImage.image = nil;
}

- (void)enterButtonPressed:(UIButton *)sender
{
    NSString *text = [self.drawImage.image getASCII];
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
    NSLog(@"UNDO");
}


#pragma Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.drawImage];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.drawImage];

    UIGraphicsBeginImageContext(self.drawImage.frame.size);
    [self.drawImage.image drawInRect:CGRectMake(0, 0, self.drawImage.frame.size.width, self.drawImage.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.brushSize);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);

    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.drawImage setAlpha:1.0];
    UIGraphicsEndImageContext();

    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(self.drawImage.frame.size);
        [self.drawImage.image drawInRect:CGRectMake(0, 0, self.drawImage.frame.size.width, self.drawImage.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.brushSize);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        [self.drawImage setAlpha:1.0];
        UIGraphicsEndImageContext();
    }

}




@end

























