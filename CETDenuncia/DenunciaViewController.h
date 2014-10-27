//
//  ViewController.h
//  CETDenuncia
//
//  Created by VINICIUS RESENDE FIALHO on 19/09/14.
//  Copyright (c) 2014 Vinicius Resende | Emerson Barros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Usuario.h"
#import "MapaViewController.h"
#import "TimeLineCETViewController.h"

@interface DenunciaViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate,MKMapViewDelegate>

@property NSString *nomeTwitter;
@property NSString *imageString;
@property MKMapView *mapa;
@property CLLocationManager *locationManager;
@property UITapGestureRecognizer *tapAddFoto;
@property UITapGestureRecognizer *tapVoltarView;


//VIEWS
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackTirarFoto;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *outBtoDenunciar;
@property (weak, nonatomic) IBOutlet UIView *viewInformativo;
- (IBAction)btoInformativo:(id)sender;

//TIRAR FOTO
-(void)tirarFoto;
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;



@end
