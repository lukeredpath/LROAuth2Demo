//
//  OAuthRequestController.m
//  LROAuth2Demo
//
//  Created by Luke Redpath on 01/06/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "OAuthRequestController.h"
#import "LROAuth2Client.h"

/*
 * you will need to create this from OAuthCredentials-Example.h
 *
 */
#import "OAuthCredentials.h" 

NSString *const OAuthReceivedAccessTokenNotification  = @"OAuthReceivedAccessTokenNotification";
NSString *const OAuthRefreshedAccessTokenNotification = @"OAuthRefreshedAccessTokenNotification";

@implementation OAuthRequestController

@synthesize webView;

- (id)init;
{
  if (self = [super initWithNibName:@"OAuthRequestController" bundle:nil]) {
    oauthClient = [[LROAuth2Client alloc] initWithClientID:kOAuthClientID 
      secret:kOAuthClientSecret redirectURL:[NSURL URLWithString:kOAuthClientAuthURL]];

    oauthClient.debug = YES;
    oauthClient.delegate = self;    
    oauthClient.userURL  = [NSURL URLWithString:@"https://graph.facebook.com/oauth/authorize"];
    oauthClient.tokenURL = [NSURL URLWithString:@"https://graph.facebook.com/oauth/access_token"];
    
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.modalTransitionStyle   = UIModalTransitionStyleCrossDissolve;
  }
  return self;
}

- (void)viewDidUnload 
{
 [super viewDidUnload];
  self.webView = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
  [oauthClient authorizeUsingWebView:self.webView];
}

- (void)dealloc 
{
  oauthClient.delegate = nil;
  webView.delegate = nil;
  
  [webView release];
  [oauthClient release];
  [super dealloc];
}

- (void)refreshAccessToken:(LROAuth2AccessToken *)accessToken
{
  [oauthClient refreshAccessToken:accessToken];
}

#pragma mark -
#pragma mark LROAuth2ClientDelegate methods

- (void)oauthClientDidReceiveAccessToken:(LROAuth2Client *)client
{
  [[NSNotificationCenter defaultCenter] postNotificationName:OAuthReceivedAccessTokenNotification object:client.accessToken];
}

- (void)oauthClientDidRefreshAccessToken:(LROAuth2Client *)client
{
  [[NSNotificationCenter defaultCenter] postNotificationName:OAuthRefreshedAccessTokenNotification object:client.accessToken];
}

@end
