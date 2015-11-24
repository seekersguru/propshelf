//
//  SPHBubbleCellImageOther.m
//  ChatBubble
//
//  Created by ivmac on 10/2/13.
//  Copyright (c) 2013 Conciergist. All rights reserved.
//

#import "SPHBubbleCellImageOther.h"

@implementation SPHBubbleCellImageOther

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

-(void)SetCellData:(SPHChatData *)feed_data
{
    NSString *name = @"Gaurang";
    CGSize boundingSize = CGSizeMake(messageWidth - 20, 10000000);
    CGRect itemTextSize = [name boundingRectWithSize:boundingSize
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica Neue" size:12.0]}
                                                    context:nil];    
    self.Buble_image.tag=56;

    if (itemTextSize.size.width > 100) {
        
        [self.Buble_image setFrame:CGRectMake(0, 5, itemTextSize.size.width + 25, self.Buble_image.frame.size.height)];
    }
    
    NSInteger aRedValue = arc4random()%255;
    NSInteger aGreenValue = arc4random()%255;
    NSInteger aBlueValue = arc4random()%255;
    
    UIColor *randColor = [UIColor colorWithRed:aRedValue/255.0f green:aGreenValue/255.0f blue:aBlueValue/255.0f alpha:1.0f];
    
    self.userName_Label.frame = CGRectMake(16,2,itemTextSize.size.width+10, 30);
    self.userName_Label.text = name;
    self.userName_Label.textColor = randColor;
    self.userName_Label.numberOfLines = 1;
    self.userName_Label.textAlignment=NSTextAlignmentJustified;
    self.userName_Label.font=[UIFont fontWithName:@"Helvetica Neue" size:12.0];
    self.userName_Label.backgroundColor=[UIColor clearColor];

    /*self.Avatar_Image.layer.cornerRadius = 20.0;
    self.Avatar_Image.layer.masksToBounds = YES;
    self.Avatar_Image.layer.borderColor = [UIColor whiteColor].CGColor;
    self.Avatar_Image.layer.borderWidth = 2.0;
    self.Avatar_Image.image=[UIImage imageNamed:@"my_icon"];
    self.time_Label.text=feed_data.messageTime;
    self.selectionStyle=UITableViewCellSelectionStyleNone;*/
}

@end