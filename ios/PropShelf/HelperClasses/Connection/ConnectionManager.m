//
//  ConnectionManager.m
//
//  Created by Gaurang on 24/06/13.
//  Copyright (c) 2013 vWeet. All rights reserved.
//

#import "ConnectionManager.h"
#import "Reachability.h"

#define MIME_BOUNDARY @"3i2ndDfv2rTHiSisAbouNdArYfORhtTPEefj3q2f"


typedef enum
{
	TASK_CANCELLED = -2,
	TASK_UNSUCCESS = -1,
	TASK_OFFLINE = 0,
	TASK_SUCCESS = 1,
}TaskStatus;


@implementation ConnectionManager
@synthesize mURL, statusCode, mResponseData, authKeyHeader, mPostData;
@synthesize mConnection;
@synthesize mDelegate;
@synthesize mPostDataLength;
@synthesize httpMethod;

-(void) commonInit
{
	self.mDelegate = nil;
	authKeyHeader = NO;
	self.mPostData = nil;
	callbackSelector = nil;
    self.httpMethod = @"GET";
}
- (id) init
{
	self = [super init];
	if (self != nil) {
		[self commonInit];
	}
	return self;
}
-(id) initWithDelegate: (id) delegate
{
	if (self == [super init]) {
		[self commonInit];
		self.mDelegate = delegate;
		//self.callbackSelector = @selector(handleResponse::);
	}
	return self;
	
}
 

- (void) setUrl:(NSString *) pUrl Type:(NSInteger) pReqType postData:(NSData*) pData
{
	pUrl = [self urlEncode:pUrl];
    NSURL *tmpUrl=[[NSURL alloc] initWithString:pUrl];
	self.mURL = tmpUrl;
	mRequestType = pReqType;
	self.mPostData = pData;
}
/**
 Initiates the request. Makes the request to the server.
 @returns TRUE
 */
