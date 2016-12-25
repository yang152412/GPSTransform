//
//  CoordinateTransform.m
//  neighborhood
//
//  Created by Yang on 16/6/24.
//  Copyright © 2016年 iYaYa. All rights reserved.
//

#import "CoordinateTransform.h"

static double pi =3.14159265358979324;
static double a =6378245.0;// WGS 长轴半径
static double ee =0.00669342162296594323;// WGS 偏心率的平方

@implementation CoordinateTransform


#pragma mark - GCJ02 to WGS

+ (CLLocationCoordinate2D )GCJFromWGSLat:(double)wgLat WGSLon:(double)wgLng
{
    CLLocationCoordinate2D coor;
    
    if ([self outOfChinaLat:wgLat lng:wgLng]) {
        coor = CLLocationCoordinate2DMake(wgLat, wgLng);
        return coor;
    }
    
    double dLat = [self transformLatX:wgLng - 105.0 y:wgLat - 35.0];
    double dLon = [self transformLonX:wgLng - 105.0 y:wgLat - 35.0];
    
    double radLat = wgLat / 180.0 * pi;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
    coor = CLLocationCoordinate2DMake(wgLat+dLat, wgLng+dLon);
    return coor;
}


+ (CLLocationCoordinate2D)WGSFromGCJLat:(double)lat lon:(double)lon
{
    double lontitude = lon - ([self GCJFromWGSLat:lat WGSLon:lon].longitude - lon);
    double lattitude = lat - ([self GCJFromWGSLat:lat WGSLon:lon].latitude - lat);
    
    return CLLocationCoordinate2DMake(lattitude, lontitude);
}


+ (BOOL)outOfChinaLat:(double)lat lng:(double)lon
{
    if(lon <72.004|| lon >137.8347)
        return true;
    if(lat <0.8293|| lat >55.8271)
        return true;
    return false;
}

+ (double)transformLatX:(double)x y:(double)y
{
    double ret = -100.0+2.0* x +3.0* y +0.2* y * y +0.1* x * y +0.2*sqrt(fabs(x));
    ret += (20.0*sin(6.0* x *pi) +20.0*sin(2.0* x *pi)) *2.0/3.0;
    ret += (20.0*sin(y *pi) +40.0*sin(y /3.0*pi)) *2.0/3.0;
    ret += (160.0*sin(y /12.0*pi) +320*sin(y *pi/30.0)) *2.0/3.0;
    return ret;
}

+ (double)transformLonX:(double)x y:(double)y {
    double ret =300.0+ x +2.0* y +0.1* x * x +0.1* x * y +0.1*sqrt(fabs(x));
    ret += (20.0*sin(6.0* x *pi) +20.0*sin(2.0* x *pi)) *2.0/3.0;
    ret += (20.0*sin(x *pi) +40.0*sin(x /3.0*pi)) *2.0/3.0;
    ret += (150.0*sin(x /12.0*pi) +300.0*sin(x /30.0*pi)) *2.0/3.0;
    return ret;
}

#pragma mark - GCJ02 to BD-09II
const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;

+ (CLLocationCoordinate2D)BD09FromGCJ02:(CLLocationCoordinate2D)jcg02
{
    double x = jcg02.longitude, y = jcg02.latitude;
    
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    
    double bd_lon = z * cos(theta) + 0.0065;
    
    double bd_lat = z * sin(theta) + 0.006;
    
    return CLLocationCoordinate2DMake(bd_lat, bd_lon);
}

+ (CLLocationCoordinate2D)GCJ02FromBD09:(CLLocationCoordinate2D)bd09
{
    double x = bd09.longitude - 0.0065, y = bd09.latitude - 0.006;
    
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    
    double gg_lon = z * cos(theta);
    
    double gg_lat = z * sin(theta);
    
    return CLLocationCoordinate2DMake(gg_lat, gg_lon);
}

#pragma mark - WGS - BD09
+ (CLLocationCoordinate2D)BD09FromWGS:(CLLocationCoordinate2D)wgs
{
    CLLocationCoordinate2D gcj = [self GCJFromWGSLat:wgs.latitude WGSLon:wgs.longitude];
    CLLocationCoordinate2D bd = [self BD09FromGCJ02:gcj];
    
    return bd;
}

+ (CLLocationCoordinate2D)WGSFromBD09:(CLLocationCoordinate2D)bd09
{
    CLLocationCoordinate2D gcj = [self GCJ02FromBD09:bd09];
    CLLocationCoordinate2D wgs = [self WGSFromGCJLat:gcj.latitude lon:gcj.longitude];
    
    return wgs;
}

+ (void)transTest
{
    // WGS
    //    double longitude = 121.579262,latitude = 31.2013073;
    // GCJ
    double latitude = 31.199098320594977, longitude = 121.58347316122904;
    
    CLLocationCoordinate2D coor = [self WGSFromGCJLat:latitude lon:longitude];
    NSLog(@" \n %f, %f ",coor.latitude,coor.longitude);
    
}

@end
