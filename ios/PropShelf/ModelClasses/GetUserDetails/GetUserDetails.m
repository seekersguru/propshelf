//
//  GetUserDetails.m
//  PropShelf
//
//  Created by Gaurang Patel on 12/4/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import "GetUserDetails.h"

@implementation GetUserDetails

@synthesize delegate;

@synthesize nsqueue;

#pragma mark - Get User Details Request Method

-(void)getUserDetailsRequest:(NSString *)userId {

    if (self.nsqueue == nil) {
        self.nsqueue = [[ASINetworkQueue alloc] init];
    }
    
    NSURL *userDetailsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PRODUCTION_BASE_URL, Get_User_Details_URL]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:userDetailsUrl];
    [request setDelegate:self];
    [request setPropShelfHeaders];
    [request setRequestMethod:POST];
    
    NSString*postString = [NSString stringWithFormat:User_Id_Payload, userId];
    
    //NSLog(@"Get UserDetails Post String:- %@", postString);
    //NSLog(@"Get UserDetails URL :- %@", userDetailsUrl);
    
    [request appendPostData:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setDidFinishSelector:@selector(didFinishWithGetUserDetailsRequest:)];
    [request setDidFailSelector:@selector(didFailWithGetUserDetailsRequest:)];
    
    [self.nsqueue addOperation:request];
    [self.nsqueue go];
}

#pragma mark - Get User Details Request Delegate Method

-(void)didFinishWithGetUserDetailsRequest:(ASIHTTPRequest *)request
{
    NSLog(@"Get UserDetails Status Code:- %d",request.responseStatusCode);
    //NSLog(@"Get UserDetails response :- %@",request.responseString);
    
    NSError *error = [request error];
    
    if ((request.responseStatusCode >= 200 && request.responseStatusCode <= 210) && !error)
    {
        NSMutableDictionary *responseDict = [NSJSONSerialization
                                             JSONObjectWithData:request.responseData //1
                                             
                                             options:kNilOptions
                                             error:&error];
        
        if (responseDict != nil) {
            
            [delegate didGetUserDetailsSuccessfully:[responseDict mutableCopy]];
        }
        else {
            
            [delegate didGetUserDetailsFailed:request];
        }
    }
    else {
        
        [delegate didGetUserDetailsFailed:request];
    }
}

-(void)didFailWithGetUserDetailsRequest:(ASIHTTPRequest *)request
{
    [delegate didGetUserDetailsFailed:request];
    
    NSLog(@"In ::Error:- %@",request.error.description);
}

@end
