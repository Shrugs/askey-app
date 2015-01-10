//
//  AKCardView.m
//  ASCIIboardContainer
//
//  Created by Matt Condon on 1/5/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import "AKCardView.h"
#import "AKFullWidthButton.h"
#import "Config.h"
#import <Masonry/Masonry.h>
#import "UIImage+ASCII.h"
#import "AKCharacterPackManager.h"

#define EDGE_INSET 10
static const CGFloat MAX_FONT_SIZE = 22.0;
static const CGFloat MAIL_FONT_SIZE = 13;

@implementation AKCardView

- (void)setSet:(NSDictionary *)set
{
    _set = set;

    _isHardwrapped = [[_set objectForKey:@"keyName"] isEqualToString:@"mail"];

    [self getASCIIFromSet:_set];

    // CARD
    UIView *card = [[UIView alloc] initWithFrame:self.bounds];
    card.backgroundColor = [UIColor whiteColor];
    card.layer.cornerRadius = 10;
    card.layer.masksToBounds = YES;

    // TITLE
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    titleLabel.font = [UIFont fontWithName:ASKEY_FONT size:30];
    titleLabel.text = [_set objectForKey:@"displayName"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [card addSubview:titleLabel];

    // EXAMPLES
    UILabel *exampleCharLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 100)];
    exampleCharLabel.font = [UIFont fontWithName:ASKEY_FONT size:11];
    exampleCharLabel.textAlignment = NSTextAlignmentCenter;
    exampleCharLabel.numberOfLines = 5;
    NSString *exampleChars = @"";

    for (NSDictionary *pack in [_set objectForKey:@"packs"]) {
        // skip space char by initializing i to 1
        for (int i = 1; i < [[pack objectForKey:@"chars"] count]; i++) {
            // for each key
            for (NSString *c in [[pack objectForKey:@"chars"] objectForKey:[NSString stringWithFormat:@"%i", i]]) {
                exampleChars = [exampleChars stringByAppendingString:c];
            }
            exampleChars = [exampleChars stringByAppendingString:@" "];
        }
    }

    exampleCharLabel.text = exampleChars;
    exampleCharLabel.adjustsFontSizeToFitWidth = YES;
    [card addSubview:exampleCharLabel];

    // TITLE SEPARATOR
    UIView *titleSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, card.frame.size.width, 0)];
    titleSeparator.backgroundColor = ASKEY_BLUE_COLOR;
    titleSeparator.clipsToBounds = YES;
    [card addSubview:titleSeparator];

    // TEXT VIEW
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, card.frame.size.width, 100)];
    _textView.editable = NO;
    _textView.font = [UIFont fontWithName:ASKEY_FONT size:(_isHardwrapped ? MAIL_FONT_SIZE : MAX_FONT_SIZE)];
    _textView.delegate = self;
    [card addSubview:_textView];

    // BUY BUTTON
    AKFullWidthButton *buyButton;
    if ([[_set objectForKey:@"purchased"] boolValue]) {
        buyButton = [[AKFullWidthButton alloc] initWithText:[NSString stringWithFormat:@"Yay, you own %@", [_set objectForKey:@"displayName"]]];
        buyButton.enabled = NO;
    } else {
        // offer purchase button
        buyButton = [[AKFullWidthButton alloc] initWithText:[NSString stringWithFormat:@"Buy %@ for $.99", [_set objectForKey:@"displayName"]]];
        [buyButton addTarget:self action:@selector(buySet) forControlEvents:UIControlEventTouchUpInside];
    }
    buyButton.backgroundColor = ASKEY_BLUE_COLOR;
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyButton.layer.shadowColor = [[UIColor clearColor] CGColor];
    [buyButton registerHandlers];
    [card addSubview:buyButton];

    [self addSubview:card];

    // CONSTRAINTS
    [card mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(card).offset(EDGE_INSET);
        make.left.equalTo(card).offset(EDGE_INSET);
        make.right.equalTo(card).offset(-EDGE_INSET);
    }];
    [exampleCharLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(EDGE_INSET);
        make.left.equalTo(card).offset(EDGE_INSET);
        make.right.equalTo(card).offset(-EDGE_INSET);
    }];
    [titleSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(exampleCharLabel.mas_bottom).offset(EDGE_INSET);
        make.left.equalTo(card).offset(EDGE_INSET);
        make.right.equalTo(card).offset(-EDGE_INSET);
        make.height.equalTo(@1);

    }];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleSeparator.mas_bottom);
        make.left.equalTo(card).offset(EDGE_INSET);
        make.right.equalTo(card).offset(-EDGE_INSET);
        make.bottom.equalTo(buyButton.mas_top).offset(-EDGE_INSET);
    }];
    [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(card);
        make.bottom.equalTo(card).offset(-EDGE_INSET);
        make.height.equalTo(@50);
    }];

    // RESIZE TEXT VIEW
    CGRect _f = _textView.frame;
    _f.size.height = _textView.contentSize.height;
    _textView.frame = _f;

}

- (void)buySet
{
    [[AKCharacterPackManager sharedManager] setCharacterSetEnabled:[_set objectForKey:@"keyName"]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Awesome!" message:@"For the beta, pressing the button gets you the character set!" delegate:self cancelButtonTitle:@"Sweet!" otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shouldHideCardView:)]) {
        [self.delegate shouldHideCardView:self];
    }
}

- (void)getASCIIFromSet:(NSDictionary *)set
{
    dispatch_queue_t asciiQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_async(asciiQueue, ^{
        NSString *text = @"";

        for (NSDictionary *pack in [_set objectForKey:@"packs"]) {
            NSString *temp = [[UIImage imageNamed:@"example_template"] getASCIIWithResolution:CGSizeMake([[pack objectForKey:@"width"] integerValue],
                                                                                                         [[pack objectForKey:@"height"] integerValue])
                                                                                     andChars:[pack objectForKey:@"chars"]
                                                                             andIsHardwrapped:_isHardwrapped];

            text = [text stringByAppendingString:temp];
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI incrementally
                [_textView setText:text];
            });
        }
    });
}

@end

















