//
//  ABRecord_PDAdditions.h
//  SproutedUtilities
//
//  Created by Philip Dow on 9/30/06.
//  Copyright Sprouted. All rights reserved.
//	All inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>
#import <AddressBook/AddressBook.h>
#import <AddressBook/AddressBookUI.h>

@interface ABRecord (PDAdditions)

- (NSString*) fullname;
- (NSImage*) image;

- (NSString*) note;
- (NSString*) emailAddress;
- (NSString*) website;

- (NSString*) htmlRepresentationWithCache:(NSString*)cachePath;

@end
