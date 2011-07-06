//
//  PDFileInfoView.h
//  SproutedInterface
//
//  Created by Philip Dow on 6/17/07.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>

typedef UInt32 PDFileInfoAlignment;
enum PDInfoAlignment {
	PDFileInfoAlignLeft = 0,
	PDFileInfoAlignRight = 1
};


@interface PDFileInfoView : NSView {
	NSURL *url;
	NSImageCell *cell;
	PDFileInfoAlignment viewAlignment;
}

- (NSURL*) url;
- (void) setURL:(NSURL*)aURL;

- (void) _drawInfoForFile;

@end
