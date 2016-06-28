//
//  ViewController.m
//  GPSTransform
//
//  Created by Yang on 16/6/28.
//  Copyright © 2016年 YJ. All rights reserved.
//

#import "ViewController.h"
#import "CoordinateTransform.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CLLocationCoordinate2D wgs = CLLocationCoordinate2DMake(34.777082, 113.715453);
    
    CLLocationCoordinate2D gcj = [CoordinateTransform GCJFromWGSLat:wgs.latitude WGSLon:wgs.longitude];
    NSLog(@" gcj: %lf,%f ",gcj.latitude,gcj.longitude);
    
    CLLocationCoordinate2D bd = [CoordinateTransform BD09FromGCJ02:gcj];
    NSLog(@" bd: %lf,%f ",bd.latitude,bd.longitude);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
