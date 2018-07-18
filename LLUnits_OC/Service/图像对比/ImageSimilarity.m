//
//  ImageSimilarity.m
//  LLUnits_OC
//
//  Created by mac on 2018/7/6.
//  Copyright © 2018年 luoliu. All rights reserved.
//

#import "ImageSimilarity.h"

@implementation ImageSimilarity

+ (BOOL)isSimilarityValueWithImgA:(UIImage *)imgA imgB:(UIImage *)imgB {
    if (imgA == nil || imgB == nil) {
        return NO;
    }
    
    return [ImageSimilarity getSimilarityValueWithImgA:imgA ImgB:imgB];
}

+ (BOOL)isSimilarityValueWithHashA:(NSString *)hashA hashB:(NSString *)hashB {
    if (hashA == nil || hashB == nil) {
        return NO;
    }
    
    NSUInteger sameCount = 0;
    NSUInteger length = MIN(hashA.length, hashB.length);
    for (int i = 0; i < length; i++) {
        char charA = [hashA characterAtIndex:i];
        char charB = [hashB characterAtIndex:i];
        if (charA == charB) {
            sameCount += 1;
        }
    }
    
    return (length-sameCount) <= 5;
}

+ (BOOL)getSimilarityValueWithImgA:(UIImage*)imgA ImgB:(UIImage*)imgB {
    NSString *hashA = [ImageSimilarity getHashValue:imgA];
    NSString *hashB = [ImageSimilarity getHashValue:imgB];
    
    return [ImageSimilarity isSimilarityValueWithHashA:hashA hashB:hashB];
}

#pragma mark - 图片对比计算

+ (NSString *)getHashValue:(UIImage *)image {
    ImageSimilarity *similarity = [[ImageSimilarity alloc] init];
    
    UIImage *scaleImg = [similarity originImage:image scaleToSize:CGSizeMake(8, 8)];
    UIImage *img = [similarity getGrayImage:scaleImg];
    
    unsigned char* pixelData = [similarity grayscalePixels:img];
    
    int total = 0;
    int ave = 0;
    for (int i = 0; i < img.size.height; i++) {
        for (int j = 0; j < img.size.width; j++) {
            total += (int)pixelData[(i*((int)img.size.width))+j];
        }
    }
    ave = total/64;
    NSMutableString *result = [[NSMutableString alloc] init];
    for (int i = 0; i < img.size.height; i++) {
        for (int j = 0; j < img.size.width; j++) {
            int a = (int)pixelData[(i*((int)img.size.width))+j];
            if(a >= ave) {
                [result appendString:@"1"];
            }
            else {
                [result appendString:@"0"];
            }
        }
    }
    return result;
}

- (UIImage *)originImage:(UIImage *)image scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;   //返回的就是已经改变的图片
}

- (UIImage *)getGrayImage:(UIImage *)sourceImage {
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

- (unsigned char *)grayscalePixels:(UIImage *)image {
    // The amount of bits per pixel, in this case we are doing grayscale so 1 byte = 8 bits
#define BITS_PER_PIXEL 8
    // The amount of bits per component, in this it is the same as the bitsPerPixel because only 1 byte represents a pixel
#define BITS_PER_COMPONENT (BITS_PER_PIXEL)
    // The amount of bytes per pixel, not really sure why it asks for this as well but it's basically the bitsPerPixel divided by the bits per component (making 1 in this case)
#define BYTES_PER_PIXEL (BITS_PER_PIXEL/BITS_PER_COMPONENT)
    
    // Define the colour space (in this case it's gray)
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceGray();
    
    // Find out the number of bytes per row (it's just the width times the number of bytes per pixel)
    size_t bytesPerRow = image.size.width * BYTES_PER_PIXEL;
    // Allocate the appropriate amount of memory to hold the bitmap context
    unsigned char* bitmapData = (unsigned char*) malloc(bytesPerRow*image.size.height);
    
    // Create the bitmap context, we set the alpha to none here to tell the bitmap we don't care about alpha values
    CGContextRef context = CGBitmapContextCreate(bitmapData,image.size.width,image.size.height,BITS_PER_COMPONENT,bytesPerRow,colourSpace,kCGImageAlphaNone);
    
    // We are done with the colour space now so no point in keeping it around
    CGColorSpaceRelease(colourSpace);
    
    // Create a CGRect to define the amount of pixels we want
    CGRect rect = CGRectMake(0.0,0.0,image.size.width,image.size.height);
    // Draw the bitmap context using the rectangle we just created as a bounds and the Core Graphics Image as the image source
    CGContextDrawImage(context,rect,image.CGImage);
    // Obtain the pixel data from the bitmap context
    unsigned char* pixelData = (unsigned char*)CGBitmapContextGetData(context);
    
    // Release the bitmap context because we are done using it
    CGContextRelease(context);
    
    return pixelData;
#undef BITS_PER_PIXEL
#undef BITS_PER_COMPONENT
}

@end
