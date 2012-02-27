//
//  CalloutViewController.m
//  MapMashup
//
//  Created by Rares Zehan on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StationDetailsViewController.h"

@implementation StationDetailsViewController

@synthesize stationWebsiteURLString;
@synthesize stationDetailsWebView;

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:self.stationWebsiteURLString];
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.stationDetailsWebView loadRequest:requestObj];
}

- (void)viewDidUnload {
    [self setStationDetailsWebView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (IBAction)doneViewingDetails:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
