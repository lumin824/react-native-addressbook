#import "RCTViewManager.h"
#import <MapKit/MapKit.h>

@interface AddressBookManager : RCTViewManager

@end

@implementation AddressBookManager

RCT_EXPORT_MODULE()

- (UIView *)view
{
  return [[MKMapView alloc] init];
}



@end
