//
//  TimeLineCETViewController.m
//  CETDenuncia
//
//  Created by VINICIUS RESENDE FIALHO on 19/09/14.
//  Copyright (c) 2014 Vinicius Resende | Emerson Barros. All rights reserved.
//

#import "TimeLineCETViewController.h"

@interface TimeLineCETViewController()
@end

@implementation TimeLineCETViewController

+(TimeLineCETViewController*)sharedManager{
    static TimeLineCETViewController *unicoUsuario = nil;
    if(!unicoUsuario){
        unicoUsuario = [[super allocWithZone:nil]init];
    }
    return unicoUsuario;
}

-(id)init{
    self = [super init];
    if(self){
    }
    return self;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedManager];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self carregaComponentesIniciaisTwiter];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

//Sobrepõe a barra de status
- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)carregaComponentesIniciaisTwiter{
    
    //Delegate da Web view
    self.TimeLineCETWebView.delegate = self;
    
    //Carrega o conteúdo do html no webview
    NSString *embedHTML = @"<html><head></head><body><a class=\"twitter-timeline\" href=\"https://twitter.com/CETSP_\" data-widget-id=\"519942987082502144\">Tweets de @CETSP_</a><script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+\"://platform.twitter.com/widgets.js\";fjs.parentNode.insertBefore(js,fjs);}}(document,\"script\",\"twitter-wjs\");</script></body></html>";
    
    [self.TimeLineCETWebView loadHTMLString:embedHTML baseURL:nil];
    [self.TimeLineCETWebView setDataDetectorTypes: UIDataDetectorTypeNone];
}


//BLOCK DE LINKS EXTERNOS
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //Mostra o botão de voltar, se entrar nos botões de retweet, favoritar ou responder
    if ([[request.URL absoluteString]  rangeOfString: @"https://twitter.com/intent"].location !=  NSNotFound) {
        self.outBtoVoltar.hidden = NO;
    }else{
        self.outBtoVoltar.hidden = YES;
    }
    
    return !(navigationType == UIWebViewNavigationTypeLinkClicked);
}


//Recarrega a timeline da CET
- (IBAction)btnVoltarPerfil:(id)sender {
    NSString *embedHTML = @"<html><head></head><body><a class=\"twitter-timeline\" href=\"https://twitter.com/CETSP_\" data-widget-id=\"519942987082502144\">Tweets de @CETSP_</a><script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+\"://platform.twitter.com/widgets.js\";fjs.parentNode.insertBefore(js,fjs);}}(document,\"script\",\"twitter-wjs\");</script></body></html>";
    
    [self.TimeLineCETWebView loadHTMLString:embedHTML baseURL:nil];
    [self.TimeLineCETWebView setDataDetectorTypes:UIDataDetectorTypeNone];
}

@end
