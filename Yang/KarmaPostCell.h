//
//  KarmaPostCell.h
//  Yang
//
//  Created by Biggie Smallz on 9/24/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KarmaPostCell : UITableViewCell

extern int const cellPadding;
extern int const userImageSize;
extern int const mediaPreviewSize;
extern int const horizontalSpace;
extern int const verticalSpace;
extern int const buttonHeight;

@property (weak, nonatomic) UIImageView *mediaPreview;


@end
