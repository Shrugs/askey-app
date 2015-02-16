//
//  AskeyHeaderViewController.m
//  ASCIIboardContainer
//
//  Created by Matt Condon on 2/15/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import "AskeyHeaderViewController.h"
#import "Config.h"
#import <Masonry/Masonry.h>

@interface AskeyHeaderViewController ()

@end

@implementation AskeyHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CGRect f = self.view.frame;
    f.size.height = 160;
    self.view.frame = f;

    self.view.backgroundColor = ASKEY_BLUE_COLOR;
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconheader"]];
    UILabel *title = [[UILabel alloc] init];
    title.text = @"Askey";
    title.font = [UIFont fontWithName:ASKEY_TITLE_FONT size:34];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];

    [self.view addSubview:iconView];
    [self.view addSubview:title];

    iconView.frame = CGRectMake(0,
                                20 + 14,
                                self.view.frame.size.height * 0.44,
                                self.view.frame.size.height * 0.44);
    iconView.center = CGPointMake(self.view.center.x, iconView.center.y);


    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconView.mas_bottom).offset(3);
        make.left.and.right.equalTo(self.view);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
