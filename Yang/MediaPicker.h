//
//  MediaPicker.h
//  Yang
//
//  Created by Biggie Smallz on 11/5/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef MEDIA_PICKER
#define MEDIA_PICKER

@protocol MediaPickerDelegate <NSObject>

-(void) didFinishWithVideo:(NSURL *) videoPath;
-(void) didFinishWithImage:(UIImage *) image;

@end

#endif
