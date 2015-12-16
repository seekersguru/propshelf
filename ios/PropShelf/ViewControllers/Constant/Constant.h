//
//  Constant.h
//  PropShelf
//
//  Created by Gaurang Patel on 10/15/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_5S (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//--------------- Server Request URL's ---------------

#define PRODUCTION_BASE_URL @"http://surveyglass.in/api/"

#define IMAGE_MSG_BASE_URL @"http://surveyglass.in/"

//--------------- Server Request Methods ---------------

#define POST @"POST"
#define PUT @"PUT"
#define GET @"GET"
#define DELETE @"DELETE"

//--------------- Server Request Content-Type ---------------

#define CONTENT_TYPE_FIELD_ENCODING @"Accept-Encoding"
#define CONTENT_TYPE_JSON_GZIP_VALUE @"gzip"

#define CONTENT_TYPE_FIELD @"Content-Type"
#define CONTENT_TYPE_JSON_VALUE @"application/json"
#define AUTHENTICATION_KEY @"Authorization"

//--------------- Google Plus Login Client ID ---------------

//https://developers.google.com/+/mobile/ios/getting-started

//822573348565-jl01735kkghiogf9vvodtumdpg1np2u3.apps.googleusercontent.com

#define GOOGLE_PLUS_ID @"881026152887-0ugoeo57lqrdpsjtq49orgvco1p6pdaq.apps.googleusercontent.com"

//--------------- Message Type ---------------
#define IMAGE_MSG_TYPE @"image/jpg"
#define TEXT_MSG_TYPE @"text/plain"

#define PLACEHOLDER_IMAGE_MSG @"placeholder_png"

#define PLACEHOLDER_USER_IMAGE @"profilepic"

#define ADMIN_DETAILS @"ADMIN_DETAILS"

#define Get_Profile_URL @"profile/"

#define Update_Profile_URL @"update_profile/"

#define Get_Thread_URL @"thread/"

#define Get_Group_Info_URL @"group_info/"

#define Get_Wall_URL @"wall/"

#define Join_URL @"join_group/"

#define UnJoin_URL @"unjoin_group/"

#define Join_Unjoin_Group_Payload @"{\"group_id\":%d}"

#define Group_Id_Payload @"{\"group_id\":\"%@\"}"

#define Delete_Group_URL @"group/%d"

#define Get_User_Details_URL @"user_info/"

#define User_Id_Payload @"{\"user_id\":\"%@\"}"

#define Get_Group_User_URL @"group_user/"

#define Create_Group_URL @"group/"

#define Create_Message_URL @"message/"

#define Search_Group_URL @"search_group/"

#define Groups_URL @"groups/"

#define Get_Groups_Payload @"{\"page_no\":%d}"

#define Locations_URL @"sub_locations/"

#define Get_Location_Payload @"{\"city_name\":\"%@\"}"

#define Cities_URL @"cities/"

#define Create_User_URL @"create_user/"

#define VerifyOTP_URL @"verify_otp/"

#define ResendOTP_URL @"resend_otp/"

#define ACCEPTABLE_CHARECTERS @"0123456789."

//--------------- NSUserDefaults Keys ---------------

#define APP_SESSION_ID @"appSessionId"
#define SESSION @"session"
#define LAST_ACCESS_TIME @"lastAccessTime"
#define LOGGED_IN_USER_ID @"userId"

//--------------- Registeration ---------------

#endif /* Constant_h */
