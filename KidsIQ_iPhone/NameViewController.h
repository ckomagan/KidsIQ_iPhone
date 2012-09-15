//
//  NameViewController.h
//  KidsIQ3
//
//  Created by Chan Komagan on 7/28/12.
//  Copyright (c) 2012 KidsIQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NameViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
 {
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *choicesLabel;
    IBOutlet UILabel *errorStatus;
    IBOutlet UITextField *nameText;
    IBOutlet UIButton *nameOK;
    IBOutlet UIPickerView *levelPickerView;
    IBOutlet UISegmentedControl *segmentedControl;
}

@property (nonatomic, retain) NSArray *levelpicker;
@property (nonatomic, retain) UIPickerView *levelPickerView;
@property int maxQuestions;

-(IBAction)validateTextFields:(id)sender;
-(IBAction)dismissView;
-(IBAction)textFieldReturn:(id)sender;
- (IBAction)valueChanged;

@end