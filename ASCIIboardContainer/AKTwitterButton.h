//
//  AKTwitterButton.h
//  ASCIIboardContainer
//
//  Created by Matt Condon on 2/15/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#import "MCGenericBouncyButton.h"

@interface AKTwitterButton : MCGenericBouncyButton
{
    NSString *_twitter;
}

- (id)initWithText:(NSString *)text username:(NSString *)username andPic:(NSString *)pic;

@end
