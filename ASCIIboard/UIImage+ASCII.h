//
//  UIImage+ASCII.h
//  AsciiAlgo
//
//  Created by Matt Condon on 9/20/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ASCII)

- (NSString *)getASCIIWithResolution:(CGSize)numBlocks;

@end
