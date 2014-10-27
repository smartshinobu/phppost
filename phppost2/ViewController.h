//
//  ViewController.h
//  phppost2
//
//  Created by ビザンコムマック０７ on 2014/10/22.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
- (IBAction)upload:(id)sender;


@end

