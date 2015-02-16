//
//  CharacterPackButton.h
//  ASCIIboardContainer
//
//  Created by Matt Condon on 2/15/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import "MCBouncyButton.h"

@interface CharacterPackButton : MCBouncyButton

- (id)initWithText:(NSString *)text andBackground:(NSString *)image purchased:(BOOL)purchased;
- (void)setPurchased:(BOOL)purchased;

@end
