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

#define EDGE_INSET 10

@implementation AKCardView

- (void)setPack:(NSDictionary *)pack
{
    _pack = pack;

    [self getASCIIFromPack:_pack];

    // CARD
    UIView *card = [[UIView alloc] initWithFrame:self.bounds];
    card.backgroundColor = [UIColor whiteColor];
    card.layer.cornerRadius = 10;
    card.layer.masksToBounds = YES;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    titleLabel.font = [UIFont fontWithName:ASKEY_FONT size:30];
    titleLabel.text = [_pack objectForKey:@"displayName"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [card addSubview:titleLabel];
    // configure images and example text

    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, card.frame.size.width, 100)];
    _textView.editable = NO;
    _textView.font = [UIFont fontWithName:ASKEY_FONT size:14];
    [card addSubview:_textView];

    AKFullWidthButton *buyButton;
    if ([[pack objectForKey:@"enabled"] boolValue]) {
        buyButton = [[AKFullWidthButton alloc] initWithText:[NSString stringWithFormat:@"Yay, you own %@", [pack objectForKey:@"displayName"]]];
        buyButton.enabled = NO;
    } else {
        // offer purchase button
        buyButton = [[AKFullWidthButton alloc] initWithText:@"Buy"];
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
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(card).offset(EDGE_INSET);
        make.right.equalTo(card).offset(-EDGE_INSET);
        make.top.equalTo(titleLabel.mas_bottom);
        make.bottom.equalTo(buyButton.mas_top).offset(-EDGE_INSET);
    }];
    [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(card);
        make.bottom.equalTo(card).offset(-EDGE_INSET);
        make.height.equalTo(@50);
    }];
}

- (void)getASCIIFromPack:(NSDictionary *)pack
{
    dispatch_queue_t asciiQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_async(asciiQueue, ^{
        NSString *text = [[UIImage imageNamed:@"example_template"] getASCIIWithResolution:CGSizeMake([[pack objectForKey:@"width"] integerValue],
                                                                                                [[pack objectForKey:@"height"] integerValue])
                                                                            andChars:[_pack objectForKey:@"chars"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [_textView setText:text];
        });
    });
}

@end
