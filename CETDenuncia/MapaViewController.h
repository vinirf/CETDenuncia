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
#import "Usuario.h"

@interface MapaViewController : UIViewController <MKMapViewDelegate>

//VIEW
@property (weak, nonatomic) IBOutlet MKMapView *mapa;
@property (weak, nonatomic) IBOutlet UIImageView *imgPinoCarregamento;
@property (weak, nonatomic) IBOutlet UIView *viewCarregamento;

//MAPA
-(void)zoomToUserRegion;
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation;
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;
-(void)marcarPosicaoNoMapaDiretoSiteCetOcorrencia:(CoordenadaCetSite*)CoordCet;

//PARSE HTML
-(void)serializaDadosSiteCET;
-(void)carregaComponentesIniciaisMapa;

@end
