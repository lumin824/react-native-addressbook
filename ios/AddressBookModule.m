
#import "RCTBridgeModule.h"
#import "RCTUIManager.h"

#import <AddressBook/AddressBook.h>

@interface AddressBookModule: NSObject<RCTBridgeModule>

@end

@implementation AddressBookModule

- (instancetype) init{
    self = [super init];

    return self;
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(list:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    NSMutableDictionary* result = [[NSMutableDictionary alloc]init];
    
    bool __block isAuthed = false;
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    if( authStatus == kABAuthorizationStatusNotDetermined ){
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            isAuthed = granted;
            dispatch_semaphore_signal(semaphore);
        });
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    else if( authStatus == kABAuthorizationStatusAuthorized ){
        isAuthed = true;
    }
    
    if(isAuthed){
        CFArrayRef peopleArrayRef = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
        CFIndex peopleCount = ABAddressBookGetPersonCount(addressBookRef);
        NSMutableArray* result = [[NSMutableArray alloc] init];
        for(NSInteger i = 0; i < peopleCount; i++){
            ABRecordRef peopleRef = CFArrayGetValueAtIndex(peopleArrayRef, i);
            NSMutableDictionary* people = [[NSMutableDictionary alloc]init];
            
            people[@"firstName"] = (__bridge NSString*)ABRecordCopyValue(peopleRef, kABPersonFirstNameProperty);
            people[@"lastName"] = (__bridge NSString*)ABRecordCopyValue(peopleRef, kABPersonLastNameProperty);
            
            ABMultiValueRef phoneRef = ABRecordCopyValue(peopleRef, kABPersonPhoneProperty);
            CFIndex phoneCount = ABMultiValueGetCount(phoneRef);
            NSMutableArray* phoneArray = [[NSMutableArray alloc] init];
            for(NSInteger j = 0; j < phoneCount; j++){
                [phoneArray addObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneRef, j)];
            }
            people[@"phone"] = phoneArray;
            [result addObject:people];
        }
        resolve(result);
    }else{
        reject(@"error", @"error", NULL);
    }
}

@end
