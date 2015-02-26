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
    NSArray *_packs;
    UIScrollView *_scrollView;
    UIScrollView *_textViewScrollView;
    NSMutableArray *_textViews;
    BOOL _isPurchased;
    NSString *_keyName;
}

- (id)initWithCharacterPacks:(NSArray *)packs andPurchased:(BOOL)purchased;

@end
