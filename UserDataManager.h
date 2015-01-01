//
//  UserDataManager.h
//  instaScrap
//
//  Created by 山本文子 on 2015/01/02.
//  Copyright (c) 2015年 山本文子. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataManager : NSObject

@property (nonatomic)NSString *token;
@property (nonatomic)NSString *fullName;
@property (nonatomic)NSString *userName;
@property (nonatomic)NSString *userID;
@property (nonatomic)NSString *bio;
@property (nonatomic)NSString *profileImageURL;
@property (nonatomic)NSString *followed;
@property (nonatomic)NSString *following;
@property (nonatomic)NSString *numberOfPosts;


+ (UserDataManager *)sharedManager;


@end
