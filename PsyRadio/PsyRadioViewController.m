//
//  PsyRadioViewController.m
//  PsyRadio
//
//  Created by Alex on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PsyRadioViewController.h"
#import "Radio.h"
#import <QuartzCore/CoreAnimation.h>

@implementation PsyRadioViewController

@synthesize radio = _radio;
@synthesize radioButton = _radioButton;
@synthesize volumeSlider = _volumeSlider;
@synthesize qualitySelector = _qualitySelector;
@synthesize trackTitle = _trackTitle;
@synthesize logoImage = _logoImage;


- (void)aboutViewControllerDidFinish:(AboutViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
}

//
// spinButton
//
// Shows the spin button when the audio is loading. This is largely irrelevant
// now that the audio is loaded from a local file.
//
- (void)spinButton
{
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	CGRect frame = [self.radioButton frame];
	self.radioButton.layer.anchorPoint = CGPointMake(0.5, 0.5);
	self.radioButton.layer.position = CGPointMake(frame.origin.x + 0.5 * frame.size.width, frame.origin.y + 0.5 * frame.size.height);
	[CATransaction commit];
    
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
	[CATransaction setValue:[NSNumber numberWithFloat:2.0] forKey:kCATransactionAnimationDuration];
    
	CABasicAnimation *animation;
	animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	animation.fromValue = [NSNumber numberWithFloat:0.0];
	animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
	animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
	animation.delegate = self;
	[self.radioButton.layer addAnimation:animation forKey:@"rotationAnimation"];
    
	[CATransaction commit];
}

//
// setButtonImage:
//
// Used to change the image on the playbutton. This method exists for
// the purpose of inter-thread invocation because
// the observeValueForKeyPath:ofObject:change:context: method is invoked
// from secondary threads and UI updates are only permitted on the main thread.
//
// Parameters:
//    image - the image to set on the play button.
//
- (void)setButtonImage:(UIImage *)image
{
	[self.radioButton.layer removeAllAnimations];
	if (!image)
	{
		[self.radioButton setImage:[UIImage imageNamed:@"playbutton.png"] forState:0];
	}
	else
	{
		[self.radioButton setImage:image forState:0];
        
		if ([self.radioButton.currentImage isEqual:[UIImage imageNamed:@"loadingbutton.png"]])
		{
			[self spinButton];
		}
	}
}


/* radio */
-(void)loadMainView {
	// this was used to switch from the starting/buffering view to the now playing view, see the "Radio Javan" app in the App Store for how that works
    //NSLog(@"loadMainView: Radio");
}

-(void)updateTitle:(NSString*)title {
	// update view text
    title = [title stringByReplacingOccurrencesOfString:@"StreamTitle='(.*)';" 
                                       withString:@"$1" 
                                          options:NSRegularExpressionSearch
                                                  range:NSMakeRange(0, [title length])];
    [self.trackTitle setText:title];
}

-(void)updateGain:(float)value {
	// update volume slider
}

-(void)updatePlay:(BOOL)play {
	// toggle play/pause button
    //NSLog(@"updateBuffering: %c", play);
}

-(void)updateBuffering:(BOOL)value {
	// update buffer indicator
    //NSLog(@"updateBuffering: %@", (value ? @"YES" : @"NO"));
}

-(void)updateBufferingValue:(int)buffer_value withBufferSize:(int)buffer_size {
	// update buffer value
    //NSLog(@"updateBufferingValue: %i of %i", buffer_value, buffer_size);
}

