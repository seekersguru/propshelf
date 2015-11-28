//
//  NetworkError.m
//  vWeetApp
//
//  Created by Gaurang on 24/06/13.
//  Copyright (c) 2013 vWeet. All rights reserved.
//

#import "NetworkError.h"

#define kNetworkErrorMessageTitle @"Network Error"
#define kNetworkErrorMessageDetails @"You are not connected to internet. Please check your internert connection."

Reachability * reachability;
BOOL internetStatus;
NetworkError * connection;

@interface NetworkError (NetworkError_PrivateMethods)
- (void)checkNetworkStatus:(NSNotification *)notice;
@end

@implementation NetworkError

+(BOOL)checkNetwork
{
    if (connection == nil ) {
        connection = [[NetworkError alloc]init];
        reachability = [Reachability reachabilityForInternetConnection];
        [reachability startNotifier];
    }
    
    [connection checkNetworkStatus:nil];

    //[[NSNotificationCenter defaultCenter] addObserver:connection selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];

	if (internetStatus) {
		return YES;
	}
	else {
		return NO;
	}
}


- (void)checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    
    NetworkStatus internetStatus2 = [reachability currentReachabilityStatus];
    
    switch (internetStatus2)
    
    {
        case NotReachable:
        {
            //NSLog(@"The internet is down.");
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"INTERNET_DISCONNECTED" object:nil];
            internetStatus = NO;
            
            break;
            
        }
        case ReachableViaWiFi:
        {
            //NSLog(@"The internet is working via WIFI.");
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"INTERNET_CONNECTED" object:nil];
            internetStatus = YES;
            
            break;
            
        }
        case ReachableViaWWAN:
        {
            //NSLog(@"The internet is working via WWAN.");
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"INTERNET_CONNECTED" object:nil];
            internetStatus = YES;
            
            break;
            
        }
    }
}

+(void)deallocData
{
    internetStatus = NO;
    connection = nil;
    reachability = nil;
}

@end
