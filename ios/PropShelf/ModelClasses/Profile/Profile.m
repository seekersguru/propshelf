//
//  Profile.m
//  PropShelf
//
//  Created by Gaurang Patel on 12/4/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import "Profile.h"

@implementation Profile

@synthesize delegate;

@synthesize nsqueue;

#pragma mark - GetLoggedInUserProfile Request Method

-(void)getLoggedInUserProfile {
    
    if (self.nsqueue == nil) {
        self.nsqueue = [[ASINetworkQueue alloc] init];
    }
    
    NSURL *profileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PRODUCTION_BASE_URL, Get_Profile_URL]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:profileUrl];
    [request setDelegate:self];
    [request setPropShelfHeaders];
    [request setRequestMethod:GET];
    
    //NSLog(@"GetLoggedInUserProfile URL :- %@", profileUrl);
    
    [request setDidFinishSelector:@selector(didFinishWithGetLoggedInUserProfileRequest:)];
    [request setDidFailSelector:@selector(didFailWithGetLoggedInUserProfileRequest:)];
    
    [self.nsqueue addOperation:request];
    [self.nsqueue go];
}

#pragma mark - GetLoggedInUserProfile Request Delegate Method

-(void)didFinishWithGetLoggedInUserProfileRequest:(ASIHTTPRequest *)request
{
    NSLog(@"GetLoggedInUserProfile Status Code:- %d",request.responseStatusCode);
    NSLog(@"GetLoggedInUserProfile response :- %@",request.responseString);
    
    NSError *error = [request error];
    
    if ((request.responseStatusCode >= 200 && request.responseStatusCode <= 210) && !error)
    {
        NSMutableDictionary *responseDict = [NSJSONSerialization
                                             JSONObjectWithData:request.responseData //1
                                             
                                             options:kNilOptions
                                             error:&error];
        
        if (responseDict != nil) {
            
            [delegate didGetLoggedInUserProfileSuccessfully:responseDict];
        }
    }
    else {
        
        [delegate didGetLoggedInUserProfileFailed:request];
    }
}

-(void)didFailWithGetLoggedInUserProfileRequest:(ASIHTTPRequest *)request
{
    [delegate didGetLoggedInUserProfileFailed:request];
    
    NSLog(@"In ::Error:- %@",request.error.description);
}

#pragma mark - updateProfile Request Method

-(void)updateProfile:(NSMutableDictionary *)payloadDict {
    
    if (self.nsqueue == nil) {
        self.nsqueue = [[ASINetworkQueue alloc] init];
    }
    
    NSURL *updateProfileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PRODUCTION_BASE_URL, Update_Profile_URL]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:updateProfileUrl];
    [request setDelegate:self];
    [request setPropShelfHeaders];
    [request setRequestMethod:POST];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payloadDict options:0 error:nil];
    NSString *postString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"UpdateProfile Post String:- %@", postString);
    NSLog(@"UpdateProfile URL :- %@", updateProfileUrl);
    
    [request appendPostData:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setDidFinishSelector:@selector(didFinishWithUpdateProfileRequest:)];
    [request setDidFailSelector:@selector(didFailWithUpdateProfileRequest:)];
    
    [self.nsqueue addOperation:request];
    [self.nsqueue go];
}

#pragma mark - UpdateProfile Request Delegate Method

-(void)didFinishWithUpdateProfileRequest:(ASIHTTPRequest *)request
{
    NSLog(@"UpdateProfile Status Code:- %d",request.responseStatusCode);
    NSLog(@"UpdateProfile response :- %@",request.responseString);
    
    NSError *error = [request error];
    
    if ((request.responseStatusCode >= 200 && request.responseStatusCode <= 210) && !error)
    {
        NSMutableDictionary *responseDict = [NSJSONSerialization
                                             JSONObjectWithData:request.responseData //1
                                             
                                             options:kNilOptions
                                             error:&error];
        
        if (responseDict != nil) {
            
            [delegate didUpdateProfileSuccessfully:responseDict];
        }
        else {
            
            [delegate didUpdateProfileFailed:request];
        }
    }
    else {
        
        [delegate didUpdateProfileFailed:request];
    }
}

-(void)didFailWithUpdateProfileRequest:(ASIHTTPRequest *)request
{
    [delegate didUpdateProfileFailed:request];
    
    NSLog(@"In ::Error:- %@",request.error.description);
}

@end
