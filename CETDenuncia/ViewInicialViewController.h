//
//  ViewInicialViewController.h
//  CETDenuncia
//
//  Created by VINICIUS RESENDE FIALHO on 03/10/14.
//  Copyright (c) 2014 Vinicius Resende | Emerson Barros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Usuario.h"

@interface ViewInicialViewController : UIViewController <UIAlertViewDelegate,CLLocationManagerDelegate>

@property CLLocationManager *locationManager;

@end