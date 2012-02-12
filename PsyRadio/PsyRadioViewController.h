//
//  PsyRadioViewController.h
//  PsyRadio
//
//  Created by Alex on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutViewController.h"

#define LOW_URL_AUDIO @"http://stream.psyradio.com.ua:8000/64kbps"
#define MEDIUM_URL_AUDIO @"http://stream.psyradio.com.ua:8000/128kbps"
#define HIGH_URL_AUDIO @"http://stream.psyradio.com.ua:8000/256kbps"

@class Radio;

@interface PsyRadioViewController : UIViewController <AboutViewControllerDelegate> {
	Radio *radio;
    UIButton *radioButton;
    UISlider *volumeSlider;
    UISegmentedControl *qualitySelector;
    UILabel *trackTitle;
    UIButton *logoButton;
    UIButton *plusSound;
    UIButton *minusSound;
}

@property (nonatomic, retain) Radio *radio;
@property (nonatomic, retain) IBOutlet UIButton *radioButton;
@property (nonatomic, retain) IBOutlet UISlider *volumeSlider;
@property (nonatomic, retain) IBOutlet UISegmentedControl *qualitySelector;
@property (nonatomic, retain) IBOutlet UILabel *trackTitle;
@property (nonatomic, retain) IBOutlet UIButton *logoButton;
@property (nonatomic, retain) IBOutlet UIButton *plusSound;
@property (nonatomic, retain) IBOutlet UIButton *minusSound;

- (IBAction)radioButtonPressed;
- (IBAction)volumeChanged:(id)sender;
- (IBAction)qualityChanged;


-(void)logoInOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
-(void)loadMainView;
-(void)updateTitle:(NSString*)title;
-(void)updateGain:(float)value;
-(void)updatePlay:(BOOL)play;
-(void)updateBuffering:(BOOL)value;
-(void)updateBufferingValue:(int)buffer_value withBufferSize:(int)buffer_size;
-(void)plaingChanged:(int)state;
-(IBAction)changeVolume:(UIButton*)sender;

-(IBAction)showAboutInfo;
-(IBAction)gotoPsySite;

@end
