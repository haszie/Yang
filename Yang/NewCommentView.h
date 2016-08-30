//
//  PAPPhotoDetailsFooterView.h
//  Anypic
//
//  Created by Mattieu Gamache-Asselin on 5/16/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface NewCommentView : UIView

@property (nonatomic, strong) UITextField *commentField;
@property (nonatomic, strong) UIImageView *user_avatar;

-(void) set_user_pic: (NSString *) stringURL;

@end
