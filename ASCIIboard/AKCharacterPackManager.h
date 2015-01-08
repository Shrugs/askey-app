//
//  AKCharacterPackManager.h
//  ASCIIboardContainer
//
//  Created by Matt Condon on 12/31/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKConfig.h"

@interface AKCharacterPackManager : NSObject

+ (id)sharedManager;
- (NSMutableArray *)characterSets;
- (BOOL)setCharacterSetEnabled:(NSString *)set; // called after user buys a set

@end
