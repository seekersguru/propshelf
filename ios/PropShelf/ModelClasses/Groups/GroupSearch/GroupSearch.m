//
//  GroupSearch.m
//  PropShelf
//
//  Created by Gaurang Patel on 12/7/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import "GroupSearch.h"

@implementation GroupSearch

@synthesize delegate;

@synthesize nsqueue;

#pragma mark - Search Group Request Method

-(void)searchGroupRequest:(NSMutableDictionary *)payloadDict {
    
    if (self.nsqueue == nil) {
        self.nsqueue = [[ASINetworkQueue alloc] init];
    }
    
    NSURL *searchGroupUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PRODUCTION_BASE_URL, Search_Group_URL]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:searchGroupUrl];
    [request setDelegate:self];
    [request setPropShelfHeaders];
    [request setRequestMethod:POST];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payloadDict options:0 error:nil];
    NSString *postString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"SearchGroup Post String:- %@", postString);
    NSLog(@"SearchGroup URL :- %@", searchGroupUrl);
    
    [request appendPostData:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setDidFinishSelector:@selector(didFinishWithSearchGroupRequest:)];
    [request setDidFailSelector:@selector(didFailWithSearchGroupRequest:)];
    
    [self.nsqueue addOperation:request];
    [self.nsqueue go];
}

#pragma mark - SearchGroup Request Delegate Method

-(void)didFinishWithSearchGroupRequest:(ASIHTTPRequest *)request
{
    NSLog(@"SearchGroup Status Code:- %d",request.responseStatusCode);
    NSLog(@"SearchGroup response :- %@",request.responseString);
    
    NSError *error = [request error];
    
    if ((request.responseStatusCode >= 200 && request.responseStatusCode <= 210) && !error)
    {
        NSMutableDictionary *responseDict = [NSJSONSerialization
                                             JSONObjectWithData:request.responseData //1
                                             
                                             options:kNilOptions
                                             error:&error];
        
        if (responseDict != nil) {
            
            [delegate didSearchGroupSuccessfully:[[responseDict objectForKey:@"json"] mutableCopy]];
        }
    }
    else {
        
        [delegate didSearchGroupFailed:request];
    }
}

-(void)didFailWithSearchGroupRequest:(ASIHTTPRequest *)request
{
    [delegate didSearchGroupFailed:request];
    
    NSLog(@"In ::Error:- %@",request.error.description);
}

@end
