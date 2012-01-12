//
//  PsyRadioViewController.m
//  PsyRadio
//
//  Created by Alex on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PsyRadioViewController.h"
#import "Radio.h"


@implementation PsyRadioViewController

@synthesize radio = _radio;


/* radio */
-(void)loadMainView {
	// this was used to switch from the starting/buffering view to the now playing view, see the "Radio Javan" app in the App Store for how that works
}

-(void)updateTitle:(NSString*)title {
	// update view text
    NSLog(@"StreamTitle: %@", title);
}

-(void)updateGain:(float)value {
	// update volume slider
    NSLog(@"updateGain: %f", value);
}

-(void)updatePlay:(BOOL)play {
	// toggle play/pause button
    NSLog(@"updateBuffering: %c", play);
}

-(void)updateBuffering: (BOOL)value {
	// update buffer indicator
    NSLog(@"updateBuffering: %c", value);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // radio
    self.radio = [[Radio alloc] init];
	[self.radio connect:@"http://stream.psyradio.com.ua:8000/64kbps" withDelegate:self withGain:(0.5)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //Once the view has loaded then we can register to begin recieving controls and we can become the first responder
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    //End recieving events
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

//Make sure we can recieve remote control events
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl) {
        if (event.subtype == UIEventSubtypeRemoteControlPlay) {
            [self.radio resume];
        } else if (event.subtype == UIEventSubtypeRemoteControlPause) {
            [self.radio pause];
        } else if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause) {
            [self.radio togglePlay];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    /*
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
     */
    return YES;
}

- (void)dealloc{
    [_radio release];
    [super dealloc];
}

@end
