//
//  ViewController.h
//  instaScrap
//
//  Created by 山本文子 on 2014/12/10.
//  Copyright (c) 2014年 山本文子. All rights reserved.
//


#import <UIKit/UIKit.h>

@class JBCroppableImageView;
@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *cropButton;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak, nonatomic) IBOutlet JBCroppableImageView  *image;

- (IBAction)cropTapped:(id)sender;
- (IBAction)undoTapped:(id)sender;
- (IBAction)subtractTapped:(id)sender;
- (IBAction)addTapped:(id)sender;

@end
