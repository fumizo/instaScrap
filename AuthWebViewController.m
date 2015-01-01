//
//  AuthWebViewController.m
//  instaScrap
//
//  Created by 山本文子 on 2014/12/23.
//  Copyright (c) 2014年 山本文子. All rights reserved.
//


/*   =========simple oauthを使うからwebviewのメソッドはいらないかなっていう==========


#import "AuthWebViewController.h"
#import "AppDelegate.h"


@interface AuthWebViewController ()

@property (strong, nonatomic) id successObserver;
@property (strong, nonatomic) id failObserver;

@end

@implementation AuthWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _webView.delegate = self;
    
    //init notifications
    [self p_addOauth2Notification];
    [self p_startRequest];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    //hide network activity indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //remove notifications
    [self p_removeOauth2Notification];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)p_addOauth2Notification {
    //setup notifications for success or fail
    //for success
    self.successObserver = [[NSNotificationCenter defaultCenter]
                            addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification
                            object:[NXOAuth2AccountStore sharedStore]
                            queue:nil usingBlock:^(NSNotification *notification) {
                                //TODO
                                NSLog(@"Success.");
                                
                                //get authinticate userinfo
                                NSDictionary *dict = notification.userInfo;
                                NXOAuth2Account *account = [dict valueForKey:NXOAuth2AccountStoreNewAccountUserInfoKey];
                                NSLog(@"account=%@",account);
                                
                                //pop navigation controller
                                [self.navigationController popViewControllerAnimated:YES];
                            }];
    
    //for fail
    self.failObserver = [[NSNotificationCenter defaultCenter]
                         addObserverForName:NXOAuth2AccountStoreDidFailToRequestAccessNotification
                         object:[NXOAuth2AccountStore sharedStore]
                         queue:nil
                         usingBlock:^(NSNotification *note) {
                             //TODO
                             NSLog(@"Fail.");
                             
                             //TODO error message.
                             
                             //pop navigation controller
                             [self.navigationController popViewControllerAnimated:YES];
                             
                         }];
    
}

- (void)p_startRequest {
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:kOauth2ClientAccountType
                                   withPreparedAuthorizationURLHandler:^(NSURL *preparedURL) {
                                       //start authentication request.
                                       [_webView loadRequest:[NSURLRequest requestWithURL:preparedURL]];
                                       
                                   }];
}

- (void) p_removeOauth2Notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self.successObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.failObserver];
}

#pragma mark - UIWebViewDelegate

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[NXOAuth2AccountStore sharedStore] handleRedirectURL:[request URL]]) {
        return NO;
    }
    return YES;
}

- (void) webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
 
 
*/
