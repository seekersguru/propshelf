//
//  Common.h
//  PropShelf
//
//  Created by Gaurang on 10/23/15.
//  Copyright (c) 2013 vWeet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

+ (NSData *)resizeImageData:(UIImage *)image;
+ (UIImage *)resizeImage:(UIImage *)image;
+ (void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)msg;
+(void)showAlertWithOK:(NSString*)message;

+(void)saveLoggedInUserInfoFromDictionary:(NSDictionary*)userInfo;
+(NSString*)getCurrentSessionId;
+(NSDictionary*)retriveLoggedInUserInfo;

@end
