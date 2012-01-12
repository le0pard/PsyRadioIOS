//
//  PsyRadioAppDelegate.m
//  PsyRadio
//
//  Created by Alex on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PsyRadioAppDelegate.h"
#import "Radio.h"
#import "PsyRadioViewController.h"

@implementation PsyRadioAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize radio = _radio;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [_radio release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[[PsyRadioViewController alloc] initWithNibName:@"PsyRadioViewController_iPhone" bundle:nil] autorelease];
    } else {
        self.viewController = [[[PsyRadioViewController alloc] initWithNibName:@"PsyRadioViewController_iPad" bundle:nil] autorelease];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    // radio
    radio = [[Radio alloc] init];
	[radio connect:@"http://stream.psyradio.com.ua:8000/64kbps" withDelegate:self withGain:(0.5)];
    
    return YES;
}

-(void)loadMainView {
	// this was used to switch from the starting/buffering view to the now playing view, see the "Radio Javan" app in the App Store for how that works
}

-(void)updateTitle:(NSString*)title {
	// update view text
}

-(void)updateGain:(float)value {
	// update volume slider
}

-(void)updatePlay:(BOOL)play {
	// toggle play/pause button
}

-(void)updateBuffering: (BOOL)value {
	// update buffer indicator
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end