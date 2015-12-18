//
//  CreateGroupModelClass.m
//  PropShelf
//
//  Created by Gaurang Patel on 10/26/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import "CreateGroupModelClass.h"

@implementation CreateGroupModelClass

@synthesize delegate;

@synthesize nsqueue;

#pragma mark - Create Group Request Method

-(void)createGroupRequest:(NSMutableDictionary *)dict {
    
    if (self.nsqueue == nil) {
        self.nsqueue = [[ASINetworkQueue alloc] init];
    }
    
    NSURL *createGroupUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PRODUCTION_BASE_URL, Create_Group_URL]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:createGroupUrl];
    [request setDelegate:self];
    [request setPropShelfHeaders];
    [request setRequestMethod:POST];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSString *postString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //NSLog(@"Create Group Post String:- %@", postString);
    //NSLog(@"Create Group URL :- %@", createGroupUrl);
    
    [request appendPostData:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setDidFinishSelector:@selector(didFinishWithCreateGroupRequest:)];
    [request setDidFailSelector:@selector(didFailWithCreateGroupRequest:)];
    
    [self.nsqueue addOperation:request];
    [self.nsqueue go];
}

#pragma mark - Create Group Request Delegate Method

-(void)didFinishWithCreateGroupRequest:(ASIHTTPRequest *)request
{
    NSLog(@"Create Group Status Code:- %d",request.responseStatusCode);
    NSLog(@"Create Group response :- %@",request.responseString);
    
    NSError *error = [request error];
    
    if ((request.responseStatusCode >= 200 && request.responseStatusCode <= 210) && !error)
    {
        NSMutableDictionary *responseDict = [NSJSONSerialization
                                             JSONObjectWithData:request.responseData //1
                                             
                                             options:kNilOptions
                                             error:&error];
        
        if (responseDict != nil) {
            
            [delegate didCreateGroupSuccessfully:[responseDict objectForKey:@"message"]];
        }
        else {
            
            [delegate didCreateGroupSuccessfully:nil];
        }
    }
    else {
        
        [delegate didCreateGroupFailed:request];
    }
}

-(void)didFailWithCreateGroupRequest:(ASIHTTPRequest *)request
{
    [delegate didCreateGroupFailed:request];
    
    NSLog(@"In ::Error:- %@",request.error.description);
}

#pragma mark - Get Group User Request Method

-(void)getGroupUserRequest:(int)groupId {
    
    if (self.nsqueue == nil) {
        self.nsqueue = [[ASINetworkQueue alloc] init];
    }
    
    NSURL *groupUserUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PRODUCTION_BASE_URL, Get_Group_User_URL]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:groupUserUrl];
    [request setDelegate:self];
    [request setPropShelfHeaders];
    [request setRequestMethod:POST];

    NSString*postString = [NSString stringWithFormat:Join_Unjoin_Group_Payload, groupId];

    //NSLog(@"Get Group User Post String:- %@", postString);
    //NSLog(@"Get Group User URL :- %@", groupUserUrl);
    
    [request appendPostData:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setDidFinishSelector:@selector(didFinishWithGetGroupUserRequest:)];
    [request setDidFailSelector:@selector(didFailWithGetGroupUserRequest:)];
    
    [self.nsqueue addOperation:request];
    [self.nsqueue go];
}

#pragma mark - Get Group User Request Delegate Method

-(void)didFinishWithGetGroupUserRequest:(ASIHTTPRequest *)request
{
    NSLog(@"Get Group User Status Code:- %d",request.responseStatusCode);
    //NSLog(@"Get Group User response :- %@",request.responseString);
    
    NSError *error = [request error];
    
    if ((request.responseStatusCode >= 200 && request.responseStatusCode <= 210) && !error)
    {
        NSMutableDictionary *responseDict = [NSJSONSerialization
                                             JSONObjectWithData:request.responseData //1
                                             
                                             options:kNilOptions
                                             error:&error];
        
        if (responseDict != nil) {
            
            [delegate didGetGroupUserSuccessfully:[[responseDict objectForKey:@"json"] mutableCopy]];
        }
    }
    else {
        
        [delegate didGetGroupUserFailed:request];
    }
}

-(void)didFailWithGetGroupUserRequest:(ASIHTTPRequest *)request
{
    [delegate didGetGroupUserFailed:request];
    
    NSLog(@"In ::Error:- %@",request.error.description);
}

@end
