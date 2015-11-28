//
//  MobileVerificationViewController.h
//  PropShelf
//
//  Created by Gaurang Patel on 11/3/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LoginModelClass.h"

@interface MobileVerificationViewController : BaseViewController <LoginModelClassDelegate> {
    
    IBOutlet UITextField *txtMobileNumber;
    IBOutlet UITextField *txtCountryCode;
    IBOutlet UITextField *txtOTP;
    
    IBOutlet UIButton *sendOTPBtn;
    IBOutlet UIButton *verfiyBtn;
}

@property (nonatomic,strong) LoginModelClass *loginModelClass;
@property (nonatomic,strong) NSMutableDictionary *userDict;

/*
-(IBAction)sendBtnTapped:(id)sender;
-(IBAction)verifyBtnTapped:(id)sender;
-(IBAction)resendBtnTapped:(id)sender;
*/

@end
