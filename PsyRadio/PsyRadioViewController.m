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
@synthesize radioButton = _radioButton;
@synthesize volumeSlider = _volumeSlider;
@synthesize qualitySelector = _qualitySelector;
@synthesize trackTitle = _trackTitle;


/* radio */
-(void)loadMainView {
	// this was used to switch from the starting/buffering view to the now playing view, see the "Radio Javan" app in the App Store for how that works
}

-(void)updateTitle:(NSString*)title {
	// update view text
    title = [title stringByReplacingOccurrencesOfString:@"StreamTitle='(.*)'" 
                                       withString:@"$1" 
                                          options:NSRegularExpressionSearch
                                                  range:NSMakeRange(0, [title length])];
    [self.trackTitle setText:title];
}

-(void)updateGain:(float)value {
	// update volume slider
    //NSLog(@"updateGain: %f", value);
}

-(void)updatePlay:(BOOL)play {
	// toggle play/pause button
    //NSLog(@"updateBuffering: %c", play);
}

-(void)updateBuffering: (BOOL)value {
	// update buffer indicator
    NSLog(@"updateBuffering: %@", (value ? @"YES" : @"NO"));
}

- (NSString *)getStreamingUrl {
    switch ([self.qualitySelector selectedSegmentIndex]) {
        case 1:
            return MEDIUM_URL_AUDIO;
            break;
        case 2:
            return HIGH_URL_AUDIO;
            break;
        default:
            return LOW_URL_AUDIO;
    }
}

- (int)getStreamingQualityMult {
    return [self.qualitySelector selectedSegmentIndex] + 1;
}

- (IBAction)radioButtonPressed:(id)sender {
    if ([self.radioButton.titleLabel.text isEqual:@"Play"]){
        [self.radio connect:[self getStreamingUrl] withDelegate:self withGain:self.volumeSlider.value withQuality:[self getStreamingQualityMult]];
        [self.radioButton setTitle:@"Stop" forState:UIControlStateNormal];
    } else {
        [self.radio pause];
        [self.radioButton setTitle:@"Play" forState:UIControlStateNormal];
    }
}

- (IBAction)volumeChanged:(id)sender {
    [self.radio updateGain:self.volumeSlider.value];
}

- (IBAction)qualityChanged:(id)sender {
    [self.radio pause];
    [self.radio connect:[self getStreamingUrl] withDelegate:self withGain:self.volumeSlider.value withQuality:[self getStreamingQualityMult]];
    [self.radioButton setTitle:@"Stop" forState:UIControlStateNormal];
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
