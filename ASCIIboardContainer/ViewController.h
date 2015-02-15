//
//  ViewController.h
//  ASCIIboardContainer
//
//  Created by Matt Condon on 9/22/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKIntroViewController.h"

@interface ViewController : UIViewController
{
    UICollectionView *_characterSetButtons;
    NSMutableArray *_characterSets;
}

@property (nonatomic, retain) AKIntroViewController *introVC;

@end

