//
//  TextMsg.h
//  PropShelf
//
//  Created by Gaurang Patel on 11/2/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TextMsgModelClassDelegate <NSObject>

-(void)didTextMsgSentSuccessfully:(NSMutableArray *)responseArray;
-(void)didTextMsgSentFailed:(ASIHTTPRequest *)therequest;

@end

@interface TextMsg : NSObject

@property (nonatomic,strong) id<TextMsgModelClassDelegate>delegate;
@property (nonatomic,strong) ASINetworkQueue *nsqueue;

-(void)sendTextMsgRequest:(NSMutableDictionary *)dict;

@end
