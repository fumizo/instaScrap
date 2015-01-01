//
//  UserDataManager.m
//  instaScrap
//
//  Created by 山本文子 on 2015/01/02.
//  Copyright (c) 2015年 山本文子. All rights reserved.
//

#import "UserDataManager.h"

@implementation UserDataManager

static UserDataManager *sharedData = nil;

- (id)init
{
    self = [super init];
    if (self) {
        //Initialization
        _token           = nil;
        _fullName        = nil;
        _userID          = nil;
        _bio             = nil;
        _profileImageURL = nil;
        _followed        = nil;
        _following       = nil;
        _numberOfPosts   = nil;
        
    }
    return self;
}

+ (UserDataManager *)sharedManager{
    if (!sharedData) {
        sharedData = [UserDataManager new];
    }
    return sharedData;
}


@end
