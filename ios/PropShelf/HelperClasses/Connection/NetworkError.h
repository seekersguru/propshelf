//
//  NetworkError.h
//  vWeetApp
//
//  Created by Gaurang on 24/06/13.
//  Copyright (c) 2013 vWeet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface NetworkError : NSObject {
    
}

+(BOOL)checkNetwork;
+(void)deallocData;
- (void)checkNetworkStatus:(NSNotification *)notice;

@end
