//
//  Wall.m
//  PropShelf
//
//  Created by Gaurang Patel on 11/2/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import "Wall.h"

@implementation Wall

@synthesize delegate;

@synthesize nsqueue;

#pragma mark - Get Wall Request Method

-(void)getWallRequest:(int)limit {
    
    if (self.nsqueue == nil) {
        self.nsqueue = [[ASINetworkQueue alloc] init];
    }
    
    NSURL *wallUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PRODUCTION_BASE_URL, Get_Wall_URL]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:wallUrl];
    [request setDelegate:self];
    [request setPropShelfHeaders];
    [request setRequestMethod:GET];
    
    NSLog(@"Get Wall URL :- %@", wallUrl);
    
    [request setDidFinishSelector:@selector(didFinishWithGetWallRequest:)];
    [request setDidFailSelector:@selector(didFailWithGetWallRequest:)];
    
    [self.nsqueue addOperation:request];
    [self.nsqueue go];
}

#pragma mark - Get Wall Request Delegate Method

-(void)didFinishWithGetWallRequest:(ASIHTTPRequest *)request
{
    NSLog(@"Get Wall Status Code:- %d",request.responseStatusCode);
    //NSLog(@"Get Wall response :- %@",request.responseString);
    
    NSError *error = [request error];
    
    if ((request.responseStatusCode >= 200 && request.responseStatusCode <= 210) && !error)
    {
        NSMutableDictionary *responseDict = [NSJSONSerialization
                                             JSONObjectWithData:request.responseData //1
                                             
                                             options:kNilOptions
                                             error:&error];
        
        if (responseDict != nil) {
            
            [delegate didGetWallSuccessfully:[[responseDict objectForKey:@"json"] mutableCopy]];
        }
    }
    else {
        
        [delegate didGetWallFailed:request];
    }
}

-(void)didFailWithGetWallRequest:(ASIHTTPRequest *)request
{
    [delegate didGetWallFailed:request];
    
    NSLog(@"In ::Error:- %@",request.error.description);
}

@end
