//
//  LROAuth2DemoAppDelegate.h
//  LROAuth2Demo
//
//  Created by Luke Redpath on 01/06/2010.
//  Copyright LJR Software Limited 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LROAuth2DemoViewController;

@interface LROAuth2DemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    LROAuth2DemoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet LROAuth2DemoViewController *viewController;

@end

