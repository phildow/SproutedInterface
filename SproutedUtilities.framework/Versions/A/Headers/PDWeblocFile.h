//
//  PDWebLoc.h
//  SproutedUtilities
//
//  Created by Philip Dow on 10/20/06.
//  Copyright Sprouted. All rights reserved.
//  Significant portions of code originally in NTWeblocFile class, CocoaTech Open Source
//	All inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>

@interface PDWeblocFile : NSObject {
	
	NSAttributedString* _attributedString;
    
    NSString* _displayName;
    NSURL* _url;
	
}

+ (NSString*) weblocExtension;

// can be NSString or NSAttributedString
+ (id)weblocWithString:(id)string;
+ (id)weblocWithURL:(NSURL*)url;

- (id) initWithContentsOfFile:(NSString*)filename;

- (void)setDisplayName:(NSString*)name;
- (NSString*)displayName;

- (void)setURL:(NSURL*)url;
- (NSURL*) url;

- (void)setString:(id)string;

- (BOOL)isHTTPWeblocFile;
- (BOOL)isServerWeblocFile;

- (BOOL)writeToFile:(NSString*)path;

- (NSData*)dragDataWithEntries:(NSArray*)entries;

@end

#pragma mark -

@interface WLDragMapEntry : NSObject
{
    OSType _type;
    ResID _resID;
}

+ (id)entryWithType:(OSType)type resID:(int)resID;

- (OSType)type;
- (ResID)resID;
- (NSData*)entryData;

@end
