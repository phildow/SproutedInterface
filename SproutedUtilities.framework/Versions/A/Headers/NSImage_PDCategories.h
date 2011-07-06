//
//  NSImage_PDCategories.h
//  SproutedUtilities
//
//  Created by Philip Dow on 9/9/06.
//  Copyright Sprouted. All rights reserved.
//	All inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>


@interface NSImage (PDCategories)

+ (NSImage*) imageByReferencingImageNamed:(NSString*)imageName;

+ (BOOL) canInitWithFile:(NSString*)path;
+ (NSImage*) iconWithContentsOfFile:(NSString*)path edgeSize:(float)size inset:(float)padding;
+ (NSImage *)imageWithPreviewOfFileAtPath:(NSString *)path ofSize:(NSSize)size asIcon:(BOOL)icon;
	// from Matt Gemmell

+ (NSImage *) imageFromCIImage:(CIImage *)ciImage;
+ (CIImage *) CIImageFromImage:(NSImage*)anImage;

- (NSImage *) reflectedImage:(float)fraction;
- (NSImage*) imageWithWidth:(float)width height:(float)height;
- (NSImage*) imageWithWidth:(float)width height:(float)height inset:(float)inset;

- (NSData*) pngData;
- (NSAttributedString*) attributedString:(int)qual maxWidth:(int)mWidth;

@end
