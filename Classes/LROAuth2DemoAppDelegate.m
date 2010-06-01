//
//  LROAuth2DemoAppDelegate.m
//  LROAuth2Demo
//
//  Created by Luke Redpath on 01/06/2010.
//  Copyright LJR Software Limited 2010. All rights reserved.
//

#import "LROAuth2DemoAppDelegate.h"
#import "LROAuth2DemoViewController.h"

@implementation LROAuth2DemoAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
  [window addSubview:viewController.view];
  [window makeKeyAndVisible];

	return YES;
}

- (void)dealloc 
{
  [viewController release];
  [window release];
  [super dealloc];
}

@end
