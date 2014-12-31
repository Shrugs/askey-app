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

@property (nonatomic, retain) NSArray *characterPacks;

+ (id)sharedManager;
- (void)refreshCharacterPacks; // refreshed character packs from disk
- (BOOL)setCharacterPackEnabled:(NSString *)pack; // called after user buys a pack

@end
