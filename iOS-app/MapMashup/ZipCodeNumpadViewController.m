//
//  ZipCodeNumpadViewController.m
//  MapMashup
//
//  Created by Rares Zehan on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZipCodeNumpadViewController.h"

@interface ZipCodeNumpadViewController ()
- (void)addStringNumberToZip:(NSString *)stringNumber;
@end

@implementation ZipCodeNumpadViewController

@synthesize currentZipCodeValue;

- (void)viewDidLoad {
    [super viewDidLoad];
    currentZipCodeValue.text = @"";
}
- (void)viewDidUnload {
    [self setCurrentZipCodeValue:nil];
    [super viewDidUnload];
}

- (IBAction)number0Pressed:(id)sender {
    [self addStringNumberToZip:@"0"];
}

- (IBAction)number1Pressed:(id)sender {
    [self addStringNumberToZip:@"1"];
}

- (IBAction)number2Pressed:(id)sender {
    [self addStringNumberToZip:@"2"];
}

- (IBAction)number3Pressed:(id)sender {
    [self addStringNumberToZip:@"3"];
}

- (IBAction)number4Pressed:(id)sender {
    [self addStringNumberToZip:@"4"];
}

- (IBAction)number5Pressed:(id)sender {
    [self addStringNumberToZip:@"5"];
}

- (IBAction)number6Pressed:(id)sender {
    [self addStringNumberToZip:@"6"];
}

- (IBAction)number7Pressed:(id)sender {
    [self addStringNumberToZip:@"7"];
}

- (IBAction)number8Pressed:(id)sender {
    [self addStringNumberToZip:@"8"];
}

- (IBAction)number9Pressed:(id)sender {
    [self addStringNumberToZip:@"9"];
}

- (IBAction)clearZipCodeValueAction:(id)sender {
    currentZipCodeValue.text = @"";
}

- (IBAction)doneButtonAction:(id)sender {
    
    if ([self.currentZipCodeValue.text length] == 5) {
        int zipCode = [self.currentZipCodeValue.text intValue];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ZIP_CODE_CHANGED object:[NSNumber numberWithInt:zipCode]];
    } else {
        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"Not enough numbers to construct a zip code." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [errorAlertView show];
    }
    
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//    [UIStoryboardPopoverSegue ];
//    
//    [UIStoryboardPopoverSegue ];
//    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)backspaceButtonAction:(id)sender {
    
    if ([currentZipCodeValue.text length] > 0) {
        NSMutableString *newValue = [NSMutableString stringWithString:self.currentZipCodeValue.text];
        [newValue replaceCharactersInRange:NSMakeRange([newValue length] - 1, 1) withString:@""];
        self.currentZipCodeValue.text = newValue;
    }
}

- (void)addStringNumberToZip:(NSString *)stringNumber {
    if ([self.currentZipCodeValue.text length] < 5) {
        NSMutableString *newValue = [NSMutableString stringWithString:self.currentZipCodeValue.text];
        [newValue appendString:stringNumber];
        self.currentZipCodeValue.text = newValue;
    }
}
@end
