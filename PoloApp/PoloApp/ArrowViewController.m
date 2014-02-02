//
//  ArrowViewController.m
//  PoloApp
//
//  Created by Matt Brenman on 2/2/14.
//  Copyright (c) 2014 mbrenman. All rights reserved.
//

#import "ArrowViewController.h"
#import <Parse/Parse.h>

@interface ArrowViewController ()

@end

@implementation ArrowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [_compassView setArrowImage:[UIImage imageNamed:@"chevron.jpeg"]];
    
	_locationManager=[[CLLocationManager alloc] init];
	_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	_locationManager.headingFilter = 1;
	_locationManager.delegate=self;
	[_locationManager startUpdatingHeading];
    
    _me = [PFUser currentUser];
}

- (IBAction)ArrowBackButtonPushed:(id)sender {
    NSLog(@"Pushed");
    [self performSegueWithIdentifier:@"ArrowToPerson" sender:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
	// Convert Degree to Radian to point the arrow
	float newRad =  -newHeading.trueHeading * M_PI / 180.0f;

    //Find my current location
    float myLat = _locationManager.location.coordinate.latitude;
    float myLong = _locationManager.location.coordinate.longitude;
    
    //Push my current location to the cloud (so partner can see it)
    _me[@"lat"] = [NSString stringWithFormat:@"%f", myLat];
    _me[@"long"] = [NSString stringWithFormat:@"%f", myLong];
    
    //TODO: Actually get this from somebody else
    //TUFTS - SE
    float otherLat = 42.4069;
    float otherLong = -71.1198;

    //SW
//    float otherLat = 42.3369;
//    float otherLong = -71.2097;
    
    //NE
//    float otherLat = 42.5278;
//    float otherLong = -70.9292;
    
    //NW
//    float otherLat = 42.5047;
//    float otherLong = -71.1961;
    
    float change = 0.0f;
    
    float dLat = otherLat - myLat;
    float dLong = otherLong - myLong;
    
    change = atan2(dLat, dLong);
    change -= M_PI_2;
    
//    if (otherLat > myLat){
//        if (otherLong > myLong){
//            //North East
//            change = atan((otherLong - myLong)/(otherLat - myLat));
//            NSLog(@"NORTHEAST  %f", change);
//        } else {
//            //North West
//            change = -(atan((myLong - otherLong)/(otherLat - myLat)));
//            NSLog(@"NORTHWEST  %f", change);
//        }
//    } else {
//        if (otherLong > myLong){
//            //South East
//            change = M_PI - atan((otherLong - myLong)/(myLat - otherLat));
//             NSLog(@"SOUTHEAST  %f", change);
//        } else {
//            //South West
//            change = M_PI + atan((myLong - otherLong)/(myLat - otherLat));
//            NSLog(@"SOUTHWEST  %f %f %f %f %f ", change, myLat, otherLat, myLong, otherLong);
//        }
//    }
    
    NSLog([NSString stringWithFormat:@"%f", change]);
    newRad += change;
    [_compassView setNewRad:newRad];
    [_compassView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
