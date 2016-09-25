//
//  KarmaPostCell.m
//  Yang
//
//  Created by Biggie Smallz on 9/24/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "KarmaPostCell.h"

@implementation KarmaPostCell

int const cellPadding = 8;
int const userImageSize = 36;
int const mediaPreviewSize = 36;
int const horizontalSpace = 8;
int const verticalSpace = 12;
int const buttonHeight = 44;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        // add in order of top -> bottom, left -> right
        // media object
        
        
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
