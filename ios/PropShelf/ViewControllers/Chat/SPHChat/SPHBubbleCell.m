//
//  SPHBubbleself.m
//  ChatBubble
//
//  Created by ivmac on 10/2/13.
//  Copyright (c) 2013 Conciergist. All rights reserved.
//

#import "SPHBubbleCell.h"



@implementation SPHBubbleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)SetCellData:(SPHChatData *)feed_data targetedView:(id)ViewControllerObject Atrow:(NSInteger)indexRow;
{
    NSString *messageText = feed_data.messageText;
    CGSize boundingSize = CGSizeMake(messageWidth - 20, 10000000);
    CGRect itemTextSize = [messageText boundingRectWithSize:boundingSize
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica Neue" size:12.0]}
                                             context:nil];
    
    NSString *name = @"Guru";
    
    if ([messageText length] < [name length]) {
        
        itemTextSize = [name boundingRectWithSize:boundingSize
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica Neue" size:12.0]}
                                          context:nil];
    }

    float textHeight = itemTextSize.size.height+7;

    UIImageView *bubbleImage=[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"Bubbletypeleft"] stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
    [self.contentView addSubview:bubbleImage];
    [bubbleImage setFrame:CGRectMake(0,5, itemTextSize.size.width+24, textHeight+30)];
    bubbleImage.tag=56;
    
    NSInteger aRedValue = arc4random()%255;
    NSInteger aGreenValue = arc4random()%255;
    NSInteger aBlueValue = arc4random()%255;
    
    UIColor *randColor = [UIColor colorWithRed:aRedValue/255.0f green:aGreenValue/255.0f blue:aBlueValue/255.0f alpha:1.0f];
    
    UILabel *namelbl=[[UILabel alloc]initWithFrame:CGRectMake(16,5,itemTextSize.size.width+10, 30)];
    [self.contentView addSubview:namelbl];
    namelbl.text = name;
    namelbl.textColor = randColor;
    namelbl.numberOfLines = 1;
    namelbl.textAlignment=NSTextAlignmentJustified;
    namelbl.font=[UIFont fontWithName:@"Helvetica Neue" size:12.0];
    namelbl.backgroundColor=[UIColor clearColor];
    namelbl.tag=indexRow;

    UILabel *messagelbl=[[UILabel alloc]initWithFrame:CGRectMake(16,25,itemTextSize.size.width, textHeight+2)];
    [self.contentView addSubview:messagelbl];
    messagelbl.text = messageText;
    messagelbl.numberOfLines = 0;
    messagelbl.textAlignment=NSTextAlignmentJustified;
    messagelbl.backgroundColor=[UIColor clearColor];
    messagelbl.font=[UIFont fontWithName:@"Helvetica Neue" size:12.0];
    messagelbl.tag=indexRow;
    messagelbl.textColor=[UIColor whiteColor];
    
    messagelbl = nil;
    bubbleImage = nil;
    namelbl = nil;

    /*self.Avatar_Image.layer.cornerRadius = 20.0;
    self.Avatar_Image.layer.masksToBounds = YES;
    self.Avatar_Image.layer.borderColor = [UIColor whiteColor].CGColor;
    self.Avatar_Image.layer.borderWidth = 2.0;
    
    self.Avatar_Image.image=[UIImage imageNamed:@"my_icon"];
    self.time_Label.text=feed_data.messageTime;
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:ViewControllerObject action:@selector(tapRecognized:)];
    [messagelbl addGestureRecognizer:singleFingerTap];
    singleFingerTap.delegate = ViewControllerObject;*/
}

@end
