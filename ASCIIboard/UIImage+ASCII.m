//
//  UIImage+ASCII.m
//  AsciiAlgo
//
//  Created by Matt Condon on 9/20/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import "UIImage+ASCII.h"

@implementation UIImage (ASCII)


- (NSString *)getASCIIWithResolution:(CGSize)numBlocks andChars:(NSDictionary *)alphaChars
{

    // numBlocks = number of ASCII "pixels" in widthxheight

    CGImageRef imageRef = [self CGImage];
    CGSize picSize;
    picSize.width = CGImageGetWidth(imageRef);
    picSize.height = CGImageGetHeight(imageRef);


    // actual pixels in a block (AKA "pixel")
    CGSize blockSize = CGSizeMake(floor(picSize.width/numBlocks.width), floor(picSize.height/numBlocks.height));

    // maxiumum alpha value a block can have
    float maxAlpha = blockSize.width * blockSize.height * 1.0;


    NSArray *rawPixels = [UIImage getAlphaFromImage:self atX:0 andY:0 count:picSize.width*picSize.height];
    NSMutableArray *pixels = [NSMutableArray arrayWithCapacity:picSize.height];
    for (int h=0; h<picSize.height; h++) {
        // for each row, create an array
        NSMutableArray *rowPixels = [[NSMutableArray alloc] initWithCapacity:picSize.width];
        for (int w=0; w<picSize.width; w++) {
            [rowPixels addObject:[rawPixels objectAtIndex:h*picSize.width + w]];
        }
        [pixels addObject:rowPixels];
    }

    // 0 0 0 0 0 1 1 1 1 1 1 0 0 0 0
    // 0 0 0 0 1 1 1 0 0 0 1 1 1 0 0
    // 0 0 0 1 1 0 0 0 0 0 0 1 1 1 0
    // etc

    // 0 0 0 0    0 0 0 0
    // 0 0 0 0    0 1 1 0
    // 0 0 0 1    1 0 1 1
    // 0 0 1 1    0 0 1 1
    // 0 1 1 0    0 0 0 1

    // 0 1 1 0    0 0 1 1
    // 0 1 1 0    0 0 1 1
    // 0 0 1 1    1 1 1 0
    // 0 0 0 0    1 0 0 0
    // 0 0 0 0    0 0 0 0

    // now split the pixels 2 dimensional array into another two dimentional array based on blockSize

    // this will be an array
    NSMutableArray *blocks = [NSMutableArray arrayWithCapacity:numBlocks.height];

    for (int row=0; row < numBlocks.height; row++) {
        // for every blockHeight rows
        // create a blockRow
        NSMutableArray *blockRow = [NSMutableArray arrayWithCapacity:numBlocks.width];

        for (int col=0; col < numBlocks.width; col++) {
            // for every blockWidth columns

            // create a block array and then for each pixel in the block, add it to an array and add that to block
            NSMutableArray *block = [NSMutableArray arrayWithCapacity:blockSize.height];

            for (int h=0; h < blockSize.height; h++) {
                // for each row of pixels in this block
                // access with row * blockSize.height + h
                NSMutableArray *blockPixelRow = [NSMutableArray arrayWithCapacity:blockSize.width];
                for (int w=0; w < blockSize.width; w++) {
                    // for each pixel in this block,
                    // access with col * blockSize.width + w
                    UIColor *thisPixel = [[pixels objectAtIndex:(row * blockSize.height + w)] objectAtIndex:(col * blockSize.width + w)];
                    [blockPixelRow addObject:thisPixel];
                }
                [block addObject:blockPixelRow];
            }

            [blockRow addObject:block];
        }
        [blocks addObject:blockRow];
    }

    // NSLog(@"blocks.height: %lu", (unsigned long)[blocks count]);
    // NSLog(@"blocks.width: %lu", (unsigned long)[[blocks objectAtIndex:0] count]);
    NSString *finalString = @"";

    for (int h=0; h < numBlocks.height; h++) {
        // for each block row
        for (int w=0; w < numBlocks.width; w++) {
            // for each block in that row
            // compute darkness
            NSMutableArray *thisBlock = [[blocks objectAtIndex:h] objectAtIndex:w];
            // NSLog(@"%@", thisBlock);
            float totalAlpha = 0;
            for (int i=0; i < blockSize.height; i++) {
                for (int j=0; j < blockSize.width; j++) {
                    totalAlpha += [[[thisBlock objectAtIndex:i] objectAtIndex:j] floatValue];
                }
            }

            // convert to [0 .. 9] value
            int relativeAlpha = floor((totalAlpha/maxAlpha) * ([alphaChars count] - 1));
            NSArray *possibleChars = [alphaChars objectForKey:[NSString stringWithFormat:@"%i", relativeAlpha]];
            NSUInteger myCount = [possibleChars count];
            finalString = [finalString stringByAppendingString:[possibleChars objectAtIndex:arc4random_uniform((u_int32_t)myCount)]];

        }
        finalString = [finalString stringByAppendingString:@"\n"];
    }
    return finalString;
}

+ (NSArray*)getAlphaFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(int)count
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];

    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);

    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);

    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = (int)((bytesPerRow * yy) + xx * bytesPerPixel);
    for (int ii = 0 ; ii < count ; ++ii)
    {
        // CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
        // CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
        // CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
        byteIndex += 4;

        // UIColor *acolor = [UIColor colorWithRed:0 green:0 blue:0 alpha:alpha];
        [result addObject:[NSNumber numberWithFloat:alpha]];
    }

    free(rawData);

    return result;
}
@end
