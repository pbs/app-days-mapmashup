//
//  ZipCodeNumpadViewController.h
//  MapMashup
//
//  Created by Rares Zehan on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZipCodeNumpadViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *currentZipCodeValue;
- (IBAction)number1Pressed:(id)sender;
- (IBAction)number2Pressed:(id)sender;
- (IBAction)number3Pressed:(id)sender;
- (IBAction)number4Pressed:(id)sender;
- (IBAction)number5Pressed:(id)sender;
- (IBAction)number6Pressed:(id)sender;
- (IBAction)number7Pressed:(id)sender;
- (IBAction)number8Pressed:(id)sender;
- (IBAction)number9Pressed:(id)sender;
- (IBAction)number0Pressed:(id)sender;

- (IBAction)clearZipCodeValueAction:(id)sender;
- (IBAction)doneButtonAction:(id)sender;
- (IBAction)backspaceButtonAction:(id)sender;

@end
