//
//  ASIHTTPRequest+ASIHTTPRequest_Header.m
//  PropShelf
//
//  Created by Gaurang on 24/06/13.
//  Copyright (c) 2013 vWeet. All rights reserved.
//

#import "ASIHTTPRequest+ASIHTTPRequest_Header.h"

@implementation ASIHTTPRequest (ASIHTTPRequest_Header)

-(void) setPropShelfHeaders
{    
    if ([Common getCurrentSessionId] != nil) {
            
        [self setTimeOutSeconds:2000];
        //[self addRequestHeader:CONTENT_TYPE_FIELD_ENCODING value:CONTENT_TYPE_JSON_GZIP_VALUE];
        //[self addRequestHeader:CONTENT_TYPE_FIELD value:CONTENT_TYPE_JSON_VALUE];
        //[self addRequestHeader:AUTHENTICATION_KEY value:[@"Basic " stringByAppendingString:[Common getCurrentSessionId]]];
        
        [self addRequestHeader:AUTHENTICATION_KEY value:[Common getCurrentSessionId]];
        //[self addRequestHeader:CONTENT_TYPE_FIELD value:CONTENT_TYPE_JSON_VALUE];
        
        NSLog(@"Header : %@ - Values : %@", AUTHENTICATION_KEY, [Common getCurrentSessionId]);
    }
}

@end