- (void) startHTTPConnection
{
	NSMutableURLRequest *urlReq = [NSMutableURLRequest requestWithURL:mURL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    
	//[urlReq setTimeoutInterval:60.0];
   // urlReq.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
	if(mPostData != nil || (mRequestType == REQ_POST)){
        
		[urlReq setHTTPBody:mPostData];
		[urlReq setHTTPMethod:@"POST"];
		
		if (mRequestType == REQ_POST_XML) {
			[urlReq setValue:@"application/xml" forHTTPHeaderField:@"Accept"];
			[urlReq setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
		}
		else if (mRequestType == REQ_POST_DATA) {
            
			NSString *contentType = [NSString stringWithFormat:@"multipart/form-data, boundary=%@", MIME_BOUNDARY];
			[urlReq setValue:contentType forHTTPHeaderField:@"Content-Type"];
		}
        else if (mRequestType == REQ_POST_BINARY) {
            [urlReq setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
            [urlReq setValue:[NSString stringWithFormat:@"%ld", mPostDataLength] forHTTPHeaderField:@"Content-Length"];
        }
        
	}
    
	/*if (authKeyHeader) {
        BidgleyAppDelegate *appdelegate=[[UIApplication sharedApplication] delegate];
		
        [urlReq addValue:appdelegate.AuthKey forHTTPHeaderField:@"X-AUTH-TOKEN"];
        
	} */
    
	[mConnection cancel];
    if (self.mConnection ) {
        
        self.mConnection=nil;
    }
    
    
    if (self.mResponseData) {
        self.mResponseData=nil;
    }
    
    NSURLConnection *tempObjCon=[[NSURLConnection alloc] initWithRequest:urlReq delegate:self];
	self.mConnection = tempObjCon;
    
	if (self.mConnection) {
        NSMutableData* tempData= [[NSMutableData alloc] initWithLength:0];
		self.mResponseData = tempData;
       
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	}
    
    
    
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        //if ([trustedHosts containsObject:challenge.protectionSpace.host])
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

-(void) cancelConnection
{
    if([UIApplication sharedApplication].networkActivityIndicatorVisible)
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    self.mResponseData = nil;
    
	[self.mConnection cancel];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)tempData 
{ 	
	[self.mResponseData appendData:tempData];	
	NSString *dataString = [[NSString alloc] initWithBytes:[mResponseData bytes] length:[mResponseData length] encoding:NSUTF8StringEncoding];
    
	NSLog(@"Data %@", dataString);
} 


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{	
	authKeyHeader = NO;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
	//NSString *url = [NSString stringWithFormat:@"%@", mURL];
    
    if([mDelegate respondsToSelector:@selector(ConnectionError:)])
    {
        
        [mDelegate performSelector:@selector(ConnectionError:) withObject:error];
       
        
        
    }
		
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	// this method is called when the server has determined that it 
	// has enough information to create the NSURLResponse 
	// it can be called multiple times, for example in the case of a 
	// redirect, so each time we reset the data. 
	// receivedData is declared as a method instance elsewhere 
	
	//NSLog(@"connection didReceiveResponse");
	if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
		
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        statusCode = [httpResponse statusCode];
		
		
		if (statusCode == 403 || statusCode == 401 || statusCode==406) { // forbidden
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if([mDelegate respondsToSelector:@selector(ConnectionError:)])
            {
              //  NSString *errorCode=[[NSString alloc] initWithFormat:@"%d",statusCode];
                
                [mDelegate performSelector:@selector(ConnectionError:) withObject:httpResponse];
                
                
            }		

			
		}
		else if (!((statusCode >= 200) && (statusCode < 300))) {
            //NSLog(@"Connection failed with status %d", statusCode);
			//authKeyHeader = NO;
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            
		}
       	
	}
}	

/*
 * This method invokes by the class when network finished with the loading of the request.
 */
- (void) connectionDidFinishLoading:(NSURLConnection *)connection 
{ 	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;	
 	
    if (statusCode == 200 || statusCode == 201) 
    {
            if([mDelegate respondsToSelector:@selector(ServerResponse:)])
        
            [mDelegate performSelector:@selector(ServerResponse:) withObject:mResponseData];
            
    }
    
	
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
    return YES;
}
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSString *username = @"username";
    NSString *password = @"password";
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:username
                                                             password:password
                                                          persistence:NSURLCredentialPersistenceForSession];
    [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
}
 

- (void)connection:(NSURLConnection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long) expectedTotalBytes
{
    NSLog(@"bytesWritten=%lld, totalBytesWritten=%lld, expectedTotalBytes=%lld ",bytesWritten,totalBytesWritten,expectedTotalBytes);
}

-(NSString*) urlEncode :(NSString *)connection_url
{
	if(connection_url == NULL){
		return NULL;
	}
    
	int index = 0;
	
	int size = [connection_url length];
	
	NSMutableString* encodedString = [[NSMutableString alloc] initWithCapacity:size];
	
	char c;
	for(;index < size ;index++){
		c =[connection_url characterAtIndex:index];
		
		if (
			(c >= ',' && c <= ';')
			|| (c >= 'A' && c <= 'Z')
			|| (c >= 'a' && c <= 'z')
			|| c == '_'
			|| c == '?'
			|| c == '&'
			|| c == '=') {
			
			[encodedString appendFormat:@"%c",c];
			
		} else {
			[encodedString appendString:@"%"];
			int x = (int)c;
			[encodedString appendFormat:@"%02x", x];
		}
	}
	return encodedString ;
}


+ (NSString*) urlEncode :(NSString *)connection_url
{
	if(connection_url == NULL){
		return NULL;
	}
    
	int index = 0;
	
	int size = [connection_url length];
	
	NSMutableString* encodedString = [[NSMutableString alloc] initWithCapacity:size];
	
	char c;
	for(;index < size ;index++){
		c =[connection_url characterAtIndex:index];
		
		if (
			(c >= ',' && c <= ';')
			|| (c >= 'A' && c <= 'Z')
			|| (c >= 'a' && c <= 'z')
			|| c == '_'
			|| c == '?'
			|| c == '&'
			|| c == '=') {
			
			[encodedString appendFormat:@"%c",c];
			
		} else {
			[encodedString appendString:@"%"];
			int x = (int)c;
			[encodedString appendFormat:@"%02x", x];
		}
	}
	return encodedString;
}



-(void)dealloc{
	
	self.mDelegate = nil;
	
}

@end
