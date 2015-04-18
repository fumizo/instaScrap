//
//  NextViewController.m
//  instaScrap
//
//  Created by 山本文子 on 2015/03/14.
//  Copyright (c) 2015年 山本文子. All rights reserved.
//

#import "NextViewController.h"

@implementation NextViewController

@synthesize selectPhotoNum;

-(void)viewDidLoad{
    
    /*tableView*/
    likeTableView.dataSource = self;
    likeTableView.delegate = self;
    likeTableView.allowsMultipleSelection = YES;
 
}

-(void)viewWillAppear:(BOOL)animated{
    
    if (self.tabBarController.tabBar.hidden == YES) {
        self.tabBarController.tabBar.hidden = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    UIImageView *photoImageView = (UIImageView *)[cell viewWithTag:2];
    
    /*
    NSString* string = @"/Users/abt/Documents/日本語のフォルダ名/file.txt";
    NSURL* url = [NSURL fileURLWithPath:string];
     */
    
    NSURL *photoURL = [NSURL URLWithString:selectPhotoNum];
    
    [photoImageView sd_setImageWithURL:photoURL
                      placeholderImage:[UIImage imageNamed:@"placeholder@2x.png"]
                               options:SDWebImageCacheMemoryOnly
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 
                                 UIApplication *application = [UIApplication sharedApplication];
                                 application.networkActivityIndicatorVisible = NO;
                                 
                                 if (cacheType != SDImageCacheTypeMemory) {
                                     
                                     //Fade Animation
                                     [UIView transitionWithView:photoImageView
                                                       duration:0.3f
                                                        options:UIViewAnimationOptionTransitionCrossDissolve
                                                     animations:^{
                                                         photoImageView.image = image;
                                                     } completion:nil];
                                 }
                             }
     ];
    return cell;
}

@end
