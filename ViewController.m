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
#import "NextViewController.h"

#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SimpleAuth.h>
#import "SVProgressHUD.h"

#define NUMBER_OF_PHOTOS @"99"
/*============やること================
 今上限まで取り込んでるけど、少ないから、メディアidをユーザーデフォルトに保存とかしたらええんとちゃうのかいな
 限界まで読み込んでるのにずっとfor文回しちゃってるから、0になったらやめるっていうのをかくの
 */

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSArray *photoURLArray; //utableなら追加が可能
    IBOutlet UICollectionView *popularCollectionView;
    NSString *lastPhotoID;
    BOOL isLoading;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    popularCollectionView.dataSource = self;
    popularCollectionView.delegate = self;
    
    SimpleAuth.configuration[@"instagram"] = @{@"client_id":CLIENT_ID, SimpleAuthRedirectURIKey:REDIRECT_URI};
    
    [self showInstagramPhotos];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.tabBarController.tabBar.hidden == YES) {
        self.tabBarController.tabBar.hidden = NO;
    }
}

- (void)showInstagramPhotos:(NSString *)max_like_id
                    atonankai:(int) atonankai{
    NSLog(@"最初のcolle height%f", colle.contentSize.height);
    
    if (![SVProgressHUD isVisible]) {
        [SVProgressHUD showWithStatus:@"読み込み中..." maskType:SVProgressHUDMaskTypeBlack];
    }
    
    
    if ([UserDataManager sharedManager].token) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSLog(@"token::%@", [UserDataManager sharedManager].token);
        [manager GET:@"https://api.instagram.com/v1/users/self/media/liked" parameters:@{@"access_token":[UserDataManager sharedManager].token, @"count":NUMBER_OF_PHOTOS,@"max_like_id":max_like_id} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //34枚目以降から33枚もってくる
            
            NSArray *res = [responseObject valueForKeyPath:@"data.images.thumbnail.url"];
            NSLog(@"res=%@",res);
            NSLog(@"photoarray=%@",photoURLArray);
            photoURLArray = [photoURLArray arrayByAddingObjectsFromArray:res]; //photourlarryに足したものをphotourlarrayにする
//            for(NSString *str in res){
//                [photoURLArray addObject:str];
//            }
            NSLog(@"追加photoarray=%@",photoURLArray);

            if ([SVProgressHUD isVisible]) {
                [SVProgressHUD dismiss];
            }
//            NSLog(@"画像枚数: %lu", (unsigned long)photoURLArray.count);
//            NSLog(@"画像: %@", photoURLArray);
//            //            NSLog(@"内容: %@", responseObject);
//            NSLog(@"メディアID: %@",[responseObject valueForKeyPath:@"id"]);
//            NSLog(@"%@", [responseObject valueForKeyPath:@"data.id"]);
            NSArray *arr = [responseObject valueForKeyPath:@"data.id"];
//            NSLog(@"最後のid%@", arr[arr.count -1]);
            
            [popularCollectionView reloadData];
            if (atonankai>0) {
                //atonankaiが0よりお大きかったら自分自信をもう一度まわす、atonankaiを1つ減らす
                [self showInstagramPhotos:arr[arr.count -1] atonankai:atonankai-1]; //最後のメディアidをこの関数に受け渡す
            }else{
                isLoading = NO;
//                [self makeReloadButton];
                if (arr.count != 0) {
                    lastPhotoID = arr[arr.count -1];
                }
                NSLog(@"lastPhotoID is ..........%@",lastPhotoID);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
    } else {
        [self loginWithInstagram];
    }
    
    //collection viewの高さを知る
    NSLog(@"colle height%f", colle.contentSize.height);
}


- (void)showInstagramPhotos {
    
    if (![SVProgressHUD isVisible]) {
        [SVProgressHUD showWithStatus:@"読み込み中..." maskType:SVProgressHUDMaskTypeBlack];
    }

    if ([UserDataManager sharedManager].token) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSLog(@"token::%@", [UserDataManager sharedManager].token);
        [manager GET:@"https://api.instagram.com/v1/users/self/media/liked" parameters:@{@"access_token":[UserDataManager sharedManager].token, @"count":NUMBER_OF_PHOTOS} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            photoURLArray = [responseObject valueForKeyPath:@"data.images.thumbnail.url"];
            
            if ([SVProgressHUD isVisible]) {
                [SVProgressHUD dismiss];
            }
            NSLog(@"画像枚数: %lu", (unsigned long)photoURLArray.count);
            NSLog(@"画像: %@", photoURLArray);
//            NSLog(@"内容: %@", responseObject);
            NSLog(@"メディアID: %@",[responseObject valueForKeyPath:@"id"]);
            NSLog(@"%@", [responseObject valueForKeyPath:@"data.id"]);
            NSArray *arr = [responseObject valueForKeyPath:@"data.id"];
            NSLog(@"最後のid%@", arr[arr.count -1]);
            [self showInstagramPhotos:arr[arr.count -1] atonankai:3]; //最後のメディアidをこの関数に受け渡す
                                                                      //atonankaiの数だけまわす

            [popularCollectionView reloadData];
            
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


//スクロールしていってリロードする
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (colle.contentSize.height - [UIScreen mainScreen].bounds.size.height - 50.0 < scrollView.contentOffset.y) {
        
        if (!isLoading) {
            isLoading = YES;
            //スクロールして行ってリロードする。50は、ギリギリすぎるとダメだから
            [self showInstagramPhotos:lastPhotoID atonankai:2]; //最後のidをこの関数に受け渡す
        }
        
    }
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

#pragma mark - CollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return photoURLArray.count;
}

//Method to create cell at index path
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    
    //MARK:Thumbnail
    UIImageView *photoImageView = (UIImageView *)[cell viewWithTag:2];
    
    NSLog(@"%@", photoURLArray[indexPath.item]);
    NSURL *url = [NSURL URLWithString:photoURLArray[indexPath.item]];
    
    
    [photoImageView sd_setImageWithURL:url];
    
//    [photoImageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    
//    }];
    
//    [photoImageView sd_setImageWithURL:url
//                      placeholderImage:[UIImage imageNamed:@"placeholder@2x.png"]
//                               options:SDWebImageCacheMemoryOnly
//                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                 
//                                 UIApplication *application = [UIApplication sharedApplication];
//                                 application.networkActivityIndicatorVisible = NO;
//                                 
//                                 if (cacheType != SDImageCacheTypeMemory) {
//                                     
//                                     //Fade Animation
//                                     [UIView transitionWithView:photoImageView
//                                                       duration:0.3f
//                                                        options:UIViewAnimationOptionTransitionCrossDissolve
//                                                     animations:^{
//                                                         photoImageView.image = image;
//                                                     } completion:nil];
//                                     
//                                 }
//                             }];
    
    [photoImageView sd_setImageWithURL:photoURLArray[indexPath.row]
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
                             }];
    
    return cell;
}

#pragma mark - CollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tapped cell is == %d-%d",(int)indexPath.section, (int)indexPath.row);
    //画像をタップしたときのやつはここ
    
    photoNum = photoURLArray[indexPath.item];  //何番目をタップしたか
    
    NextViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"next"];
    [self.navigationController pushViewController:vc animated:YES];

}


@end
