//
//  CropViewController.h
//  instaScrap
//
//  Created by 山本文子 on 2014/12/23.
//  Copyright (c) 2014年 山本文子. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NXOauth2.h"
#import "objc/message.h"
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController : UIViewController<UITableViewDataSource,SDWebImageManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *authTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
- (IBAction)editAction:(id)sender;
- (IBAction)getInfomation:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;



@end
