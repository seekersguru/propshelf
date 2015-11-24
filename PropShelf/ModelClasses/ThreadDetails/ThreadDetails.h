//
//  ThreadDetails.h
//  PropShelf
//
//  Created by Gaurang Patel on 11/4/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ThreadDetailsModelClassDelegate <NSObject>

-(void)didGetThreadDetailsSuccessfully:(NSMutableArray *)chatsArray;
-(void)didGetThreadDetailsFailed:(ASIHTTPRequest *)therequest;

@end

@interface ThreadDetails : NSObject

@property (nonatomic,strong) id<ThreadDetailsModelClassDelegate>delegate;
@property (nonatomic,strong) ASINetworkQueue *nsqueue;

-(void)getThreadDetails:(NSString *)threadId;

@end
