//
//  CameraNAV.m
//  Yang
//
//  Created by Biggie Smallz on 2/4/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "CameraNAV.h"

@interface CameraNAV ()

@end

@implementation CameraNAV

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBarHidden = YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end