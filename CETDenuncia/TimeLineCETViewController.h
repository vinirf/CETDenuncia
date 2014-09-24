//
//  TimeLineCETViewController.h
//  CETDenuncia
//
//  Created by VINICIUS RESENDE FIALHO on 19/09/14.
//  Copyright (c) 2014 Vinicius Resende | Emerson Barros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineCETViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *TimeLineCETWebView;

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end
