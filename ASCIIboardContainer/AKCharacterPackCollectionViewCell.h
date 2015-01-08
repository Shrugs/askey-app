//
//  AKCharacterPackCollectionViewCell.h
//  ASCIIboardContainer
//
//  Created by Matt Condon on 1/3/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKCharacterPackCollectionViewCell : UICollectionViewCell
{
    UILabel *textLabel;
    BOOL touchDown;
    UILabel *priceLabel;
}

- (void)setSet:(NSDictionary *)set;

@end
