//
//  SignInViewController.h
//  PropShelf
//
//  Created by Gaurang Patel on 10/13/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GooglePlus/GooglePlus.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import <linkedin-sdk/LISDK.h>

@interface SignInViewController : BaseViewController <GPPSignInDelegate> {
        
    IBOutlet UIButton *facebookBtn;
    IBOutlet UIButton *linkedInBtn;
    
    NSMutableDictionary *userDict;
}

@property (retain, nonatomic) IBOutlet GPPSignInButton *gppSignInButton;

-(IBAction)googleBtnTapped:(id)sender;
-(IBAction)facebookBtnTapped:(id)sender;
-(IBAction)linkedInBtnTapped:(id)sender;

@end

