//
//  CharacterPackViewController.h
//  ASCIIboardContainer
//
//  Created by Matt Condon on 2/15/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CharacterPackViewController : UIViewController
{
    NSMutableArray *_pack;
}

- (id)initWithCharacterPack:(NSMutableArray *)pack;

@end
