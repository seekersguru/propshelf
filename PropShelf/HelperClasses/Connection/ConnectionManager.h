//
//  ConnectionManager.h
//
//  Created by Gaurang on 24/06/13.
//  Copyright (c) 2013 vWeet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Reachability;
@protocol ConnectionManagerDelegate <NSObject>

@optional


-(void) InternetOffline:(int) statusCode;
-(void) AuthKeyExpired:(int) statusCode;
-(void) ServerResponse:(id)responseObject;

@required
-(void) ConnectionError:(NSString*) errorMessage;


@end

enum
{
	REQ_CANCEL_DOWNLOAD = 0,
	REQ_GET = 1,
	REQ_POST = 2,
	REQ_POST_XML,
	REQ_POST_DATA,
    REQ_POST_BINARY,
	REQ_AUTH,
	REQ_GET_JSON,
};


typedef enum {
    TTConnectionManager_SUCCESS,
    TTConnectionManager_CONNECTIONFAIL,
    TTConnectionManager_SERVERERROR,
    TTConnectionManager_UNKNOWN
} TTConnectionManagerErrorCodes;



@interface ConnectionManager : NSObject {
	NSURL *mURL;
	NSInteger mRequestType;
	NSMutableData *mResponseData;
	NSData *mPostData;
	NSURLConnection *mConnection;
	int totalBytes;
    long mPostDataLength;
    NSString *httpMethod;  // POST, GET
	
	
	NSInteger statusCode;
	BOOL authKeyHeader;
	
	NSObject *mDelegate;
	SEL callbackSelector;
	
}
@property (nonatomic) NSObject *mDelegate;

@property (nonatomic,retain) NSURL *mURL;
@property (readonly) NSInteger statusCode;
@property (nonatomic,retain) NSMutableData *mResponseData;
@property (nonatomic,retain) NSData *mPostData;
@property (nonatomic,retain) NSURLConnection *mConnection;
@property (nonatomic) BOOL authKeyHeader;
@property (nonatomic) long mPostDataLength;
@property (nonatomic, retain) NSString *httpMethod;

-(void) commonInit;
-(id)init;
-(id) initWithDelegate: (id) delegate;
//-(id) initWithDelegate:(id)delegate callbackSelector: (SEL) sel;

/**
 starts the http connection to server.
 */
- (void) startHTTPConnection;

/**
 This method is used to set the url and request type.
 */
- (void) setUrl:(NSString *) pUrl Type:(NSInteger) pReqType postData:(NSData*) pData;

-(NSString*) urlEncode :(NSString *)connection_url;
+ (NSString*) urlEncode :(NSString *)connection_url;

//-(NSString *) getLog;
-(void) cancelConnection;


@end

