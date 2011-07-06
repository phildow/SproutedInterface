//
//  PDWebArchive.h
//  SproutedUtilities
//
//  Created by Philip Dow on 6/1/06.
//  Copyright Sprouted. All rights reserved.
//	All inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface PDWebArchive : WebArchive {
	BOOL _finished_loading;
}

- (NSString*) stringValue;

@end

/*
@interface NSView (WebArchiveExtras)

- (NSString*) string;

@end
*/