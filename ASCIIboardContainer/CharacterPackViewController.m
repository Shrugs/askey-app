//
//  CharacterPackViewController.m
//  ASCIIboardContainer
//
//  Created by Matt Condon on 2/15/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import "CharacterPackViewController.h"
#import "Config.h"

@interface CharacterPackViewController ()

@end

@implementation CharacterPackViewController

- (id)initWithCharacterPack:(NSMutableArray *)pack {
    self = [super init];
    if (self) {
        _pack = pack;

        self.view.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)viewDidAppear:(BOOL)animated
{
    CGRect f = self.view.frame;
    f.size.height = f.size.height - 60;
    f.origin.y = 60;
    self.view.frame = f;
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
