//
//  PDWebArchiveMiner.h
//  SproutedUtilities
//
//  Created by Philip Dow on 3/30/07.
//  Copyright Sprouted. All rights reserved.
//	All inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>
#import <WebKit/Webkit.h>

@interface PDWebArchiveMiner : NSObject {
	WebArchive *webArchive;
	NSArray *resources;
	NSString *plaintextRepresentation;
}

- (id) initWithWebArchive:(WebArchive*)aWebArchive;

+ (NSString*) plaintextRepresentationForWebArchive:(WebArchive*)aWebArchive;
+ (NSString*) plaintextRepresentationForResource:(WebResource*)aResource;
+ (NSArray*) resourcesForWebArchive:(WebArchive*)aWebArchive;

- (WebArchive*) webArchive;
- (void) setWebArchive:(WebArchive*)aWebArchive;

- (NSArray*) resources;
- (NSString*) plaintextRepresentation;

- (NSArray*) _resourcesForWebArchive:(WebArchive*)webArchive;

@end
