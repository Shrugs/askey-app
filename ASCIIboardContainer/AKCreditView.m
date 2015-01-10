//
//  AKCreditView.m
//  ASCIIboardContainer
//
//  Created by Matt Condon on 1/8/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import "AKCreditView.h"
#import <MCBouncyButton/MCBouncyButton.h>
#import <POP.h>
#import <Masonry/Masonry.h>

#define EDGE_OFFSET 20

@implementation AKCreditView

- (id)initWithFrame:(CGRect)frame text:(NSString *)text twitter:(NSString *)twitter andWeb:(NSString *)web
{
    self = [super initWithFrame:frame];
    if (self) {

        _twitter = twitter;
        _web = web;

        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        textLabel.textAlignment = NSTextAlignmentCenter;
        [textLabel setText:text];
        [textLabel setTextColor:[UIColor whiteColor]];
        [textLabel setFont:[UIFont systemFontOfSize:22]];
        [self addSubview:textLabel];

        MCBouncyButton *twitterLink = [[MCBouncyButton alloc] initWithImage:[UIImage imageNamed:@"twitter"] andRadius:frame.size.height*0.8/2];
        [twitterLink addTarget:self action:@selector(launchTwitter) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:twitterLink];

        MCBouncyButton *webLink = [[MCBouncyButton alloc] initWithImage:[UIImage imageNamed:@"globe"] andRadius:frame.size.height*0.8/2];
        [webLink addTarget:self action:@selector(launchWeb) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:webLink];

        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(EDGE_OFFSET);
            make.top.and.bottom.equalTo(self);
            make.right.equalTo(twitterLink.mas_left);
        }];
        [twitterLink mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(webLink.mas_left).offset(-EDGE_OFFSET);
            make.width.and.height.equalTo(self.mas_height).multipliedBy(0.8);
        }];
        [webLink mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-EDGE_OFFSET);
            make.width.and.height.equalTo(self.mas_height).multipliedBy(0.8);
        }];

    }
    return self;
}

- (void)launchTwitter
{
    // twitter://user?screen_name=%@
    // tweetbot://%@/timeline
    // twitterrific:///profile?screen_name=%@
    // https://twitter.com/%@

    NSArray *urls = @[@"tweetbot://%@/timeline",
                      @"twitterrific:///profile?screen_name=%@",
                      @"twitter://user?screen_name=%@",
                      @"https://twitter.com/%@"
                      ];


    for (NSString *url in urls) {
        NSString *furl = [[NSString alloc] initWithFormat:url, _twitter];
        NSLog(@"%@", furl);
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

- (void)launchWeb
{
    [self launchURL:_web];
}

- (void)launchURL:(NSString *)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
