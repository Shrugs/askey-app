//
//  TryAskeyViewController.m
//  ASCIIboardContainer
//
//  Created by Matt Condon on 1/6/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import "TryAskeyViewController.h"
#import "NSString+FontAwesome.h"
#import "AKFullWidthButton.h"
#import <Masonry/Masonry.h>
#import "Config.h"

@interface TryAskeyViewController ()

@property (nonatomic, retain) UITextView *textView;

@end

@implementation TryAskeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNeedsStatusBarAppearanceUpdate];

    self.view.backgroundColor = [UIColor whiteColor];

    // create a back button at the top
    UIView *titleBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    titleBar.backgroundColor = ASKEY_BLUE_COLOR;
    titleBar.layer.shadowColor = [ASKEY_BUTTON_SHADOW_COLOR CGColor];
    titleBar.layer.shadowOffset = CGSizeMake(0, 3);

    // back button
    UILabel *backButton = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    backButton.font = [UIFont fontWithName:kFontAwesomeFont size:18];
    [backButton setText:[NSString fa_stringForFontAwesomeIcon:FAClose]];
    [backButton setTextColor:[UIColor whiteColor]];
    backButton.userInteractionEnabled = YES;
    UITapGestureRecognizer *tr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    [backButton addGestureRecognizer:tr];

    [titleBar addSubview:backButton];
    [self.view addSubview:titleBar];

    // create a textview from the top bar to the clear button
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    self.textView.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:self.textView];

    // place the clear button so bottom is at self.view.mas_bottom offset -ASKEY_HEIGHT(280)
    AKFullWidthButton *clearButton = [[AKFullWidthButton alloc] initWithText:@"Clear"];
    [clearButton registerHandlers];
    clearButton.layer.backgroundColor = [ASKEY_BLUE_COLOR CGColor];
    [clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearTextView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearButton];

    // hint text
    UILabel *hintText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    hintText.text = @"(click the globe until you see Askey)";
    hintText.textAlignment = NSTextAlignmentCenter;
    hintText.textColor = [ASKEY_BLUE_COLOR colorWithAlphaComponent:0.7];
    [self.view addSubview:hintText];

    // CONSTRAINTS

    [titleBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(self.view);
        make.height.equalTo(@55);
    }];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleBar).offset(10);
        make.top.equalTo(titleBar).offset(25);
    }];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleBar.mas_bottom);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(clearButton.mas_top);
    }];
    [clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textView.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-280);
    }];
    [hintText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(clearButton.mas_bottom).offset(5);
        make.left.and.right.equalTo(self.view);
        make.height.equalTo(@20);
    }];

    [self.textView becomeFirstResponder];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissSelf
{
    [self.textView resignFirstResponder];
    [self.delegate shouldCloseTryAskeyViewController:self];
}

- (void)clearTextView
{
    self.textView.text = @"";
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent; // Set status bar color to white
}

@end






















