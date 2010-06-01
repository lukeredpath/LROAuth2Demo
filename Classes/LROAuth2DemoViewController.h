//
//  LROAuth2DemoViewController.h
//  LROAuth2Demo
//
//  Created by Luke Redpath on 01/06/2010.
//  Copyright LJR Software Limited 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LROAuth2AccessToken;
@class OAuthRequestController;

@interface LROAuth2DemoViewController : UITableViewController {
  LROAuth2AccessToken *accessToken;
  OAuthRequestController *oauthController;
}
@property (nonatomic, retain) LROAuth2AccessToken *accessToken;

- (void)saveAccessTokenToDisk;
- (void)beginAuthorization;
- (void)refreshAccessToken;
- (void)loadFacebookFriends;
@end

