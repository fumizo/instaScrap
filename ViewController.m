//
//  CropViewController.m
//  instaScrap
//
//  Created by 山本文子 on 2014/12/23.
//  Copyright (c) 2014年 山本文子. All rights reserved.
//

#import "ViewController.h"

#import "APIManager.h"
#import "UserDataManager.h"

#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SimpleAuth.h>
#import "SVProgressHUD.h"

#define NUMBER_OF_PHOTOS @"20"


@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *allObjects;
    NSArray *photoURLArray;
    NSArray *userNameArray;
    NSArray *createdTimeArray;
    NSArray *profileURLArray;
    NSArray *numberOfLikeArray;
    NSArray *idArray;
    
    IBOutlet UITableView *homeTableView;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    homeTableView.dataSource = self;
    homeTableView.delegate = self;
    homeTableView.allowsMultipleSelection = YES;
    
    SimpleAuth.configuration[@"instagram"] = @{@"client_id":CLIENT_ID, SimpleAuthRedirectURIKey:REDIRECT_URI};
    
    [self showInstagramPhotos];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    //reload account data
    [super viewWillAppear:animated];
}
- (void)showInstagramPhotos {
    
    if (![SVProgressHUD isVisible]) {
        [SVProgressHUD showWithStatus:@"読み込み中..." maskType:SVProgressHUDMaskTypeBlack];
    }
    
    
    if ([UserDataManager sharedManager].token) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:@"https://api.instagram.com/v1/users/self/feed" parameters:@{@"access_token":[UserDataManager sharedManager].token, @"count":NUMBER_OF_PHOTOS} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            allObjects = [responseObject valueForKey:@"data"];
            
            photoURLArray = [responseObject valueForKeyPath:@"data.images.standard_resolution.url"];
            userNameArray = [responseObject valueForKeyPath:@"data.caption.from.full_name"];
            createdTimeArray = [responseObject valueForKeyPath:@"data.caption.created_time"];
            profileURLArray = [responseObject valueForKeyPath:@"data.caption.from.profile_picture"];
            numberOfLikeArray = [responseObject valueForKeyPath:@"data.likes.count"];
            idArray = [responseObject valueForKeyPath:@"data.id"];
            
            if ([SVProgressHUD isVisible]) {
                [SVProgressHUD dismiss];
            }
            
            [homeTableView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
    } else {
        [self loginWithInstagram];
    }
}

- (void)loginWithInstagram{
    [SimpleAuth authorize:@"instagram" completion:^(id responseObject, NSError *error) {
        [UserDataManager sharedManager].token = [responseObject valueForKeyPath:@"credentials.token"];
        [UserDataManager sharedManager].userName = [responseObject valueForKeyPath:@"extra.raw_info.data.username"];
        [UserDataManager sharedManager].fullName = [responseObject valueForKeyPath:@"extra.raw_info.data.full_name"];
        [UserDataManager sharedManager].userID = [responseObject valueForKeyPath:@"extra.raw_info.data.id"];
        [UserDataManager sharedManager].profileImageURL = [responseObject valueForKeyPath:@"extra.raw_info.data.profile_picture"];
        [UserDataManager sharedManager].bio = [responseObject valueForKeyPath:@"extra.raw_info.data.bio"];
        [UserDataManager sharedManager].followed = [responseObject valueForKeyPath:@"extra.raw_info.data.counts.followed_by"];
        [UserDataManager sharedManager].following = [responseObject valueForKeyPath:@"extra.raw_info.data.counts.follows"];
        [UserDataManager sharedManager].numberOfPosts = [responseObject valueForKeyPath:@"extra.raw_info.data.counts.media"];
        
        [self showInstagramPhotos];
    }];
}


- (IBAction)logOut
{
    [self invalidateSession];
    
    NSURL *url = [NSURL URLWithString:@"https://instagram.com/"];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSEnumerator *enumerator = [[cookieStorage cookiesForURL:url] objectEnumerator];
    NSHTTPCookie *cookie = nil;
    while ((cookie = [enumerator nextObject])) {
        [cookieStorage deleteCookie:cookie];
    }
    
    SimpleAuth.configuration[@"instagram"] = @{@"client_id":CLIENT_ID, SimpleAuthRedirectURIKey:REDIRECT_URI};
    [self loginWithInstagram];
}

-(void)invalidateSession {
    [UserDataManager sharedManager].token = nil;
    
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *instagramCookies = [cookies cookiesForURL:[NSURL URLWithString:@"https://instagram.com/"]];
    
    for (NSHTTPCookie* cookie in instagramCookies) {
        [cookies deleteCookie:cookie];
    }
}


@end
