//
//  PsyRadioViewController.h
//  PsyRadio
//
//  Created by Alex on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LOW_URL_AUDIO @"http://stream.psyradio.com.ua:8000/64kbps"
#define MEDIUM_URL_AUDIO @"http://stream.psyradio.com.ua:8000/128kbps"
#define HIGH_URL_AUDIO @"http://stream.psyradio.com.ua:8000/256kbps"

@class Radio;

@interface PsyRadioViewController : UIViewController{
	Radio *radio;
    UIButton *radioButton;
    UISlider *volumeSlider;
    UISegmentedControl *qualitySelector;
    UILabel *trackTitle;
}

@property (nonatomic, retain) Radio *radio;
@property (nonatomic, retain) IBOutlet UIButton *radioButton;
@property (nonatomic, retain) IBOutlet UISlider *volumeSlider;
@property (nonatomic, retain) IBOutlet UISegmentedControl *qualitySelector;
@property (nonatomic, retain) IBOutlet UILabel *trackTitle;

- (IBAction)radioButtonPressed:(id)sender;
- (IBAction)volumeChanged:(id)sender;


-(void)loadMainView;
-(void)updateTitle:(NSString*)title;
-(void)updateGain:(float)value;
-(void)updatePlay:(BOOL)play;
-(void)updateBuffering:(BOOL)value;
-(void)updateBufferingValue:(int)buffer_value withBufferSize:(int)buffer_size;
-(void)playingStarted;

@end
