//
//  UserProfileViewController.h
//  PropShelf
//
//  Created by Gaurang Patel on 11/19/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Profile.h"

@interface UserProfileViewController : BaseViewController <GetLoggedInUserProfileModelClassDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    IBOutlet UIImageView *userProfilePic;
    IBOutlet UITextField *userName;
    
    IBOutlet UIButton *picEditBtn;
    IBOutlet UIButton *nameEditBtn;
}

@property (nonatomic,strong) Profile *profileModelClass;

-(IBAction)picEditBtnClicked:(id)sender;
-(IBAction)nameEditBtnClicked:(id)sender;

@end
