//
//  AKTwitterButton.m
//  ASCIIboardContainer
//
//  Created by Matt Condon on 2/15/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import "AKTwitterButton.h"
#import "Config.h"
#import <Masonry/Masonry.h>
#import "Flurry.h"

@implementation AKTwitterButton

- (id)initWithText:(NSString *)text username:(NSString *)username andPic:(NSString *)pic
{
    self = [[self class] buttonWithType:UIButtonTypeCustom];
    if (self) {

        _twitter = username;

        UIImageView *picView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:pic]];
        [self addSubview:picView];

        self.layer.backgroundColor = [ASKEY_BUTTON_BODY_COLOR CGColor];
        [self setTitle:text forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont fontWithName:ASKEY_BUTTON_FONT size:20.0];
        [self setTitleColor:ASKEY_BLUE_COLOR forState:UIControlStateNormal];

        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;

        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];

        [picView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(5);
            make.centerY.equalTo(self);
            make.height.equalTo(self).multipliedBy(0.85);
            make.width.equalTo(picView.mas_height);
        }];

        [self addTarget:self action:@selector(launchTwitter) forControlEvents:UIControlEventTouchUpInside];
        [self registerHandlers];
    }
    return self;
}


- (void)launchTwitter
{
    // twitter://user?screen_name=%@
    // tweetbot://%@/timeline
    // twitterrific:///profile?screen_name=%@
    // https://twitter.com/%@

    NSArray *urls = @[
                      @"twitterrific:///profile?screen_name=%@",
                      @"twitter://user?screen_name=%@",
                      @"https://twitter.com/%@"
                      ];


    for (NSString *url in urls) {
        NSString *furl = [[NSString alloc] initWithFormat:url, _twitter];
        if ([self canLaunchURL:furl]) {
            [self launchURL:furl];
            return;
        }
    }

}

- (BOOL)canLaunchURL:(NSString *)url
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
}

- (void)launchURL:(NSString *)url
{

    [Flurry logEvent:@"TWITTER_BUTTON_CLICKED" withParameters:@{@"person": _twitter}];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
