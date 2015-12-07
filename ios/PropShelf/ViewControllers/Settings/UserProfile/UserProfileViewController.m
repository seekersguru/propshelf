//
//  UserProfileViewController.m
//  PropShelf
//
//  Created by Gaurang Patel on 11/19/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import "UserProfileViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>

#import <MobileCoreServices/MobileCoreServices.h>

@interface UserProfileViewController () <UIActionSheetDelegate>

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarItems];
    
    CGFloat borderWidth = 1.0f;

    userProfilePic.layer.borderColor = [UIColor colorWithRed:207.0/255.0 green:207.0/255.0 blue:207.0/255.0 alpha:1.0].CGColor;
    userProfilePic.layer.borderWidth = borderWidth;
    userProfilePic.backgroundColor = [UIColor whiteColor];
    userProfilePic.layer.cornerRadius = 0.0f;
    userProfilePic.layer.masksToBounds = YES;

    userName.userInteractionEnabled = NO;

    NSDictionary *loggedInInfoDict = [Common retriveLoggedInUserInfo];
    
    if ([loggedInInfoDict objectForKey:@"first_name"] != nil) {
        
        userName.text = [NSString stringWithFormat:@"%@ %@", [loggedInInfoDict objectForKey:@"first_name"], [loggedInInfoDict objectForKey:@"last_name"]];
    }

    [userProfilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [loggedInInfoDict objectForKey:@"user_pic"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDER_IMAGE_MSG]];

    self.title = NSLocalizedString(@"USER_PROFILE_NAV_TITLE", nil);
    
    if ([NetworkError checkNetwork]) {
        
        [self showLoaderWithTitle:@"Loading Profile..."];
        
        if (self.profileModelClass == nil) {
            
            self.profileModelClass = [[Profile alloc] init];
            self.profileModelClass.delegate = self;
        }
        
        [self.profileModelClass getLoggedInUserProfile];
    }
    else {
        
        [self showAlertViewWithTitle:NSLocalizedString(@"NO_INTERNET_ALERT_TITLE", nil) message:NSLocalizedString(@"NO_INTERNET_ALERT_MESSAGE", nil)];
        
        return;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark -
#pragma mark setNavigationBarItems Methods

-(void)setNavigationBarItems {
    
    UIButton *updateBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [updateBtn setFrame:CGRectMake(0, 0, 60, 15)];
    [updateBtn setTitle:@"Update" forState:UIControlStateNormal];
    [updateBtn addTarget:self action:@selector(updateBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    updateBtn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *dotBtn = [[UIBarButtonItem alloc] initWithCustomView:updateBtn];
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 15.0f;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: dotBtn, fixedSpace, nil];
    
    UIView *navTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    navTitleView.backgroundColor = [UIColor clearColor];
    
    CGFloat lblXAxis = 0;
    
    lblXAxis = navTitleView.frame.origin.x - 68.0;

    // Customize the title text for *all* UINavigationBars
    UILabel *navTitle = [[UILabel alloc] init];
    navTitle.frame = CGRectMake(lblXAxis, 2, 240, 44);
    navTitle.text = NSLocalizedString(@"USER_PROFILE_NAV_TITLE", nil);
    navTitle.textColor = [UIColor whiteColor];
    navTitle.backgroundColor = [UIColor clearColor];
    navTitle.textAlignment = NSTextAlignmentCenter;
    [navTitleView addSubview:navTitle];
    
    self.navigationItem.titleView = navTitleView;
    
    [self.navigationController.navigationBar setNeedsLayout];
}

#pragma mark - Action Button Methods

-(IBAction)updateBtnTapped:(id)sender
{
    [self didEndAnimation];
    
    userName.userInteractionEnabled = NO;
    [userName resignFirstResponder];
    
    [self.view endEditing:YES];
    
    if ([NetworkError checkNetwork]) {
        
        [self showLoaderWithTitle:@"Updating Profile..."];
        
        if (self.profileModelClass == nil) {
            
            self.profileModelClass = [[Profile alloc] init];
            self.profileModelClass.delegate = self;
        }
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        NSData* imageData = [Common resizeImageData:userProfilePic.image];
        NSString *streamBase64 = [ASIHTTPRequest base64forData:imageData];
        
        NSArray *array = [userName.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

        if (array.count == 1) {
            
            [dict setObject:[array objectAtIndex:0] forKey:@"first_name"];
            [dict setObject:@"" forKey:@"last_name"];
        }
        else if (array.count == 2 || array.count > 2) {
            
            [dict setObject:[array objectAtIndex:0] forKey:@"first_name"];
            [dict setObject:[array objectAtIndex:1] forKey:@"last_name"];
        }
        
        [dict setObject:streamBase64 forKey:@"user_pic"];

        [self.profileModelClass updateProfile:dict];
    }
    else {
        
        [self showAlertViewWithTitle:NSLocalizedString(@"NO_INTERNET_ALERT_TITLE", nil) message:NSLocalizedString(@"NO_INTERNET_ALERT_MESSAGE", nil)];
        
        return;
    }
}

-(IBAction)picEditBtnClicked:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Exiting Photo", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
}

-(IBAction)nameEditBtnClicked:(id)sender {
    
    userName.userInteractionEnabled = YES;
    [userName becomeFirstResponder];
}

#pragma mark - UIActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    if (actionSheet.tag == 0) {
        
        switch (buttonIndex) {
            case 0://Camera Take Photo or Video
                
                if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront|UIImagePickerControllerCameraDeviceRear]){
                    
                    UIImagePickerController *imgPickerController = [[UIImagePickerController alloc] init];
                    imgPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                    //For Video --> //ipc.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie,(NSString *) kUTTypeImage, nil];
                    imgPickerController.allowsEditing = NO;
                    imgPickerController.showsCameraControls = YES;
                    imgPickerController.delegate = self;
                    
                    [self presentViewController:imgPickerController animated:YES completion:nil];
                }
                else{
                    
                    [Common showAlertWithTitle:NSLocalizedString(@"ERROR_ALERT_TITLE", nil) andMessage:NSLocalizedString(@"CAMERA_UNAVAILABLE", nil)];
                }
                
                break;
            case 1: {
                
                if ([UIImagePickerController isSourceTypeAvailable:
                     UIImagePickerControllerSourceTypeSavedPhotosAlbum])
                {
                    UIImagePickerController *imagePicker =
                    [[UIImagePickerController alloc] init];
                    imagePicker.delegate = self;
                    imagePicker.sourceType =
                    UIImagePickerControllerSourceTypePhotoLibrary;
                    imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                              (NSString *) kUTTypeImage,
                                              nil];
                    imagePicker.allowsEditing = NO;
                    [self presentViewController:imagePicker animated:YES completion:nil];
                }
            }
                break;
            default:
                
                break;
        }
    }
}

