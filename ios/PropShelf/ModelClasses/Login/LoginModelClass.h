//
//  LoginModelClass.h
//  PropShelf
//
//  Created by Gaurang Patel on 10/23/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginModelClassDelegate <NSObject>

-(void)didLoginSuccessfully:(NSMutableDictionary *)responseDict;
-(void)didLoginFailed:(ASIHTTPRequest *)therequest;

-(void)didOTPVerifiedSuccessfully;
-(void)didOTPVerifiedFailed:(ASIHTTPRequest *)therequest;

-(void)didResendOTPSuccessfully:(NSString *)message;
-(void)didResendOTPFailed:(ASIHTTPRequest *)therequest;

@end

@interface LoginModelClass : NSObject

@property (nonatomic,strong) id<LoginModelClassDelegate>delegate;
@property (nonatomic,strong) ASINetworkQueue *nsqueue;

-(void)loginRequest:(NSMutableDictionary *)dict;
-(void)verifyOTPRequest:(NSMutableDictionary *)dict;
-(void)resendOTPRequest:(NSMutableDictionary *)dict;

@end
