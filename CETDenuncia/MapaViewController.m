//
//  MapaViewController.m
//  Mapa
//
//  Created by EMERSON DE SOUZA BARROS on 19/09/14.
//  Copyright (c) 2014 EMERSON DE SOUZA BARROS. All rights reserved.
//
#import "MapaViewController.h"

@interface MapaViewController ()
@end

@implementation MapaViewController


//Ciclo de vida da View -----------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //Configura a localização atual como a localização do usuário
    self.mapa.showsUserLocation = YES;
    [self.mapa setDelegate: self];
    
    //Adiciona como view filho
    [self.view addSubview: self.mapa];
    
    
    [self serializaDadosSiteCET];
    [self serializaDadosSiteCETLentidao];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
    [self zoomToUserRegion];
    [self viewWillLayoutSubviews];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
//----------------------------------------------------------------------------------


//Configurações do mapa ------------------------------------------------------------
//Configura a localização atual
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    [[self mapa] setCenterCoordinate: userLocation.location.coordinate];
    [[Usuario sharedManager]setaPosicaoUsuario:userLocation.location.coordinate];
    
}


//Aplica zoom ao mapa na região em que o usuário se encontra
-(void)zoomToUserRegion {
    
    MKCoordinateRegion region;
    region.center.latitude = self.mapa.userLocation.coordinate.latitude;
    region.center.longitude = self.mapa.userLocation.coordinate.longitude;
    region.span.latitudeDelta = 0.1;
    region.span.longitudeDelta = 0.1;
    [self.mapa setRegion:region];
    
}
//---------------------------------------------------------------------------------


-(void)serializaDadosSiteCET{
    
    
    NSString *problema = @"Ocorrências não disponíveis no momento";
    NSString* url = @"http://cetsp1.cetsp.com.br/monitransmapa/IMG5/ocorrenciasH.asp?ordem=H";
    NSURL* query = [NSURL URLWithString:url];
    NSString* result = [NSString stringWithContentsOfURL:query encoding:NSWindowsCP1254StringEncoding error:nil];
    
    int contando =0;
    while([result rangeOfString:problema].location != NSNotFound){
        contando += 1;
        
        NSString *s = [NSString stringWithFormat:@"%@%d%@",@"http://cetsp1.cetsp.com.br/monitransmapa/IMG",contando,@"/ocorrenciasH.asp?ordem=N "];
        NSURL* query = [NSURL URLWithString:s];
        result = [NSString stringWithContentsOfURL:query encoding:NSWindowsCP1254StringEncoding error:nil];
    }
    
    
    NSString *string=result;
    NSRange searchFromRange = [string rangeOfString:@"<table>"];
    NSRange searchToRange = [string rangeOfString:@"</body>"];
    NSString *substring = [string substringWithRange:NSMakeRange(searchFromRange.location+searchFromRange.length, searchToRange.location-searchFromRange.location-searchFromRange.length)];
    
    NSString *stringFinal = substring;
    
    //Controla o laco de repeticao
    NSRange continua =[stringFinal rangeOfString:@"<tr class"];
    
    
    //Faz enquanto encontrar o ultimo #EXTINF:-1,
    while(continua.location != NSNotFound){
        
        CoordenadaCetSite *t = [[CoordenadaCetSite alloc]init];
        
        stringFinal = [stringFinal substringFromIndex:continua.location];
        stringFinal = [stringFinal substringFromIndex:[stringFinal rangeOfString:@"title="].location+7];
        t.titulo = [stringFinal substringToIndex:[stringFinal rangeOfString:@"<td>"].location-9];
        
        stringFinal = [stringFinal substringFromIndex:[stringFinal rangeOfString:@"<td>"].location+4];
        t.codigo = [stringFinal substringToIndex:[stringFinal rangeOfString:@"</td>"].location-6];
        
        stringFinal = [stringFinal substringFromIndex:[stringFinal rangeOfString:@"<td>"].location+4];
        NSString *rua = [stringFinal substringToIndex:[stringFinal rangeOfString:@"</td>"].location];
        NSString *barra = @"/";
        
        
        if ([rua rangeOfString:barra].location != NSNotFound){
            NSArray *arR = [rua componentsSeparatedByString:@"/"];
            t.local = [arR objectAtIndex:0];
        }else{
            t.local = rua;
        }
        
        stringFinal = [stringFinal substringFromIndex:[stringFinal rangeOfString:@"<td>"].location+4];
        t.sentido = [stringFinal substringToIndex:[stringFinal rangeOfString:@"</td>"].location-6];
        
        stringFinal = [stringFinal substringFromIndex:[stringFinal rangeOfString:@"<td>"].location+4];
        NSString *time = [stringFinal substringToIndex:[stringFinal rangeOfString:@"</td>"].location-6];
        NSArray *arR2 = [time componentsSeparatedByString:@"-"];
        t.data = [arR2 objectAtIndex:0];
        t.hora = [arR2 objectAtIndex:1];
        
        
        BOOL estadoParaAdicionar = true;
        
        for(int i=0;i<[[[DataBaseCoordenada sharedManager]listaCoordenadasOcorrencia ]count];i++){
            CoordenadaCetSite *coord = [[[DataBaseCoordenada sharedManager]listaCoordenadasOcorrencia ]objectAtIndex:i];
            if([coord isKindOfClass:[CoordenadaCetSite class]]){
                if(([[coord hora] isEqualToString:[t hora]]) && ([[coord data] isEqualToString:[t data]])){
                    estadoParaAdicionar = false;
                    break;
                }
            }
        }
        
        if(estadoParaAdicionar){
            [[DataBaseCoordenada sharedManager]criaCoordenadaSiteCETOcorrencia: t];
            [self marcarPosicaoNoMapaDiretoSiteCetOcorrencia: t];
        }else{
        }
        
        
        continua = [stringFinal rangeOfString:@"<tr class"];
       
    }
    continua = [stringFinal rangeOfString:@"<tr class"];
    
}

