//
//  MediaViewer.h
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>

@class MediaContentController;

/*
@class AudioViewController;
@class MovieViewController;
@class WebViewController;
@class PDFViewController;
@class ImageViewController;
@class AddressRecordController;
*/

@interface MediaViewer : NSWindowController
{
	NSURL *homeURL;
	MediaContentController *_contentController;
	IBOutlet NSView *contentPlaceholder;
}

+ (BOOL) canDisplayMediaOfType:(NSString*)uti url:(NSURL*)aURL;
- (id) initWithURL:(NSURL*)url uti:(NSString*)uti;

- (id) representedObject;
- (void) setRepresentedObject:(id)anObject;

- (MediaContentController*) contentController;

- (BOOL) highlightString:(NSString*)aString;

- (IBAction) printDocument:(id)sender;

- (IBAction) save:(id)sender;
- (IBAction) exportSelection:(id)sender;

@end

@interface MediaViewer (CustomMenuSupport)

- (void) performCustomFindPanelAction:(id)sender;
- (void) performCustomTextSizeAction:(id)sender;

@end
