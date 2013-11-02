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
@synthesize logoButton = _logoButton;
@synthesize plusSound = _plusSound;
@synthesize minusSound = _minusSound;


- (void)aboutViewControllerDidFinish:(AboutViewController *)controller {
	[self dismissViewControllerAnimated:YES completion:nil];
    // rotation
    [self logoInOrientation:self.interfaceOrientation];
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

-(void)plaingChanged:(int)state {
    switch (state) {
        // stop/pause
        case 0:
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                [self.radioButton setImage:[UIImage imageNamed:@"playbutton.png"] forState:0];
            } else {
                [self.radioButton setImage:[UIImage imageNamed:@"playbutton@2x.png"] forState:0];
            }
            break;
        // loading
        case 1:
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                [self.radioButton setImage:[UIImage imageNamed:@"loadingbutton.png"] forState:0];
            } else {
                [self.radioButton setImage:[UIImage imageNamed:@"loadingbutton@2x.png"] forState:0];
            }
            [self spinButton];
            break; 
        // play
        case 2:
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                [self.radioButton setImage:[UIImage imageNamed:@"pausebutton.png"] forState:0];
            } else {
                [self.radioButton setImage:[UIImage imageNamed:@"pausebutton@2x.png"] forState:0];
            }
            break;
        default:
            break;
    }
    
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
    
    if (![self.radio isPlayed])
	{
		[self.radio connect:[self getStreamingUrl] withDelegate:self withGain:self.volumeSlider.value withQualityIndex:[self.qualitySelector selectedSegmentIndex] + 1];
	}
	else
	{
		[self.radio updatePlay:NO];
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

-(IBAction)changeVolume:(UIButton*)sender {
    if (1 == [sender tag]){
        float val = self.volumeSlider.value + 0.1;
        if (val > 1){
            val = 1;
        }
        [self.volumeSlider setValue:val animated:YES];
    } else {
        float val = self.volumeSlider.value - 0.1;
        if (val < 0){
            val = 0;
        }
        [self.volumeSlider setValue:val animated:YES];
    }
    [self.radio updateGain:self.volumeSlider.value];
}

#pragma mark - View lifecycle

- (void)logoInOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            self.logoButton.hidden = YES;
            break;
        default:
            self.logoButton.hidden = NO;
            int size = 150;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                size = 150;
            } else {
                size = 300;
            }
            self.logoButton.frame =  CGRectMake(([self view].bounds.size.width / 2) - (size / 2), 10, size, size);
            break;
    }
}

- (void)setupIntrface {
    // rotation
    [self logoInOrientation:self.interfaceOrientation];
    //background
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_sand.png"]]];
    self.trackTitle.textAlignment = NSTextAlignmentCenter;
    
    //slider
    UIImage *minImage = NULL;
    UIImage *maxImage = NULL;
    UIImage *thumbImage = NULL;
    if ([[UIImage class] respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            minImage = [[UIImage imageNamed:@"slider_minimum.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            maxImage = [[UIImage imageNamed:@"slider_maximum.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        } else {
            minImage = [[UIImage imageNamed:@"slider_minimum-IPad.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            maxImage = [[UIImage imageNamed:@"slider_maximum-IPad.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        }
    } else {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            minImage = [[UIImage imageNamed:@"slider_minimum.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
            maxImage = [[UIImage imageNamed:@"slider_maximum.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
        } else {
            minImage = [[UIImage imageNamed:@"slider_minimum-IPad.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
            maxImage = [[UIImage imageNamed:@"slider_maximum-IPad.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
        }
    }
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        thumbImage = [UIImage imageNamed:@"thumb.png"];
    } else {
        thumbImage = [UIImage imageNamed:@"thumb-IPad.png"];
    }

    [self.volumeSlider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [self.volumeSlider setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [self.volumeSlider setThumbImage:thumbImage forState:UIControlStateNormal];
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
    //logo
    [self logoInOrientation:toInterfaceOrientation];
}


- (IBAction)qualityChanged {
    if ([self.radio isPlayed]){
        [self.radio updatePlay:NO];
        [self.radio connect:[self getStreamingUrl] withDelegate:self withGain:self.volumeSlider.value withQualityIndex:[self.qualitySelector selectedSegmentIndex] + 1];
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
	[self presentViewController:controller animated:YES completion:nil];
	
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
            [self.radio updatePlay:YES];
        } else if (event.subtype == UIEventSubtypeRemoteControlPause) {
            [self.radio updatePlay:NO];
        } else if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause) {
            [self radioButtonPressed];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)dealloc{
    [_radio release];
    [_radioButton release];
    [_volumeSlider release];
    [_qualitySelector release];
    [_trackTitle release];
    [_logoButton release];
    [_plusSound release];
    [_minusSound release];
    [super dealloc];
}

@end
