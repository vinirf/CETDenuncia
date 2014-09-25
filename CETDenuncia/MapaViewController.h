//
//  MapaViewController.h
//  Mapa
//
//  Created by EMERSON DE SOUZA BARROS on 19/09/14.
//  Copyright (c) 2014 EMERSON DE SOUZA BARROS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DataBaseCoordenada.h"
#import "CoordenadaCetSite.h"
#import "CoordenadaCetSiteLentidao.h"
#import "Usuario.h"

@interface MapaViewController : UIViewController <MKMapViewDelegate>

//Atributos
@property (weak, nonatomic) IBOutlet MKMapView *mapa;

@end
