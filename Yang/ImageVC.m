//
//  ImageVC.m
//  Yang
//
//  Created by Biggie Smallz on 10/23/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "ImageVC.h"

@interface ImageVC ()

@end

@implementation ImageVC

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        _image = image;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.backgroundColor = [UIColor blackColor];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.image = self.image;
    [self.view addSubview:self.imageView];
    
    NSString *info = [NSString stringWithFormat:@"Size: %@  -  Orientation: %ld", NSStringFromCGSize(self.image.size), (long)self.image.imageOrientation];

    NSLog(@"%@", info);
    
    [self.view addSubview:self.cancelButton];
    [self.cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton.frame = CGRectMake(0, 0, 44, 44);

    [self.view addSubview:self.acceptButton];
    [self.acceptButton addTarget:self action:@selector(acceptButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.acceptButton.frame = CGRectMake(self.view.frame.size.width - 44, 0, 44, 44);

}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.imageView.frame = self.view.contentBounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (UIButton *)cancelButton {
    if(!_cancelButton) {
        UIImage *cancelImage = [UIImage imageNamed:@"cancel.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tintColor = [UIColor redColor];
        [button setImage:cancelImage forState:UIControlStateNormal];
        button.imageView.clipsToBounds = NO;
        button.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        button.layer.shadowColor = [UIColor blackColor].CGColor;
        button.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        button.layer.shadowOpacity = 0.4f;
        button.layer.shadowRadius = 1.0f;
        button.clipsToBounds = NO;
        
        _cancelButton = button;
    }
    
    return _cancelButton;
}

- (void)cancelButtonPressed:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UIButton *)acceptButton {
    if(!_acceptButton) {
        UIImage *acceptImage = [UIImage imageNamed:@"check.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tintColor = [UIColor greenColor];
        [button setImage:acceptImage forState:UIControlStateNormal];
        button.imageView.clipsToBounds = NO;
        button.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        button.layer.shadowColor = [UIColor blackColor].CGColor;
        button.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        button.layer.shadowOpacity = 0.4f;
        button.layer.shadowRadius = 1.0f;
        button.clipsToBounds = NO;
        
        _acceptButton = button;
    }
    
    return _acceptButton;
}

- (void)acceptButtonPressed:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(didFinishWithImage:)]) {
        [_delegate didFinishWithImage:self.image];
    }
}

@end
