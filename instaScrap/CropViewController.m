//
//  ViewController.m
//  instaScrap
//
//  Created by 山本文子 on 2014/12/10.
//  Copyright (c) 2014年 山本文子. All rights reserved.
//


#import "CropViewController.h"
#import "JBCroppableImageView.h"

@implementation CropViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cropTapped:(id)sender
{
    [self.image crop];
}

- (IBAction)undoTapped:(id)sender
{
    [self.image reverseCrop];
}

- (IBAction)subtractTapped:(id)sender {
    [self.image removePoint];
}

- (IBAction)addTapped:(id)sender {
    [self.image addPoint];
}

@end
