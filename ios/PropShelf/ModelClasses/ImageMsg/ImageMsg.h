//
//  ImageMsg.h
//  PropShelf
//
//  Created by Gaurang Patel on 12/1/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageMsgModelClassDelegate <NSObject>

-(void)didImageMsgSentSuccessfully:(NSMutableArray *)responseArray;
-(void)didImageMsgSentFailed:(ASIHTTPRequest *)therequest;

@end


@interface ImageMsg : NSObject

@property (nonatomic,strong) id<ImageMsgModelClassDelegate>delegate;
@property (nonatomic,strong) ASINetworkQueue *nsqueue;

-(void)sendImageMsgRequest:(NSMutableDictionary *)dict;

@end
