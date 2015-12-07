//
//  Common.m
//  PropShelf
//
//  Created by Gaurang on 10/23/15.
//  Copyright (c) 2013 vWeet. All rights reserved.
//

#import "Common.h"
#import <QuartzCore/QuartzCore.h>
#import <CommonCrypto/CommonDigest.h>
#import <ImageIO/ImageIO.h>

@implementation Common

+ (NSData *)resizeImageData:(UIImage *)image
{
    /*NSData* imgData = UIImageJPEGRepresentation(image, 1.0);
     NSLog(@"Original size image in KB: %d",[imgData length]/1024);*/
    
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 600.0;
    float maxWidth = 800.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    //NSLog(@"Resize size image in KB: %d",[imageData length]/1024);
    
    return imageData;
}

#pragma mark - Resize Image Method

+ (UIImage *)resizeImage:(UIImage *)image
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 600.0;
    float maxWidth = 800.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:imageData];
}

#pragma mark - Save , Retrive & Delete Logged in User Info

+(void)saveLoggedInUserInfoFromDictionary:(NSDictionary*)userInfo
{
    NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
    [userDefaults1 setObject:userInfo forKey:ADMIN_DETAILS];
    [userDefaults1 synchronize];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sessionDictionary = [userInfo objectForKey:@"session"];
    [userDefaults setObject:[sessionDictionary objectForKey:@"id"] forKey:APP_SESSION_ID];
    [userDefaults setObject:[sessionDictionary objectForKey:@"lastAccessTime"] forKey:LAST_ACCESS_TIME];
    [userDefaults setObject:[sessionDictionary objectForKey:@"userId"] forKey:LOGGED_IN_USER_ID];
}

+(NSDictionary*)retriveLoggedInUserInfo {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:ADMIN_DETAILS];
}

+(NSString*)getCurrentSessionId {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sessionId = [userDefaults objectForKey:APP_SESSION_ID];
    
    return sessionId;
}

+(NSString*)getThreadId:(NSString *)loggendInUserId selectedUserId:(NSString *)userId {
    
    NSString *threadId = @"";

    if ([loggendInUserId intValue] < [userId intValue]) {
        
        threadId = [NSString stringWithFormat:@"user_%@_%@", loggendInUserId, userId];
    }
    else {
     
        threadId = [NSString stringWithFormat:@"user_%@_%@", userId, loggendInUserId];
    }
    
    return threadId;
}

#pragma mark -  show Alert

+ (void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)msg {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    [alert show];
    alert = nil;
}

+(void)showAlertWithOK:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    [alert show];
    alert = nil;
}

@end
