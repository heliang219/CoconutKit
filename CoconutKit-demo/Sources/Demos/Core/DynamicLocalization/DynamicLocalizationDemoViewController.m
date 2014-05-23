//
//  DynamicLocalizationDemoViewController.m
//  CoconutKit-demo
//
//  Created by Samuel Défago on 09.01.12.
//  Copyright (c) 2012 Samuel Défago. All rights reserved.
//

#import "DynamicLocalizationDemoViewController.h"

@interface DynamicLocalizationDemoViewController ()

@property (nonatomic, retain) IBOutlet UILabel *coloredLabel;   // No outlet would be needed for localization purposes only, but
                                                                // here we want to test background color changes
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UISwitch *missingLocalizationVisibilitySwitch;

@end

@implementation DynamicLocalizationDemoViewController

#pragma mark Object creation and destruction

- (void)releaseViews
{
    [super releaseViews];
    
    self.coloredLabel = nil;
    self.imageView = nil;
    self.missingLocalizationVisibilitySwitch = nil;
}

#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.missingLocalizationVisibilitySwitch.on = [UILabel missingLocalizationsVisible];
}

#pragma mark Orientation management

- (NSUInteger)supportedInterfaceOrientations
{
    return [super supportedInterfaceOrientations] & UIInterfaceOrientationMaskPortrait;
}

#pragma mark Localization

- (void)localize
{
    [super localize];
    
    self.title = NSLocalizedString(@"Dynamic localization", nil);
    
    // Cannot use [UIImage imageNamed:] for localized images because of caching
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"img_localized" ofType:@"png"];
    self.imageView.image = [UIImage imageWithContentsOfFile:imagePath];
}

#pragma mark Event callbacks

- (IBAction)changeColor:(id)sender
{
    self.coloredLabel.backgroundColor = [UIColor randomColor];
}

- (IBAction)toggleMissingLocalizationVisibility:(id)sender
{
    [UILabel setMissingLocalizationsVisible:! [UILabel missingLocalizationsVisible]];
    
    UIButton *button = sender;
    button.selected = ! button.selected;
}

@end
