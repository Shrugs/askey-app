//
//  ViewController.m
//  ASCIIboardContainer
//
//  Created by Matt Condon on 9/22/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import <MCBouncyButton/MCBouncyButton.h>
#import <Crashlytics/Crashlytics.h>
#import "Flurry.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view removeConstraints:self.view.constraints];
    [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(50);
        make.right.equalTo(self.view).offset(-50);
        make.top.equalTo(self.view).offset(50);
    }];
    [self.moreText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(50);
        make.right.equalTo(self.view).offset(-50);
        make.top.equalTo(self.text.mas_bottom).offset(50);
    }];

    MCBouncyButton *myButton = [[MCBouncyButton alloc] initWithText:@"yo" andRadius:50];
    [self.view addSubview:myButton];
    [myButton setStyle:MCBouncyButtonStyleSelected animated:YES];
    [myButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(@(100));
        make.center.equalTo(self.view);
    }];
    CLSLog(@"LOGGING STUFF");
    [myButton addTarget:[Crashlytics sharedInstance] action:@selector(crash) forControlEvents:UIControlEventTouchUpInside];


    [Flurry logEvent:@"APP_OPENED"];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
