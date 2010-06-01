//
//  LROAuth2DemoViewController.m
//  LROAuth2Demo
//
//  Created by Luke Redpath on 01/06/2010.
//  Copyright LJR Software Limited 2010. All rights reserved.
//

#import "LROAuth2DemoViewController.h"	
#import "LROAuth2AccessToken.h"
#import "OAuthRequestController.h"

NSString * AccessTokenSavePath() {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"OAuthAccessToken.cache"];
}

@implementation LROAuth2DemoViewController

@synthesize accessToken;

- (void)viewDidLoad 
{
  [super viewDidLoad];
  
  /*
   * OAuthRequestController will post notifications when it has received/refreshed an access token,
   * we'll use those to keep track of the OAuth authentication process and update the UI 
   */  
  [[NSNotificationCenter defaultCenter] addObserver:self 
      selector:@selector(didReceiveAccessToken:) name:OAuthReceivedAccessTokenNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self 
      selector:@selector(didRefreshAccessToken:) name:OAuthRefreshedAccessTokenNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
  // try and load an existing access token from disk
  self.accessToken = [NSKeyedUnarchiver unarchiveObjectWithFile:AccessTokenSavePath()];

  // check if we have a valid access token before continuing otherwise obtain/refresh a token
  if (self.accessToken == nil) { 
    [self beginAuthorization];
  } else {
    if ([self.accessToken hasExpired]) { 
      //[self refreshAccessToken];
    } else {
      [self loadFacebookFriends];
    }
  }
}

- (void)dealloc 
{
  [accessToken release];
  [super dealloc];
}

- (void)didReceiveAccessToken:(NSNotification *)note;
{
  self.accessToken = (LROAuth2AccessToken *)note.object;
  
  [self dismissModalViewControllerAnimated:YES];
  [self saveAccessTokenToDisk];
  [self loadFacebookFriends];
}

- (void)didRefreshAccessToken:(NSNotification *)note;
{
  self.accessToken = (LROAuth2AccessToken *)note.object;
  
  [self saveAccessTokenToDisk];
  [self loadFacebookFriends];
}

#pragma mark -

- (void)saveAccessTokenToDisk;
{
  [NSKeyedArchiver archiveRootObject:self.accessToken toFile:AccessTokenSavePath()];
}

- (void)beginAuthorization;
{
  if (oauthController == nil) {
    oauthController = [[OAuthRequestController alloc] init];
  }
  [self presentModalViewController:oauthController animated:YES];
  [oauthController release];
}

- (void)refreshAccessToken;
{
  if (oauthController == nil) {
    oauthController = [[OAuthRequestController alloc] init];
  }
  [oauthController refreshAccessToken:self.accessToken];
}

- (void)loadFacebookFriends;
{
  
}

@end
