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
#import "ASIHTTPRequest.h"
#import "NSString+QueryString.h"
#import "NSObject+YAJL.h"

NSString * AccessTokenSavePath() {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"OAuthAccessToken.cache"];
}

@implementation LROAuth2DemoViewController

@synthesize accessToken;
@synthesize friends;

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

  // check if we have a valid access token before continuing otherwise obtain a token
  if (self.accessToken == nil) { 
    [self beginAuthorization];
  } else {
    [self loadFacebookFriends];
  }
}

- (void)dealloc 
{
  [friends release];
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
  OAuthRequestController *oauthController = [[OAuthRequestController alloc] init];
  [self presentModalViewController:oauthController animated:YES];
  [oauthController release];
}

- (void)loadFacebookFriends;
{
  NSString *URLString = [NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@", [self.accessToken.accessToken stringByEscapingForURLQuery]];
  NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:URLString]];
  [_data release]; _data = nil;
  _data = [[NSMutableData alloc] init];

  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark -
#pragma mark NSURLConnection methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  
  NSError *jsonError = nil;
  NSDictionary *friendsData = [_data yajl_JSON];
  if (jsonError) {
    NSLog(@"JSON parse error: %@", jsonError);
  } else {
    self.friends = [friendsData valueForKey:@"data"];
    [self.tableView reloadData];
  }
}

#pragma mark -
#pragma mark UITableView methods

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
  if (self.friends == nil) {
    return 0;
  }
  return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *identifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:identifier] autorelease];
  }
  NSDictionary *friend = [self.friends objectAtIndex:indexPath.row];
  cell.textLabel.text = [friend valueForKey:@"name"];
  return cell;
}

@end
