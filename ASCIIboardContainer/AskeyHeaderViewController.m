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
    iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconheader"]];
    title = [[UILabel alloc] init];
    title.text = @"Askey";
    title.font = [UIFont fontWithName:ASKEY_TITLE_FONT size:34];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    [title sizeToFit];

    [self.view addSubview:iconView];
    [self.view addSubview:title];

    float iconSizeLarge = self.view.frame.size.height * 0.44;

    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(self.view.center.x - iconSizeLarge/2.0);
        make.height.equalTo(self.view).multipliedBy(0.44);
        make.width.equalTo(iconView.mas_height);
        make.centerY.equalTo(self.view).offset(-10);
    }];

    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(self.view.frame.size.width/2.0 - title.frame.size.width/2.0);
        make.centerY.equalTo(self.view).offset(45);
    }];

    // @TODO(animate left constraint with JazzHands

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