#pragma mark -
#pragma mark UIImagePicker Methods

-(void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    picker = nil;
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        
        
        userProfilePic.image = [Common resizeImage:image];

        //NSData* imageData = [Common resizeImageData:image];
        //NSString *streamBase64 = [ASIHTTPRequest base64forData:imageData];
        
        image = nil;
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
        
    mediaType = nil;
}

#pragma mark - Animation Methods

-(void)didStartAnimation:(int)withValue {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGRect rect = self.view.frame;
    rect.origin.y = rect.origin.y - withValue;
    self.view.frame = rect;
    [UIView commitAnimations];
}

-(void)didEndAnimation {
    
    //NSLog(@"%f",self.view.frame.origin.y);
    
    if (self.view.frame.origin.y != 64.000000) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

#pragma mark - LoggedInUserProfile Model Class Delegate Methods

-(void)didGetLoggedInUserProfileSuccessfully:(NSMutableDictionary *)responseDict {
    
    NSDictionary *loggedInInfoDict = [Common retriveLoggedInUserInfo];

    NSMutableDictionary *dict = [loggedInInfoDict mutableCopy];
    [dict setValue:[NSString stringWithFormat:@"%@%@", IMAGE_MSG_BASE_URL, [responseDict objectForKey:@"user_pic"]] forKey:@"user_pic"];
    [dict setValue:[responseDict objectForKey:@"first_name"] forKey:@"first_name"];
    [dict setValue:[responseDict objectForKey:@"last_name"] forKey:@"last_name"];

    [Common saveLoggedInUserInfoFromDictionary:dict];

    [userProfilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGE_MSG_BASE_URL, [responseDict objectForKey:@"user_pic"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDER_IMAGE_MSG]];

    userName.text = [NSString stringWithFormat:@"%@ %@", [responseDict objectForKey:@"first_name"], [responseDict objectForKey:@"last_name"]];
    
    [self removeLoader];
}

-(void)didGetLoggedInUserProfileFailed:(ASIHTTPRequest *)therequest {
    
    [self removeLoader];
}

-(void)didUpdateProfileSuccessfully:(NSMutableDictionary *)responseDict {
    
    NSDictionary *loggedInInfoDict = [Common retriveLoggedInUserInfo];
    
    NSMutableDictionary *dict = [loggedInInfoDict mutableCopy];
    [dict setValue:[NSString stringWithFormat:@"%@%@", IMAGE_MSG_BASE_URL, [responseDict objectForKey:@"file_path"]] forKey:@"user_pic"];
    [dict setValue:[responseDict objectForKey:@"first_name"] forKey:@"first_name"];
    [dict setValue:[responseDict objectForKey:@"last_name"] forKey:@"last_name"];
    
    [Common saveLoggedInUserInfoFromDictionary:dict];
    
    [self removeLoader];
}

-(void)didUpdateProfileFailed:(ASIHTTPRequest *)therequest {
    
    [self removeLoader];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self didEndAnimation];

    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self didStartAnimation:160];

    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
