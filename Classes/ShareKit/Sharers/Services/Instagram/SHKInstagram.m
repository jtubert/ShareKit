//
//  SHKInstagram.m
//  ShareKit
//
//  Created by John Tubert on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SHKInstagram.h"

@implementation SHKInstagram

#pragma mark -
#pragma mark Configuration : Service Defination

+ (NSString *)sharerTitle
{
	return @"Instagram";
}

+ (BOOL)canShareImage
{
	return YES;
}

- (BOOL)isAuthorized 
{
	return YES;
}

-(void) saveToInstagram {    
    CGRect rect = CGRectMake(0, 0, 0, 0);
    NSURL *url;
    UIDocumentInteractionController *dic;
    UIImage *i = [item image];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.igo"];
    UIImage *img=[self scaleProportionalToSize:CGSizeMake(612, 612) withImage:i];
    [UIImageJPEGRepresentation(img, 1.0) writeToFile:jpgPath atomically:YES];
    url = [[NSURL alloc] initFileURLWithPath:jpgPath];    
    
    
    dic = [self setupControllerWithURL:url usingDelegate:self];
    dic.annotation = [NSDictionary dictionaryWithObject:[item title] forKey:@"InstagramCaption"];    
    dic.UTI = @"com.instagram.exclusivegram";
    
    [dic retain];
    [dic presentOpenInMenuFromRect:rect inView:self.view animated:YES];
    
    
    [url release];
     
}

- (UIImage *) scaleToSize: (CGSize)size  withImage:(UIImage*)img
{
    // Scalling selected image to targeted size
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));
    
    if(img.imageOrientation == UIImageOrientationRight)
    {
        CGContextRotateCTM(context, -M_PI_2);
        CGContextTranslateCTM(context, -size.height, 0.0f);
        CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), img.CGImage);
    }
    else
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), img.CGImage);
    
    CGImageRef scaledImage=CGBitmapContextCreateImage(context);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    UIImage *image = [UIImage imageWithCGImage: scaledImage];
    
    CGImageRelease(scaledImage);
    
    return image;
}

- (UIImage *) scaleProportionalToSize: (CGSize)size1 withImage:(UIImage*)img
{
    if(img.size.width>img.size.height)
    {
        NSLog(@"LandScape");
        size1=CGSizeMake((img.size.width/img.size.height)*size1.height,size1.height);
    }
    else
    {
        NSLog(@"Potrait");
        size1=CGSizeMake(size1.width,(img.size.height/img.size.width)*size1.width);
    }
    
    return [self scaleToSize:size1 withImage:img];
}

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    
    NSLog(@"setupControllerWithURL");
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    
    return interactionController;
}

- (void)documentInteractionControllerWillPresentOpenInMenu:(UIDocumentInteractionController *)controller {
    NSLog(@"documentInteractionControllerWillPresentOpenInMenu");
}

#pragma mark -
#pragma mark Share API Methods

- (BOOL)send
{	
    [self saveToInstagram];
    return YES;
}

@end