-(void)playingStarted {
    [self setButtonImage:[UIImage imageNamed:@"pausebutton.png"]];
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

- (IBAction)radioButtonPressed {
    
    if ([self.radioButton.currentImage isEqual:[UIImage imageNamed:@"playbutton.png"]])
	{
		[self.radio connect:[self getStreamingUrl] withDelegate:self withGain:self.volumeSlider.value withQualityIndex:[self.qualitySelector selectedSegmentIndex] + 1];
		[self setButtonImage:[UIImage imageNamed:@"loadingbutton.png"]];
	}
	else
	{
        [self setButtonImage:[UIImage imageNamed:@"playbutton.png"]];
		[self.radio pause];
	}
}

- (IBAction)volumeChanged:(id)sender {
    [self.radio updateGain:self.volumeSlider.value];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)setupIntrface {
    //background
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_sand.png"]]];
    self.trackTitle.textAlignment = UITextAlignmentCenter;
    
    //slider
    UIImage *minImage = NULL;
    UIImage *maxImage = NULL;
    if ([[UIImage class] respondsToSelector:@selector(resizableImageWithCapInsets)]) {
        minImage = [[UIImage imageNamed:@"slider_minimum.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        maxImage = [[UIImage imageNamed:@"slider_maximum.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    } else {
        minImage = [[UIImage imageNamed:@"slider_minimum.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
        maxImage = [[UIImage imageNamed:@"slider_maximum.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
    }
    UIImage *thumbImage = [UIImage imageNamed:@"thumb.png"];

    [self.volumeSlider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [self.volumeSlider setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [self.volumeSlider setThumbImage:thumbImage forState:UIControlStateNormal];
    
    //sengemnt control
    /*
    UIImage *segmentSelected = NULL;
    UIImage *segmentUnselected = NULL;
    if ([[UIImage class] respondsToSelector:@selector(resizableImageWithCapInsets)]) {
        segmentSelected = [[UIImage imageNamed:@"segcontrol_sel.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
        segmentUnselected = [[UIImage imageNamed:@"segcontrol_uns.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    } else {
        segmentSelected = [[UIImage imageNamed:@"segcontrol_sel.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0];
        segmentUnselected = [[UIImage imageNamed:@"segcontrol_uns.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0];
    }
    UIImage *segmentSelectedUnselected = [UIImage imageNamed:@"segcontrol_sel-uns.png"];
    UIImage *segUnselectedSelected = [UIImage imageNamed:@"segcontrol_uns-sel.png"];
    UIImage *segmentUnselectedUnselected = [UIImage imageNamed:@"segcontrol_uns-uns.png"];
    
    if ([self.qualitySelector respondsToSelector:@selector(setBackgroundImage:forState:barMetrics:)]){
        [self.qualitySelector setBackgroundImage:segmentUnselected forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [self.qualitySelector setBackgroundImage:segmentSelected forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
        [self.qualitySelector setDividerImage:segmentUnselectedUnselected forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [self.qualitySelector setDividerImage:segmentSelectedUnselected forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [self.qualitySelector setDividerImage:segUnselectedSelected forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    }
     */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // radio
    self.radio = [[Radio alloc] init];
    //design
    [self setupIntrface];
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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                self.logoImage.frame =  CGRectMake(120, 5, 80, 80);
            } else {
                self.logoImage.frame =  CGRectMake(240, 20, 300, 300);
            }
            break;
        default:
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                self.logoImage.frame =  CGRectMake(160, 10, 150, 150);
            } else {
                self.logoImage.frame =  CGRectMake(240, 20, 505, 505);
            }
            break;
    }
}

- (IBAction)showAboutInfo {
    AboutViewController *controller;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        controller = [[AboutViewController alloc] initWithNibName:@"AboutViewController_IPhone" bundle:nil];
    } else {
        controller = [[AboutViewController alloc] initWithNibName:@"AboutViewController_IPad" bundle:nil];
    }
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
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
            [self setButtonImage:[UIImage imageNamed:@"loadingbutton.png"]];
        } else if (event.subtype == UIEventSubtypeRemoteControlPause) {
            [self.radio pause];
            [self setButtonImage:[UIImage imageNamed:@"playbutton.png"]];
        } else if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause) {
            [self radioButtonPressed];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    /*
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return YES;
    }
     */
    return YES;
}

- (void)dealloc{
    [_radio release];
    [_radioButton release];
    [_volumeSlider release];
    [_qualitySelector release];
    [_trackTitle release];
    [_logoImage release];
    [super dealloc];
}

@end