-(void)serializaDadosSiteCETLentidao{
    
    NSString *problema = @"Lentidão por corredor não disponível no momento";
    NSString* url = @"http://cetsp1.cetsp.com.br/monitransmapa/IMG1/lentidao.asp?ordem=N";
    NSURL* query = [NSURL URLWithString:url];
    NSString* result = [NSString stringWithContentsOfURL:query encoding:NSWindowsCP1254StringEncoding error:nil];
    
    int contando =0;
    while([result rangeOfString:problema].location != NSNotFound){
        contando += 1;
        
        NSString *s = [NSString stringWithFormat:@"%@%d%@",@"http://cetsp1.cetsp.com.br/monitransmapa/IMG",contando,@"/lentidao.asp?ordem=N"];
        NSURL* query = [NSURL URLWithString:s];
        result = [NSString stringWithContentsOfURL:query encoding:NSWindowsCP1254StringEncoding error:nil];
        
    }
    
    
    NSString *string=result;
    NSRange searchFromRange = [string rangeOfString:@"<table>"];
    NSRange searchToRange = [string rangeOfString:@"</body>"];
    NSString *substring = [string substringWithRange:NSMakeRange(searchFromRange.location+searchFromRange.length, searchToRange.location-searchFromRange.location-searchFromRange.length)];
    
    NSString *stringFinal = substring;
    
    NSLog(@"v = %@", stringFinal);
    
    //Controla o laco de repeticao
    NSRange continua = [stringFinal rangeOfString:@"<tr class"];
    
    //Faz enquanto encontrar o ultimo #EXTINF:-1,
    while(continua.location != NSNotFound){
        
        CoordenadaCetSiteLentidao *coordLentidao = [[CoordenadaCetSiteLentidao alloc]init];

        
        //Corredor
        stringFinal = [stringFinal substringFromIndex: continua.location];
        stringFinal = [stringFinal substringFromIndex: [stringFinal rangeOfString:@"<td nowrap>"].location+11];
        coordLentidao.corredor = [stringFinal substringToIndex: [stringFinal rangeOfString:@"</td>"].location-1];
        
        //Sentido
        stringFinal = [stringFinal substringFromIndex:[stringFinal rangeOfString:@"<td>"].location+4];
        coordLentidao.sentido = [stringFinal substringToIndex: [stringFinal rangeOfString:@"</td>"].location-20];
        
        //Local
        stringFinal = [stringFinal substringFromIndex:[stringFinal rangeOfString:@"<td>"].location+4];
        stringFinal = [stringFinal substringFromIndex:[stringFinal rangeOfString:@"<td>"].location+21];
        coordLentidao.local = [stringFinal substringToIndex:[stringFinal rangeOfString:@"</td>"].location-14];
        
        //Local
        stringFinal = [stringFinal substringFromIndex:[stringFinal rangeOfString:@"<td align=right>"].location+18];
        coordLentidao.tamanho = [stringFinal substringToIndex:[stringFinal rangeOfString:@"</td>"].location-14];

        
        NSLog(@"corredor = %@", coordLentidao.corredor);
        NSLog(@"sentido = %@", coordLentidao.sentido);
        NSLog(@"via = %@", coordLentidao.local);
        NSLog(@"tamanho = %@m\n", coordLentidao.tamanho);
        

        
//        [[DataBaseCoordenada sharedManager] criaCoordenadaSiteCETLentidao: coordLentidao];
//        [self marcarPosicaoNoMapaDiretoSiteCetLentidao: coordLentidao];

        
        continua = [stringFinal rangeOfString:@"<tr class"];
        
    }
    continua = [stringFinal rangeOfString:@"<tr class"];
    
}


-(void)marcarPosicaoNoMapaDiretoSiteCetOcorrencia:(CoordenadaCetSite*)CoordCet{
    [[self mapa] addAnnotation: [[DataBaseCoordenada sharedManager]marcarPosicaoNoMapaDiretoSiteCetOcorrencia: CoordCet]];
}

-(void)marcarPosicaoNoMapaDiretoSiteCetLentidao:(CoordenadaCetSiteLentidao*)CoordCet{
    [[self mapa] addAnnotation: [[DataBaseCoordenada sharedManager]marcarPosicaoNoMapaDiretoSiteCetLentidao: CoordCet]];
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *annotationIdentifier = @"annotationIdentifier";
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
    
    if (pinView.annotation == mapView.userLocation) {
        return nil;
    }
    
    
    if([pinView.annotation.title isEqualToString:@"Ocorrência"]){
        [pinView setImage:[UIImage imageNamed:@"CETIcone.png"]];
    }
    
    if([pinView.annotation.title isEqualToString:@"Lentidão"]){
        [pinView setImage:[UIImage imageNamed:@"camera.png"]];
    }
    
    pinView.canShowCallout = YES;
    pinView.animatesDrop = YES;
    pinView.selected = YES;
    
    return pinView;
}

@end
