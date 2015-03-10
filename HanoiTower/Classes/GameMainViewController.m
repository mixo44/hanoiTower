//
//  GameMainViewController.m
//  HanoiTower
//
//  Created by Misha Torosyan on 3/8/15.
//  Copyright (c) 2015 Misha Torosyan. All rights reserved.
//

#import "GameMainViewController.h"
#import "Defines.h"


@interface GameMainViewController ()

@property(strong, nonatomic) IBOutlet UISlider *mConutSlider;
@property(strong, nonatomic) IBOutlet UILabel *mNumberOfRingsLabel;
@property(strong, nonatomic) IBOutlet UIButton *mStartButton;


- (void) sliderValueChanged:(UISlider *) slider;

@end

@implementation GameMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_mConutSlider addTarget:self
                      action:@selector(sliderValueChanged:)
            forControlEvents:UIControlEventValueChanged];
    [self sliderValueChanged:_mConutSlider];
    
    [_mStartButton.layer setCornerRadius:10];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSUInteger countOfRings = [[userDefaults valueForKey:kCountOfRings] integerValue];
    
    if (countOfRings < 1) {
        countOfRings = 1;
    }
    
    [_mConutSlider setValue:countOfRings];
    [self sliderValueChanged:_mConutSlider];
}

- (IBAction)startButtonHandler:(UIButton *)sender {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setValue:[NSNumber numberWithUnsignedInt:_mConutSlider.value] forKey:kCountOfRings];
    [userDefaults synchronize];
    
    [self performSegueWithIdentifier:@"GameViewSegue" sender:self];
    
    
}


#pragma mark - Slider Value
- (void) sliderValueChanged:(UISlider *) slider {
    
    NSInteger ronundedNumber = (long)roundf(slider.value);
    [slider setValue:ronundedNumber animated:NO];
    [_mNumberOfRingsLabel setText:[NSString stringWithFormat:@"Number of Rings: %li", (long)ronundedNumber]];
    
}


@end
