//
//  PDDocument_PDCategory.h
//  SproutedUtilities
//
//  Created by Philip Dow on 1/19/07.
//  Copyright Sprouted. All rights reserved.
//	All inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface PDFDocument (PDCategory )

- (NSImage*) thumbnailForPage:(unsigned int)index size:(float)edge;
- (NSImage*) efficientThumbnailForPage:(unsigned int)index size:(float)edge;

@end
