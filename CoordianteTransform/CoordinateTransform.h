//
//  CoordinateTransform.h
//  neighborhood
//
//  Created by Yang on 16/6/24.
//  Copyright © 2016年 iYaYa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoordinateTransform : NSObject

/**
 *  GPS纠偏适用于google,高德体系的地图，WGS-84 to GCJ-02
 *
 * @paramwgLat gps纬度度
 * @paramwgLon gps经度
 *
 * @return返回纠偏过的火星坐标
 */
+ (CLLocationCoordinate2D)GCJFromWGSLat:(double)wgLat WGSLon:(double)wgLon;

/**
 * 火星坐标to GPS，CGJ-02 to WGS-84
 *
 * @paramlat火星纬度坐标
 * @paramlon火星经度坐标
 *
 * @returngps的坐标
 */
+ (CLLocationCoordinate2D)WGSFromGCJLat:(double)lat lon:(double)lon;

#pragma mark - GCJ02 to BD-09II
+ (CLLocationCoordinate2D)BD09FromGCJ02:(CLLocationCoordinate2D)jcg02;
+ (CLLocationCoordinate2D)GCJ02FromBD09:(CLLocationCoordinate2D)bd09;

#pragma mark - WGS - BD09
+ (CLLocationCoordinate2D)BD09FromWGS:(CLLocationCoordinate2D)wgs;
+ (CLLocationCoordinate2D)WGSFromBD09:(CLLocationCoordinate2D)bd09;

@end
