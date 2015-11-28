//
//  TextMsg.m
//  PropShelf
//
//  Created by Gaurang Patel on 11/2/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import "TextMsg.h"

@implementation TextMsg

@synthesize delegate;
@synthesize nsqueue;

#pragma mark - Send Text Msg Request Method

-(void)sendTextMsgRequest:(NSMutableDictionary *)dict {
    
    if (self.nsqueue == nil) {
        self.nsqueue = [[ASINetworkQueue alloc] init];
    }
    
    NSURL *sendTextMsgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PRODUCTION_BASE_URL, Create_Message_URL]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:sendTextMsgUrl];
    [request setDelegate:self];
    [request setPropShelfHeaders];
    [request setRequestMethod:POST];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSString *postString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"SendTextMsg Post String:- %@", postString);
    NSLog(@"SendTextMsg URL :- %@", sendTextMsgUrl);
    
    [request appendPostData:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setDidFinishSelector:@selector(didFinishWithSendTextMsgRequest:)];
    [request setDidFailSelector:@selector(didFailWithSendTextMsgRequest:)];
    
    [self.nsqueue addOperation:request];
    [self.nsqueue go];
}

#pragma mark - SendTextMsg Request Delegate Method

-(void)didFinishWithSendTextMsgRequest:(ASIHTTPRequest *)request
{
    NSLog(@"SendTextMsg Status Code:- %d",request.responseStatusCode);
    NSLog(@"SendTextMsg response :- %@",request.responseString);
    
    NSError *error = [request error];
    
    if ((request.responseStatusCode >= 200 && request.responseStatusCode <= 210) && !error)
    {
        NSMutableDictionary *responseDict = [NSJSONSerialization
         JSONObjectWithData:request.responseData //1
         
         options:kNilOptions
         error:&error];
         
        if (responseDict != nil) {
            
            [delegate didTextMsgSentSuccessfully:[[responseDict objectForKey:@"json"] mutableCopy]];
        }
    }
    else {
        
        [delegate didTextMsgSentFailed:request];
    }
}

-(void)didFailWithSendTextMsgRequest:(ASIHTTPRequest *)request
{
    [delegate didTextMsgSentFailed:request];
    
    NSLog(@"In ::Error:- %@",request.error.description);
}

@end
