//
//  ChatViewController.m
//  PropShelf
//
//  Created by Gaurang Patel on 10/14/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import "ChatViewController.h"
#import "SPHChatData.h"
#import "SPHChatData.h"
#import "SPHBubbleCell.h"
#import "SPHBubbleCellImage.h"
#import "SPHBubbleCellImageOther.h"
#import "SPHBubbleCellOther.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomImageViewer.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "CreateGroupViewController.h"
#import "GroupProfileViewController.h"
#import "ProfileViewController.h"
#import "SettingsViewController.h"

@interface ChatViewController () <UIActionSheetDelegate>

@end

@implementation ChatViewController

@synthesize textMsgModelClass;
@synthesize propertyStr;
@synthesize reloads = reloads_;
@synthesize isCameFromWall;
@synthesize Uploadedimage;
@synthesize threadIdStr;
@synthesize isGroup;
@synthesize threadDetailsModelClass;
@synthesize groupId;
@synthesize recipientId, recipientStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    searching = NO;
    
    self.sphChatTable.tableHeaderView = SearchBar;

    chatsArray = [NSMutableArray array];
    
    [self setUpTextFieldforIphone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    UITapGestureRecognizer *touchy = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(tapRecognized:)];
    [self.view addGestureRecognizer:touchy];

    [self setNavigationBarItems];
    
    /*[self buildTextViewFromString:NSLocalizedString(@"I agree to the #<ts>terms of service# and #<pp>privacy policy#",
                                                         @"PLEASE NOTE: please translate \"terms of service\" and \"privacy policy\" as well, and leave the #<ts># and #<pp># around your translations just as in the English version of this message.")];*/
    
    [self getAllChatMessages];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.sphChatTable.backgroundColor = [UIColor clearColor];
    //[self.sphChatTable setContentOffset:CGPointMake(0, 44)];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark setNavigationBarItems Methods

