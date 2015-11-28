//
//  GetGroupsModelClass.m
//  PropShelf
//
//  Created by Gaurang Patel on 10/26/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import "GetGroupsModelClass.h"

@implementation GetGroupsModelClass

@synthesize delegate;

@synthesize nsqueue;

#pragma mark - Get Groups Request Method

-(void)getGroupsRequest:(int)pageNumber {
    
    if (self.nsqueue == nil) {
        self.nsqueue = [[ASINetworkQueue alloc] init];
    }
    
    NSURL *groupUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PRODUCTION_BASE_URL, Groups_URL]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:groupUrl];
    [request setDelegate:self];
    [request setPropShelfHeaders];
    [request setRequestMethod:POST];
    
    NSString* postString = [NSString stringWithFormat:Get_Groups_Payload, pageNumber];
    
    NSLog(@"Get Groups Post String:- %@", postString);
    NSLog(@"Get Groups URL :- %@", groupUrl);
    
    [request appendPostData:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setDidFinishSelector:@selector(didFinishWithGetGroupsRequest:)];
    [request setDidFailSelector:@selector(didFailWithGetGroupsRequest:)];
    
    [self.nsqueue addOperation:request];
    [self.nsqueue go];
}

#pragma mark - Get Groups Request Delegate Method

-(void)didFinishWithGetGroupsRequest:(ASIHTTPRequest *)request
{
    NSLog(@"Get Groups Status Code:- %d",request.responseStatusCode);
    NSLog(@"Get Groups response :- %@",request.responseString);
    
    NSError *error = [request error];
    
    if ((request.responseStatusCode >= 200 && request.responseStatusCode <= 210) && !error)
    {
        NSMutableDictionary *responseDict = [NSJSONSerialization
                                             JSONObjectWithData:request.responseData //1
                                             
                                             options:kNilOptions
                                             error:&error];
        
        if (responseDict != nil) {
            
            [delegate didGetGroupsSuccessfully:[[responseDict objectForKey:@"json"] mutableCopy]];
        }
    }
    else {
        
        [delegate didGetGroupsFailed:request];
    }
}

-(void)didFailWithGetGroupsRequest:(ASIHTTPRequest *)request
{
    [delegate didGetGroupsFailed:request];
    
    NSLog(@"In ::Error:- %@",request.error.description);
}

#pragma mark - JoinUnJoinGroup Request Method

-(void)joinUnJoinGroupRequest:(int)groupId url:(NSString *)url {
    
    if (self.nsqueue == nil) {
        self.nsqueue = [[ASINetworkQueue alloc] init];
    }
    
    NSURL *groupUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PRODUCTION_BASE_URL, url]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:groupUrl];
    [request setDelegate:self];
    [request setPropShelfHeaders];
    [request setRequestMethod:POST];
    
    NSString* postString = [NSString stringWithFormat:Join_Unjoin_Group_Payload, groupId];
    
    NSLog(@"JoinUnJoinGroup Post String:- %@", postString);
    NSLog(@"JoinUnJoinGroup URL :- %@", groupUrl);
    
    [request appendPostData:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setDidFinishSelector:@selector(didFinishWithJoinUnJoinGroupRequest:)];
    [request setDidFailSelector:@selector(didFailWithJoinUnJoinGroupRequest:)];
    
    [self.nsqueue addOperation:request];
    [self.nsqueue go];
}

#pragma mark - JoinUnJoinGroup Request Delegate Method

-(void)didFinishWithJoinUnJoinGroupRequest:(ASIHTTPRequest *)request
{
    NSLog(@"JoinUnJoinGroup Status Code:- %d",request.responseStatusCode);
    NSLog(@"JoinUnJoinGroup response :- %@",request.responseString);
    
    NSError *error = [request error];
    
    if ((request.responseStatusCode >= 200 && request.responseStatusCode <= 210) && !error)
    {
        NSMutableArray *responseArray = [NSJSONSerialization
                                         JSONObjectWithData:request.responseData //1
                                         
                                         options:kNilOptions
                                         error:&error];
        
        if (responseArray != nil) {
            
            [delegate didJoinUnJoinGroupSuccessfully];
        }
    }
    else {
        
        [delegate didJoinUnJoinGroupFailed:request];
    }
}

-(void)didFailWithJoinUnJoinGroupRequest:(ASIHTTPRequest *)request
{
    [delegate didJoinUnJoinGroupFailed:request];
    
    NSLog(@"In ::Error:- %@",request.error.description);
}

#pragma mark - Delete Group Request Delegate Method

-(void)deleteGroupRequest:(int)groupId {
    
    if (self.nsqueue == nil) {
        self.nsqueue = [[ASINetworkQueue alloc] init];
    }
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PRODUCTION_BASE_URL, [NSString stringWithFormat:Delete_Group_URL, groupId]]]];
    
    NSLog(@"Delete Group URL :- %@",request.url);
    
    [request setDelegate:self];
    [request setPropShelfHeaders];
    [request setRequestMethod:DELETE];
    
    // We don't need to Post data
    [request setDidFinishSelector:@selector(didFinishWithDeleteGroupUserRequest:)];
    [request setDidFailSelector:@selector(didFailWithDeleteGroupUserRequest:)];
    
    [self.nsqueue addOperation:request];
    [self.nsqueue go];
}

#pragma mark - Delete Group Request Delegate Method

-(void)didFinishWithDeleteGroupUserRequest:(ASIHTTPRequest *)request
{
    NSLog(@"Delete Group Status Code:- %d",request.responseStatusCode);
    NSLog(@"Delete Group response :- %@",request.responseString);
    
    NSError *error = [request error];
    
    if ((request.responseStatusCode >= 200 && request.responseStatusCode <= 210) && !error)
    {
        /*NSMutableDictionary *responseDict = [NSJSONSerialization
         JSONObjectWithData:request.responseData //1
         
         options:kNilOptions
         error:&error];*/
        
        [delegate didGroupDeletedSuccessfully];
    }
    else {
        
        [delegate didGroupDeletedFailed:request];
    }
}

-(void)didFailWithDeleteGroupUserRequest:(ASIHTTPRequest *)request
{
    [delegate didGroupDeletedFailed:request];
    
    NSLog(@"In ::Error:- %@",request.error.description);
}

@end
