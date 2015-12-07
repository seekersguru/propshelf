//
//  LoginModelClass.m
//  PropShelf
//
//  Created by Gaurang Patel on 10/23/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import "LoginModelClass.h"

@implementation LoginModelClass

@synthesize nsqueue;

@synthesize delegate;

#pragma mark - Login Request

-(void)loginRequest:(NSMutableDictionary *)dict {
    
    if (self.nsqueue == nil) {
        self.nsqueue = [[ASINetworkQueue alloc] init];
    }
    
    NSURL *loginUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PRODUCTION_BASE_URL, Create_User_URL]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:loginUrl];
    [request setDelegate:self];
    [request setRequestMethod:POST];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSString *postString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"Create User Post String:- %@", postString);
    NSLog(@"Create User URL :- %@", loginUrl);
    
    [request appendPostData:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setDidFinishSelector:@selector(didFinishWithLoginRequest:)];
    [request setDidFailSelector:@selector(didFailWithLoginRequest:)];
    
    [self.nsqueue addOperation:request];
    [self.nsqueue go];
}

#pragma mark - Login Request Delegate Method

-(void)didFinishWithLoginRequest:(ASIHTTPRequest *)request
{
    NSLog(@"Create User Status Code:- %d",request.responseStatusCode);
    NSLog(@"Create User response :- %@",request.responseString);
    
    NSError *error = [request error];
    
    if ((request.responseStatusCode >= 200 && request.responseStatusCode <= 210) && !error)
    {
        NSMutableDictionary *responseDict = [NSJSONSerialization
                                         JSONObjectWithData:request.responseData //1
                                         
                                         options:kNilOptions
                                         error:&error];
        
        if (responseDict != nil) {
            
            [delegate didLoginSuccessfully:responseDict];
        }
    }
    else {
        
        [delegate didLoginFailed:request];
    }
}

-(void)didFailWithLoginRequest:(ASIHTTPRequest *)request
{
    [delegate didLoginFailed:request];
    
    NSLog(@"In ::Error:- %@",request.error.description);
}

#pragma mark - Verify OTP Request

-(void)verifyOTPRequest:(NSMutableDictionary *)dict {
    
    if (self.nsqueue == nil) {
        self.nsqueue = [[ASINetworkQueue alloc] init];
    }
    
    NSURL *verifyOTPUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PRODUCTION_BASE_URL, VerifyOTP_URL]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:verifyOTPUrl];
    [request setDelegate:self];
    [request setRequestMethod:POST];
    //[request addRequestHeader:CONTENT_TYPE_FIELD value:CONTENT_TYPE_JSON_VALUE];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSString *postString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"VerifyOTP Post String:- %@", postString);
    NSLog(@"VerifyOTP URL :- %@", verifyOTPUrl);
    
    [request appendPostData:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setDidFinishSelector:@selector(didFinishWithVerifyOTPRequest:)];
    [request setDidFailSelector:@selector(didFailWithVerifyOTPRequest:)];
    
    [self.nsqueue addOperation:request];
    [self.nsqueue go];
}

#pragma mark - Verify OTP Request Delegate Method

-(void)didFinishWithVerifyOTPRequest:(ASIHTTPRequest *)request
{
    NSLog(@"VerifyOTP Status Code:- %d",request.responseStatusCode);
    NSLog(@"VerifyOTP response :- %@",request.responseString);
    
    NSError *error = [request error];
    
    if ((request.responseStatusCode >= 200 && request.responseStatusCode <= 210) && !error)
    {
        NSMutableDictionary *responseDict = [NSJSONSerialization
                                             JSONObjectWithData:request.responseData //1
                                             
                                             options:kNilOptions
                                             error:&error];
        
        if (responseDict != nil) {
            
            [Common saveLoggedInUserInfoFromDictionary:responseDict];
            
            [delegate didOTPVerifiedSuccessfully];
        }
    }
    else {
        
        [delegate didOTPVerifiedFailed:request];
    }
}

-(void)didFailWithVerifyOTPRequest:(ASIHTTPRequest *)request
{
    [delegate didOTPVerifiedFailed:request];
    
    NSLog(@"In ::Error:- %@",request.error.description);
}

#pragma mark - Resend OTP Request

-(void)resendOTPRequest:(NSMutableDictionary *)dict {
    
    if (self.nsqueue == nil) {
        self.nsqueue = [[ASINetworkQueue alloc] init];
    }
    
    NSURL *resendOTPUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PRODUCTION_BASE_URL, ResendOTP_URL]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:resendOTPUrl];
    [request setDelegate:self];
    [request setRequestMethod:POST];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSString *postString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"Resend OTP Post String:- %@", postString);
    NSLog(@"Resend OTP URL :- %@", resendOTPUrl);
    
    [request appendPostData:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setDidFinishSelector:@selector(didFinishWithResendOTPRequest:)];
    [request setDidFailSelector:@selector(didFailWithResendOTPRequest:)];
    
    [self.nsqueue addOperation:request];
    [self.nsqueue go];
}

#pragma mark - Resend OTP Request Delegate Method

-(void)didFinishWithResendOTPRequest:(ASIHTTPRequest *)request
{
    NSLog(@"Resend OTP Status Code:- %d",request.responseStatusCode);
    NSLog(@"Resend OTP response :- %@",request.responseString);
    
    NSError *error = [request error];
    
    if ((request.responseStatusCode >= 200 && request.responseStatusCode <= 210) && !error)
    {
        NSMutableDictionary *responseDict = [NSJSONSerialization
                                             JSONObjectWithData:request.responseData //1
                                             
                                             options:kNilOptions
                                             error:&error];
        
        if (responseDict != nil) {
            
            [delegate didResendOTPSuccessfully:[responseDict objectForKey:@"otp_testing_ask_to_delete_ecurity_issue"]];
        }
    }
    else {
        
        [delegate didResendOTPFailed:request];
    }
}

-(void)didFailWithResendOTPRequest:(ASIHTTPRequest *)request
{
    [delegate didResendOTPFailed:request];
    
    NSLog(@"In ::Error:- %@",request.error.description);
}

@end
