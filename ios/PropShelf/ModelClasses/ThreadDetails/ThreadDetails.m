//
//  ThreadDetails.m
//  PropShelf
//
//  Created by Gaurang Patel on 11/4/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import "ThreadDetails.h"

@implementation ThreadDetails

@synthesize delegate;

@synthesize nsqueue;

#pragma mark - getThreadDetails Request Method

-(void)getThreadDetails:(NSString *)threadId {
    
    if (self.nsqueue == nil) {
        self.nsqueue = [[ASINetworkQueue alloc] init];
    }
    
    NSURL *threadDetailsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@/",PRODUCTION_BASE_URL, Get_Thread_URL, threadId]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:threadDetailsUrl];
    [request setDelegate:self];
    [request setPropShelfHeaders];
    [request setRequestMethod:GET];
    
    NSLog(@"ThreadDetails URL :- %@", threadDetailsUrl);
    
    [request setDidFinishSelector:@selector(didFinishWithGetThreadDetailsRequest:)];
    [request setDidFailSelector:@selector(didFailWithGetThreadDetailsRequest:)];
    
    [self.nsqueue addOperation:request];
    [self.nsqueue go];
}

#pragma mark - ThreadDetails Request Delegate Method

-(void)didFinishWithGetThreadDetailsRequest:(ASIHTTPRequest *)request
{
    NSLog(@"ThreadDetails Status Code:- %d",request.responseStatusCode);
    NSLog(@"ThreadDetails response :- %@",request.responseString);
    
    NSError *error = [request error];
    
    if ((request.responseStatusCode >= 200 && request.responseStatusCode <= 210) && !error)
    {
        NSMutableDictionary *responseDict = [NSJSONSerialization
                                             JSONObjectWithData:request.responseData //1
                                             
                                             options:kNilOptions
                                             error:&error];
        
        if (responseDict != nil) {
            
            [delegate didGetThreadDetailsSuccessfully:[[responseDict objectForKey:@"json"] mutableCopy]];
        }
    }
    else {
        
        [delegate didGetThreadDetailsFailed:request];
    }
}

-(void)didFailWithGetThreadDetailsRequest:(ASIHTTPRequest *)request
{
    [delegate didGetThreadDetailsFailed:request];
    
    NSLog(@"In ::Error:- %@",request.error.description);
}

@end

