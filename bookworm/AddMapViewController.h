//
//  AddMapViewController.h
//  bookworm
//
//  Created by Yash Jalan on 4/25/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol AddMapViewControllerDelegate;

@interface AddMapViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapAdd;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *previousPoint;

@property (weak, nonatomic) id <AddMapViewControllerDelegate> delegate;

@end


@protocol AddMapViewControllerDelegate <NSObject>

- (void)mapViewController:(AddMapViewController *)addMap lattitude:(NSString *)latt longitude: (NSString *)longt;



@end
