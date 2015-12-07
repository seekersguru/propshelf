//
//  ImageMsg.m
//  PropShelf
//
//  Created by Gaurang Patel on 12/1/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import "ImageMsg.h"

@implementation ImageMsg

@synthesize delegate;
@synthesize nsqueue;

#pragma mark - Send Image Msg Request Method

-(void)sendImageMsgRequest:(NSMutableDictionary *)dict {
    
    if (self.nsqueue == nil) {
        self.nsqueue = [[ASINetworkQueue alloc] init];
    }
    
    NSURL *sendImageMsgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PRODUCTION_BASE_URL, Create_Message_URL]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:sendImageMsgUrl];
    [request setDelegate:self];
    [request setPropShelfHeaders];
    [request setRequestMethod:POST];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSString *postString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //NSLog(@"Send Image Msg Post String:- %@", postString);
    //NSLog(@"Send Image Msg URL :- %@", sendImageMsgUrl);
    
    [request appendPostData:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setDidFinishSelector:@selector(didFinishWithSendImageMsgRequest:)];
    [request setDidFailSelector:@selector(didFailWithSendImageMsgRequest:)];
    
    [self.nsqueue addOperation:request];
    [self.nsqueue go];
}

#pragma mark - Send Image Msg Request Delegate Method

-(void)didFinishWithSendImageMsgRequest:(ASIHTTPRequest *)request
{
    NSLog(@"Send Image Msg Status Code:- %d",request.responseStatusCode);
    //NSLog(@"Send Image Msg response :- %@",request.responseString);
    
    NSError *error = [request error];
    
    if ((request.responseStatusCode >= 200 && request.responseStatusCode <= 210) && !error)
    {
        NSMutableDictionary *responseDict = [NSJSONSerialization
                                             JSONObjectWithData:request.responseData //1
                                             
                                             options:kNilOptions
                                             error:&error];
        
        if (responseDict != nil) {
            
            [delegate didImageMsgSentSuccessfully:[[responseDict objectForKey:@"json"] mutableCopy]];
        }
        else {
            
            [delegate didImageMsgSentFailed:request];
        }
    }
    else {
        
        [delegate didImageMsgSentFailed:request];
    }
}

-(void)didFailWithSendImageMsgRequest:(ASIHTTPRequest *)request
{
    [delegate didImageMsgSentFailed:request];
    
    NSLog(@"In ::Error:- %@",request.error.description);
}

@end