-(void)setNavigationBarItems {

    UIButton *galleryBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [galleryBtn setFrame:CGRectMake(0, 0, 20, 18)];
    [galleryBtn setBackgroundImage:[UIImage imageNamed:@"Media-window"] forState:UIControlStateNormal];
    [galleryBtn addTarget:self action:@selector(uploadImage:) forControlEvents:UIControlEventTouchUpInside];
    galleryBtn.backgroundColor = [UIColor clearColor];
    
    UIButton *whiteDotBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [whiteDotBtn setFrame:CGRectMake(0, 0, 4, 15)];
    [whiteDotBtn setBackgroundImage:[UIImage imageNamed:@"Menu-dots"] forState:UIControlStateNormal];
    [whiteDotBtn addTarget:self action:@selector(menuDotsBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    whiteDotBtn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *imgBtn = [[UIBarButtonItem alloc] initWithCustomView:galleryBtn];
    
    UIBarButtonItem *dotBtn = [[UIBarButtonItem alloc] initWithCustomView:whiteDotBtn];
    
    UIBarButtonItem *bi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    bi.width = 15.0f;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: dotBtn, bi, imgBtn, nil];
    
    UIView *navTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    navTitleView.backgroundColor = [UIColor clearColor];
    
    CGFloat imgXAxis = 0;
    CGFloat lblXAxis = 0;

    if (isCameFromWall == YES) {
        
        imgXAxis = navTitleView.frame.origin.x - 80.0;
        lblXAxis = navTitleView.frame.origin.x - 40.0;
    }
    else {
        
        imgXAxis = navTitleView.frame.origin.x - 42.0;
        lblXAxis = navTitleView.frame.origin.x - 2.0;
    }
    
    UIImage *image = [UIImage imageNamed:@"Group-icon"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    imageView.frame = CGRectMake(imgXAxis, 4, 35, 35);
    [navTitleView addSubview:imageView];
    
    // Customize the title text for *all* UINavigationBars
    UILabel *navTitle = [[UILabel alloc] init];
    navTitle.frame = CGRectMake(lblXAxis, 2, 200, 44);
    navTitle.text = self.propertyStr;
    navTitle.textColor = [UIColor whiteColor];
    navTitle.backgroundColor = [UIColor clearColor];
    navTitle.textAlignment = NSTextAlignmentLeft;
    [navTitleView addSubview:navTitle];
    
    UIButton *transparentBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [transparentBtn setFrame:CGRectMake(lblXAxis, 2, 200, 44)];
    [transparentBtn addTarget:self action:@selector(transparentBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    transparentBtn.backgroundColor = [UIColor clearColor];
    [navTitleView addSubview:transparentBtn];

    self.navigationItem.titleView = navTitleView;
    
    [self.navigationController.navigationBar setNeedsLayout];
}

#pragma mark -
#pragma mark getAllChatMessages Methods

-(void)getAllChatMessages
{
    if ([NetworkError checkNetwork]) {
        
        [self showLoaderWithTitle:@"Loading..."];
        
        if (self.threadDetailsModelClass == nil) {
            
            self.threadDetailsModelClass = [[ThreadDetails alloc] init];
            self.threadDetailsModelClass.delegate = self;
        }
        
        [self.threadDetailsModelClass getThreadDetails:self.threadIdStr];
    }
    else {
        
        [self showAlertViewWithTitle:NSLocalizedString(@"NO_INTERNET_ALERT_TITLE", nil) message:NSLocalizedString(@"NO_INTERNET_ALERT_MESSAGE", nil)];
        
        return;
    }

    /*NSString *rowNumber=[NSString stringWithFormat:@"%d",(int)chatsArray.count];
    [self adddBubbledata:ktextByme mtext:@"Hi!!!!!!!" mtime:nil mimage:Uploadedimage.image msgstatus:kStatusSeding];
    [self performSelector:@selector(messageSent:) withObject:rowNumber afterDelay:1.0];
    [self adddBubbledata:ktextbyother mtext:@"Heloo!!!!!" mtime:nil mimage:Uploadedimage.image msgstatus:kStatusSent];
    rowNumber=[NSString stringWithFormat:@"%d",(int)chatsArray.count];
    [self adddBubbledata:ktextByme mtext:@"How are you doing today?" mtime:nil mimage:Uploadedimage.image msgstatus:kStatusSeding];
    [self performSelector:@selector(messageSent:) withObject:rowNumber afterDelay:1.5];
    [self adddBubbledata:ktextbyother mtext:@"I'm doing great! what abt you?" mtime:nil mimage:Uploadedimage.image msgstatus:kStatusSent];*/
}

-(void)didGetThreadDetailsSuccessfully:(NSMutableArray *)chatArray {
    
    //chatsArray = [chatArray mutableCopy];
    
    NSDictionary *loggedInInfoDict = [Common retriveLoggedInUserInfo];

    NSString *rowNumber = [NSString stringWithFormat:@"%d",(int)chatsArray.count];
    
    for (int i = 0; i < chatArray.count; i++) {
        
        NSMutableDictionary *dict = [chatArray objectAtIndex:i];

        if ([[[dict objectForKey:@"createdBy"] valueForKey:@"id"] isEqualToString:[loggedInInfoDict objectForKey:LOGGED_IN_USER_ID]]) {
            
            if ([[dict objectForKey:@"mimeType"] isEqualToString:TEXT_MSG_TYPE] || [dict objectForKey:@"mimeType"] == nil) {
                
                [self adddBubbledata:ktextByme mtext:[dict objectForKey:@"text"] mtime:nil mimage:Uploadedimage.image msgstatus:kStatusSeding];
                
                [self performSelector:@selector(messageSent:) withObject:rowNumber afterDelay:1.0];
            }
            else {
                
                [self adddBubbledata:ktextByme mtext:[dict objectForKey:@"text"] mtime:nil mimage:Uploadedimage.image msgstatus:kStatusSeding];
            }
        }
        else {
           
            if ([[dict objectForKey:@"mimeType"] isEqualToString:TEXT_MSG_TYPE] || [dict objectForKey:@"mimeType"] == nil) {
                
                [self adddBubbledata:ktextbyother mtext:[dict objectForKey:@"text"] mtime:nil mimage:Uploadedimage.image msgstatus:kStatusSent];
                
                [self performSelector:@selector(messageSent:) withObject:rowNumber afterDelay:1.5];
            }
            else {
                
                [self adddBubbledata:ktextbyother mtext:[dict objectForKey:@"text"] mtime:nil mimage:Uploadedimage.image msgstatus:kStatusSent];
            }
            
            [self messageSent:rowNumber];
        }
    }
    
    [self removeLoader];
}

-(void)didGetThreadDetailsFailed:(ASIHTTPRequest *)therequest {
    
    [self removeLoader];
}

#pragma mark -
#pragma mark setUpTextFieldforIphone Methods

-(void)setUpTextFieldforIphone
{
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-45, self.view.frame.size.width, 45)];
    containerView.backgroundColor = [UIColor clearColor];

    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(47, 3, self.view.frame.size.width - 96, 45)];
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 4;
    textView.returnKeyType = UIReturnKeyDefault; //just as an example
    textView.font = [UIFont systemFontOfSize:15.0f];
    textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:containerView];

    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(47, 0, self.view.frame.size.width - 96, 45);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [containerView addSubview:textView];
    [containerView addSubview:entryImageView];
    
    UIImage *sendBtnBackground = [[UIImage imageNamed:@"send"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    
    UIImage *optionBtnBackground = [[UIImage imageNamed:@"share"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(self.view.frame.size.width - 40, 3, 35, 35);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    [containerView addSubview:doneBtn];
    
    UIButton *doneBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn2.frame = CGRectMake(containerView.frame.origin.x+5,3, 35,35);
    doneBtn2.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    [doneBtn2 addTarget:self action:@selector(customMsgBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn2 setBackgroundImage:optionBtnBackground forState:UIControlStateNormal];
    [containerView addSubview:doneBtn2];
    
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

-(void)resignTextView {
    
    if ([textView.text length] > 0) {
        
        if ([NetworkError checkNetwork]) {
            
            [self showLoaderWithTitle:@"Sending..."];
            
            if (self.textMsgModelClass == nil) {
                
                self.textMsgModelClass = [[TextMsg alloc] init];
                self.textMsgModelClass.delegate = self;
            }
            
            NSMutableArray *idArray = [[NSMutableArray alloc] init];
            NSMutableDictionary *dict = nil;
            
            if (isGroup == YES) {
                
                [idArray addObject:self.groupId];
                
                dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:textView.text, @"text", idArray, @"group", nil];
            }
            else {
                
                [idArray addObject:self.recipientId];
                
                dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:textView.text, @"text", idArray, @"recipients", nil];
            }
            
            [self.textMsgModelClass sendTextMsgRequest:dict];
            
            idArray = nil;
            dict = nil;
        }
        else {
            
            [self showAlertViewWithTitle:NSLocalizedString(@"NO_INTERNET_ALERT_TITLE", nil) message:NSLocalizedString(@"NO_INTERNET_ALERT_MESSAGE", nil)];
            
            return;
        }
    }
    else {
        
        return;
    }
}

-(void)didTextMsgSentSuccessfully:(NSMutableArray *)responseArray {
    
    NSString *chat_Message = textView.text;
    textView.text = @"";
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    
    NSString *rowNumber = [NSString stringWithFormat:@"%d",(int)chatsArray.count];
    
    [self adddBubbledata:ktextByme mtext:chat_Message mtime:[formatter stringFromDate:date] mimage:Uploadedimage.image msgstatus:kStatusSeding];
    
    formatter = nil;
    
    [self performSelector:@selector(messageSent:) withObject:rowNumber afterDelay:2.0];

    [self removeLoader];
}

-(void)didTextMsgSentFailed:(ASIHTTPRequest *)therequest {
    
    [self removeLoader];
}

#pragma mark -
#pragma mark UIButton Action Methods

-(IBAction)messageSent:(id)sender
{
    [self.view endEditing:YES];

    //NSLog(@"row = %@", sender);
    SPHChatData *feed_data = [[SPHChatData alloc]init];
    feed_data = [chatsArray objectAtIndex:[sender intValue]];
    feed_data.messagestatus = @"Sent";
    [chatsArray replaceObjectAtIndex:[sender intValue] withObject:feed_data ];
    
    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:[sender intValue] inSection:0];
    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    [self.sphChatTable reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
    
    feed_data = nil;
    rowsToReload = nil;
}

-(IBAction)uploadImage:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Exiting Photo", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
}

-(IBAction)customMsgBtnTapped:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Create Custom Message", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}

-(IBAction)transparentBtnTapped:(id)sender {
    
    if (isGroup == YES) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"GroupProfileStoryboard" bundle:nil];
        GroupProfileViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"GroupProfile"];
        viewController.propertyStr = self.propertyStr;
        viewController.groupId = [groupId intValue];
        viewController.threadIdStr = self.threadIdStr;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ProfileStoryboard" bundle:nil];
        ProfileViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"Profile"];
        viewController.recepientStr = self.recipientStr;
        viewController.recepientIdStr = self.recipientId;
        viewController.threadIdStr = self.threadIdStr;
        viewController.propertyStr = propertyStr;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

-(IBAction)menuDotsBtnTapped:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"New Group", @"Settings", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
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
                    newMedia = NO;
                }
            }
                break;
            default:
                
                break;
        }
    }
    else {
        
        switch (buttonIndex) {
            case 0: {
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CreateGroupStoryboard" bundle:nil];
                CreateGroupViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"CreateGroup"];
                [self.navigationController pushViewController:viewController animated:YES];
            }
                break;
            case 1: {
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SettingsStoryboard" bundle:nil];
                SettingsViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"Settings"];
                [self.navigationController pushViewController:viewController animated:YES];
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
        
        
        Uploadedimage.image = [Common resizeImage:image];
        
        //NSData* imageData = [Common resizeImageData:image];
        //NSString *streamBase64 = [ASIHTTPRequest base64forData:imageData];
        
        if (newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
        
        image = nil;
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
    
    [self performSelector:@selector(uploadToServer) withObject:nil afterDelay:0.0];
    
    mediaType = nil;
}

-(void)uploadToServer
{
    NSString *chat_Message = textView.text;
    textView.text = @"";
    
    NSString *rowNumber = [NSString stringWithFormat:@"%d",(int)chatsArray.count];
    
    /*if ([NetworkError checkNetwork]) {
        
        [self showLoaderWithTitle:@"Sending..."];
        
        if (self.textMsgModelClass == nil) {
            
            self.textMsgModelClass = [[TextMsg alloc] init];
            self.textMsgModelClass.delegate = self;
        }
        
        NSMutableArray *idArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *dict = nil;
        
        if (isGroup == YES) {
            
            [idArray addObject:self.groupId];
            
            dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:textView.text, @"text", idArray, @"group", nil];
        }
        else {
            
            [idArray addObject:self.recipientId];
            
            dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:textView.text, @"text", idArray, @"recipients", nil];
        }
        
        [self.textMsgModelClass sendTextMsgRequest:dict];
        
        idArray = nil;
        dict = nil;
    }
    else {
        
        [self showAlertViewWithTitle:NSLocalizedString(@"NO_INTERNET_ALERT_TITLE", nil) message:NSLocalizedString(@"NO_INTERNET_ALERT_MESSAGE", nil)];
        
        return;
    }*/
    
    [self adddBubbledata:kImageByme mtext:chat_Message mtime:nil mimage:Uploadedimage.image msgstatus:kStatusSeding];
    
    [self performSelector:@selector(messageSent:) withObject:rowNumber afterDelay:1.0];
}



-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark -
#pragma mark UITableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return chatsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPHChatData *feed_data = [[SPHChatData alloc]init];
    feed_data = [chatsArray objectAtIndex:indexPath.row];
    
    if ([feed_data.messageType isEqualToString:ktextByme])
    {
        float cellHeight;
        // text
        NSString *messageText = feed_data.messageText;
        //
        CGSize boundingSize = CGSizeMake(messageWidth-20, 10000000);
        CGRect itemTextSize = [messageText boundingRectWithSize:boundingSize
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica Neue" size:12.0]}
                                                        context:nil];
        
        // plain text
        cellHeight = itemTextSize.size.height+7;
        
        feed_data = nil;
        
        return cellHeight + 10;
    }
    else if ([feed_data.messageType isEqualToString:ktextbyother])
    {
        float cellHeight;
        // text
        NSString *messageText = feed_data.messageText;
        //
        CGSize boundingSize = CGSizeMake(messageWidth-20, 10000000);
        CGRect itemTextSize = [messageText boundingRectWithSize:boundingSize
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica Neue" size:12.0]}
                                                        context:nil];
        
        // plain text
        cellHeight = itemTextSize.size.height+7;
        
        feed_data = nil;

        return cellHeight + 32;
    }
    else{
        
        feed_data = nil;

        return 130;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.sphChatTable deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    SPHChatData *feed_data = [[SPHChatData alloc]init];
    feed_data = [chatsArray objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier1 = @"Cell1";
    static NSString *CellIdentifier2 = @"Cell2";
    static NSString *CellIdentifier3 = @"Cell3";
    static NSString *CellIdentifier4 = @"Cell4";
    
    if ([feed_data.messageType isEqualToString:ktextByme])
    {
        SPHBubbleCellOther  *cell = (SPHBubbleCellOther *)[self.sphChatTable dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SPHBubbleCellOther" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        [cell SetCellData:feed_data targetedView:self Atrow:indexPath.row];
        //[cell.Avatar_Image setupImageViewer];
        
        return cell;
    }
    
    if ([feed_data.messageType isEqualToString:ktextbyother])
    {
        SPHBubbleCell  *cell = (SPHBubbleCell *)[self.sphChatTable dequeueReusableCellWithIdentifier:CellIdentifier2];
        
        if (cell == nil)
        {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SPHBubbleCell" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        [cell SetCellData:feed_data targetedView:self Atrow:indexPath.row];
        //[cell.Avatar_Image setupImageViewer];
        return cell;
    }
    
    if ([feed_data.messageType isEqualToString:kImageByme])
    {
        SPHBubbleCellImage  *cell = (SPHBubbleCellImage *)[self.sphChatTable dequeueReusableCellWithIdentifier:CellIdentifier3];
        if (cell == nil)
        {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SPHBubbleCellImage" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        //[cell SetCellData:feed_data];
        //[cell.Avatar_Image setupImageViewer];
        cell.message_Image.image=Uploadedimage.image;
        [cell.message_Image setupImageViewer];
        return cell;
    }
    
    SPHBubbleCellImageOther  *cell = (SPHBubbleCellImageOther *)[self.sphChatTable dequeueReusableCellWithIdentifier:CellIdentifier4];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SPHBubbleCellImageOther" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    [cell SetCellData:feed_data];
    //[cell.Avatar_Image setupImageViewer];
    [cell.message_Image setupImageViewer];
    cell.message_Image.image = Uploadedimage.image;
    
    feed_data = nil;
    
    return cell;
}


-(void)adddBubbledata:(NSString*)messageType  mtext:(NSString*)messagetext mtime:(NSString*)messageTime mimage:(UIImage*)messageImage  msgstatus:(NSString*)status;
{
    SPHChatData *feed_data = [[SPHChatData alloc]init];
    feed_data.messageText = messagetext;
    feed_data.messageImageURL = messagetext;
    feed_data.messageImage = messageImage;
    feed_data.messageTime = messageTime;
    feed_data.messageType = messageType;
    feed_data.messagestatus = status;
    
    
    NSArray *insertIndexPaths = [NSArray arrayWithObject:
                                 [NSIndexPath indexPathForRow:
                                  [chatsArray count] // is also 1 now, hooray
                                                    inSection:0]];
    
    [chatsArray addObject:feed_data];
    
    [[self sphChatTable] insertRowsAtIndexPaths:insertIndexPaths
                               withRowAnimation:UITableViewRowAnimationNone];
    
    [self performSelector:@selector(scrollTableview) withObject:nil afterDelay:0.1];
    
    feed_data = nil;
    insertIndexPaths = nil;
}

-(void)adddBubbledataatIndex:(NSInteger)rownum messagetype:(NSString*)messageType  mtext:(NSString*)messagetext mtime:(NSString*)messageTime mimage:(UIImage*)messageImage  msgstatus:(NSString*)status;
{
    SPHChatData *feed_data=[[SPHChatData alloc]init];
    feed_data.messageText=messagetext;
    feed_data.messageImageURL=messagetext;
    feed_data.messageImage=messageImage;
    feed_data.messageTime=messageTime;
    feed_data.messageType=messageType;
    feed_data.messagestatus=status;
    [chatsArray  replaceObjectAtIndex:rownum withObject:feed_data];
    
    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:rownum inSection:0];
    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    
    [self.sphChatTable reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
    
    [self performSelector:@selector(scrollTableview) withObject:nil afterDelay:0.1];
    
    feed_data = nil;
    rowsToReload = nil;
}

-(void)tapRecognized:(UITapGestureRecognizer *)tapGR {
    
    [self.view endEditing:YES];
}

-(IBAction)bookmarkClicked:(id)sender
{
    NSLog( @"Book mark clicked at row : %d",selectedRow);
}

#pragma mark -
#pragma mark Keyboard related methods

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

-(void)scrollTableview
{
    if (chatsArray.count < 3)
        return;
    
    NSInteger lastSection = [self.sphChatTable numberOfSections] - 1;
    NSInteger lastRowNumber = [self.sphChatTable numberOfRowsInSection:lastSection] - 1;
    NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:lastSection];
    [self.sphChatTable scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void) keyboardWillShow:(NSNotification *)note
{
    if (chatsArray.count > 2)
        [self performSelector:@selector(scrollTableview) withObject:nil afterDelay:0.0];
    
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    
    /*CGRect tableviewframe = self.sphChatTable.frame;
    tableviewframe.size.height -= 160;*/
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    containerView.frame = containerFrame;
    //self.sphChatTable.frame = tableviewframe;
    
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note
{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    /*CGRect tableviewframe = self.sphChatTable.frame;
    tableviewframe.size.height += 160;*/
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    // set views with new info
    //self.sphChatTable.frame = tableviewframe;
    containerView.frame = containerFrame;
    // commit animations
    [UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    containerView.frame = r;
}

#pragma mark -
#pragma mark Search Bar

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    SearchBar.showsCancelButton = YES;
    
    return YES;
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
    //Remove all objects first.
    if ([filterArray count] > 0) {
        [filterArray removeAllObjects];
        filterArray = nil;
    }
    
    filterArray = [[NSMutableArray alloc] init];
    
    if([searchText length] > 0) {
        searching = YES;
        
        [self searchTableView];
    }
    else {
        searching = NO;
        
        [self.sphChatTable reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [SearchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    
    searching = NO;
    
    SearchBar.showsCancelButton = NO;
    
    // Make the keyboard go away.
    [SearchBar resignFirstResponder];
    
    //Remove all objects first.
    if ([filterArray count] > 0) {
        [filterArray removeAllObjects];
        filterArray = nil;
    }
    
    SearchBar.text = @"";
    
    [self.sphChatTable reloadData];
}

- (void) searchTableView {
    
    //NSString *searchText = SearchBar.text;
    
    [self.sphChatTable reloadData];
}

- (void)buildTextViewFromString:(NSString *)localizedString
{
    // 1. Split the localized string on the # sign:
    NSArray *localizedStringPieces = [localizedString componentsSeparatedByString:@"#"];
    
    // 2. Loop through all the pieces:
    NSUInteger msgChunkCount = localizedStringPieces ? localizedStringPieces.count : 0;
    CGPoint wordLocation = CGPointMake(0.0, 0.0);
    
    for (NSUInteger i = 0; i < msgChunkCount; i++)
    {
        NSString *chunk = [localizedStringPieces objectAtIndex:i];
        if ([chunk isEqualToString:@""])
        {
            continue;     // skip this loop if the chunk is empty
        }
        
        // 3. Determine what type of word this is:
        BOOL isTermsOfServiceLink = [chunk hasPrefix:@"<ts>"];
        BOOL isPrivacyPolicyLink  = [chunk hasPrefix:@"<pp>"];
        BOOL isLink = (BOOL)(isTermsOfServiceLink || isPrivacyPolicyLink);
        
        // 4. Create label, styling dependent on whether it's a link:
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:15.0f];
        label.text = chunk;
        label.userInteractionEnabled = isLink;
        
        if (isLink)
        {
            label.textColor = [UIColor colorWithRed:110/255.0f green:181/255.0f blue:229/255.0f alpha:1.0];
            label.highlightedTextColor = [UIColor yellowColor];
            
            // 5. Set tap gesture for this clickable text:
            SEL selectorAction = isTermsOfServiceLink ? @selector(tapOnTermsOfServiceLink:) : @selector(tapOnPrivacyPolicyLink:);
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:selectorAction];
            [label addGestureRecognizer:tapGesture];
            
            // Trim the markup characters from the label:
            if (isTermsOfServiceLink)
                label.text = [label.text stringByReplacingOccurrencesOfString:@"<ts>" withString:@""];
            if (isPrivacyPolicyLink)
                label.text = [label.text stringByReplacingOccurrencesOfString:@"<pp>" withString:@""];
        }
        else
        {
            label.textColor = [UIColor blackColor];
        }
        
        // 6. Lay out the labels so it forms a complete sentence again:
        
        // If this word doesn't fit at end of this line, then move it to the next
        // line and make sure any leading spaces are stripped off so it aligns nicely:
        
        [label sizeToFit];
        
        if (innerPopUpView.frame.size.width < wordLocation.x + label.bounds.size.width)
        {
            wordLocation.x = 0.0;                       // move this word all the way to the left...
            wordLocation.y += label.frame.size.height;  // ...on the next line
            
            // And trim of any leading white space:
            NSRange startingWhiteSpaceRange = [label.text rangeOfString:@"^\\s*"
                                                                options:NSRegularExpressionSearch];
            if (startingWhiteSpaceRange.location == 0)
            {
                label.text = [label.text stringByReplacingCharactersInRange:startingWhiteSpaceRange
                                                                 withString:@""];
                [label sizeToFit];
            }
        }
        
        // Set the location for this label:
        label.frame = CGRectMake(wordLocation.x + 10,
                                 wordLocation.y + 10,
                                 label.frame.size.width,
                                 label.frame.size.height);
        // Show this label:
        [innerPopUpView addSubview:label];
        
        // Update the horizontal position for the next word:
        wordLocation.x += label.frame.size.width;
        
        /*NSLog(@"frame x: %f", label.frame.origin.x);
        NSLog(@"frame y: %f", label.frame.origin.y);

        NSLog(@"--------------------------");*/
    }
}

- (void)tapOnTermsOfServiceLink:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"User tapped on the Terms of Service link");
    }
}


- (void)tapOnPrivacyPolicyLink:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"User tapped on the Privacy Policy link");
    }
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
