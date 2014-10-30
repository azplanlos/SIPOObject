//
//  SIPODataView.m
//  SIPropertyObjects
//
//  Created by Andreas Zöllner on 28.10.14.
//  Copyright (c) 2014 Studio Istanbul Medya Hiz. Tic. Ltd. Sti. All rights reserved.
//

#import "SIPODataView.h"

@implementation SIPODataView
@synthesize contentData;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [SIPODataView exposeBinding:@"contentData"];
    }
    [self registerForDraggedTypes:
     [NSArray arrayWithObjects:NSFilenamesPboardType,nil]];
    
    return self;
}

- (NSDragOperation)draggingEntered:(id )sender
{
    if ((NSDragOperationGeneric & [sender draggingSourceOperationMask])
        == NSDragOperationGeneric) {
        
        return NSDragOperationGeneric;
        
    } // end if
    
    // not a drag we can use
    return NSDragOperationNone;
    
} // end draggingEntered

- (BOOL)prepareForDragOperation:(id )sender {
    return YES;
} // end prepareForDragOperation




- (BOOL)performDragOperation:(id )sender {
    NSPasteboard *zPasteboard = [sender draggingPasteboard];
    // define the images  types we accept
    // NSPasteboardTypeTIFF: (used to be NSTIFFPboardType).
    // NSFilenamesPboardType:An array of NSString filenames
    NSArray *zImageTypesAry = [NSArray arrayWithObjects:NSPasteboardTypeTIFF,
                               NSFilenamesPboardType, nil];
    
    NSString *zDesiredType =
    [zPasteboard availableTypeFromArray:zImageTypesAry];
    
    
    if ([zDesiredType isEqualToString:NSFilenamesPboardType]) {
        // the pasteboard contains a list of file names
        //Take the first one
        NSArray *zFileNamesAry =
        [zPasteboard propertyListForType:@"NSFilenamesPboardType"];
        NSString *zPath = [zFileNamesAry objectAtIndex:0];
        self.contentData = [NSData dataWithContentsOfFile:zPath];
        NSLog(@"read data wit %li bytes", contentData.length);
        return YES;
        
    }// end if
    
    //this cant happen ???
    NSLog(@"Error MyNSView performDragOperation");
    return NO;
    
} // end performDragOperation


- (void)concludeDragOperation:(id )sender {
    [self setNeedsDisplay:YES];
    [self.delegate updateDataValue];
} // end concludeDragOperation


- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    //// Color Declarations
    NSColor* color = [NSColor colorWithCalibratedRed: 1 green: 1 blue: 1 alpha: 1];
    NSColor* color2 = [NSColor colorWithCalibratedRed: 0.5 green: 0.5 blue: 0.5 alpha: 1];
    
    //// Shadow Declarations
    NSShadow* shadow = [[NSShadow alloc] init];
    [shadow setShadowColor: [[NSColor blackColor] colorWithAlphaComponent: 0.47]];
    [shadow setShadowOffset: NSMakeSize(4.1, -5.1)];
    [shadow setShadowBlurRadius: 5];
    
    NSString* text4Content = @"Drop data file here to include contents.";

    
    //// Frames
    NSRect frame = NSMakeRect(0, -1, 201, 201);
    if (self.contentData && self.contentData.length > 0) {
        
        
        
        //// Abstracted Attributes
        NSString* text2Content = [NSString stringWithFormat:@"Size: %li bytes", contentData.length];
        
        
        //// Group
        {
            //// Bezier Drawing
            NSBezierPath* bezierPath = [NSBezierPath bezierPath];
            [bezierPath moveToPoint: NSMakePoint(NSMinX(frame) + 59.5, NSMaxY(frame) - 40.5)];
            [bezierPath lineToPoint: NSMakePoint(NSMinX(frame) + 59.5, NSMaxY(frame) - 139.5)];
            [bezierPath lineToPoint: NSMakePoint(NSMinX(frame) + 141.5, NSMaxY(frame) - 139.5)];
            [bezierPath lineToPoint: NSMakePoint(NSMinX(frame) + 141.5, NSMaxY(frame) - 58.5)];
            [bezierPath lineToPoint: NSMakePoint(NSMinX(frame) + 122.5, NSMaxY(frame) - 39.5)];
            [bezierPath closePath];
            [bezierPath setMiterLimit: 0];
            [bezierPath setLineCapStyle: NSRoundLineCapStyle];
            [bezierPath setLineJoinStyle: NSBevelLineJoinStyle];
            [NSGraphicsContext saveGraphicsState];
            [shadow set];
            [color setFill];
            [bezierPath fill];
            [NSGraphicsContext restoreGraphicsState];
            
            [color2 setStroke];
            [bezierPath setLineWidth: 4];
            [bezierPath stroke];
            
            
            //// Text Drawing
            NSRect textRect = NSMakeRect(NSMinX(frame) + 66, NSMinY(frame) + NSHeight(frame) - 137, 70, 97);
            NSMutableParagraphStyle* textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
            [textStyle setAlignment: NSLeftTextAlignment];
            
            NSDictionary* textFontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                [NSFont fontWithName: @"Helvetica" size: 12], NSFontAttributeName,
                                                color2, NSForegroundColorAttributeName,
                                                textStyle, NSParagraphStyleAttributeName, nil];
            
            [@"10101011 101010101010101010101001010101010101010101010101010101010101001010101010101010011010101010100110" drawInRect: NSOffsetRect(textRect, 0, 1) withAttributes: textFontAttributes];
        }
        
        
        //// Text 2 Drawing
        NSRect text2Rect = NSMakeRect(NSMinX(frame) + 37, NSMinY(frame) + NSHeight(frame) - 191, 127, 33);
        NSMutableParagraphStyle* text2Style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        [text2Style setAlignment: NSCenterTextAlignment];
        
        NSDictionary* text2FontAttributes = [NSDictionary dictionaryWithObjectsAndKeys: 
                                             [NSFont fontWithName: @"Helvetica" size: 12], NSFontAttributeName,
                                             [NSColor blackColor], NSForegroundColorAttributeName,
                                             text2Style, NSParagraphStyleAttributeName, nil];
        
        [text2Content drawInRect: NSOffsetRect(text2Rect, 0, 1) withAttributes: text2FontAttributes];
    } else {
        //// noData
        {
            //// Text 3 Drawing
            NSBezierPath* text3Path = [NSBezierPath bezierPath];
            [text3Path moveToPoint: NSMakePoint(NSMinX(frame) + 75.43, NSMaxY(frame) - 104.89)];
            [text3Path lineToPoint: NSMakePoint(NSMinX(frame) + 75.43, NSMaxY(frame) - 93.42)];
            [text3Path lineToPoint: NSMakePoint(NSMinX(frame) + 93.45, NSMaxY(frame) - 93.42)];
            [text3Path lineToPoint: NSMakePoint(NSMinX(frame) + 93.45, NSMaxY(frame) - 75.41)];
            [text3Path lineToPoint: NSMakePoint(NSMinX(frame) + 105, NSMaxY(frame) - 75.41)];
            [text3Path lineToPoint: NSMakePoint(NSMinX(frame) + 105, NSMaxY(frame) - 93.42)];
            [text3Path lineToPoint: NSMakePoint(NSMinX(frame) + 123.02, NSMaxY(frame) - 93.42)];
            [text3Path lineToPoint: NSMakePoint(NSMinX(frame) + 123.02, NSMaxY(frame) - 104.89)];
            [text3Path lineToPoint: NSMakePoint(NSMinX(frame) + 105, NSMaxY(frame) - 104.89)];
            [text3Path lineToPoint: NSMakePoint(NSMinX(frame) + 105, NSMaxY(frame) - 123)];
            [text3Path lineToPoint: NSMakePoint(NSMinX(frame) + 93.45, NSMaxY(frame) - 123)];
            [text3Path lineToPoint: NSMakePoint(NSMinX(frame) + 93.45, NSMaxY(frame) - 104.89)];
            [text3Path lineToPoint: NSMakePoint(NSMinX(frame) + 75.43, NSMaxY(frame) - 104.89)];
            [text3Path closePath];
            [color2 setFill];
            [text3Path fill];
            
            ////// Text 3 Inner Shadow
            NSRect text3BorderRect = NSInsetRect([text3Path bounds], -shadow.shadowBlurRadius, -shadow.shadowBlurRadius);
            text3BorderRect = NSOffsetRect(text3BorderRect, -shadow.shadowOffset.width, -shadow.shadowOffset.height);
            text3BorderRect = NSInsetRect(NSUnionRect(text3BorderRect, [text3Path bounds]), -1, -1);
            
            NSBezierPath* text3NegativePath = [NSBezierPath bezierPathWithRect: text3BorderRect];
            [text3NegativePath appendBezierPath: text3Path];
            [text3NegativePath setWindingRule: NSEvenOddWindingRule];
            
            [NSGraphicsContext saveGraphicsState];
            {
                NSShadow* shadowWithOffset = [shadow copy];
                CGFloat xOffset = shadowWithOffset.shadowOffset.width + round(text3BorderRect.size.width);
                CGFloat yOffset = shadowWithOffset.shadowOffset.height;
                shadowWithOffset.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
                [shadowWithOffset set];
                [[NSColor grayColor] setFill];
                [text3Path addClip];
                NSAffineTransform* transform = [NSAffineTransform transform];
                [transform translateXBy: -round(text3BorderRect.size.width) yBy: 0];
                [[transform transformBezierPath: text3NegativePath] fill];
            }
            [NSGraphicsContext restoreGraphicsState];
            
            
            
            //// Text 4 Drawing
            NSRect text4Rect = NSMakeRect(NSMinX(frame) + 16, NSMinY(frame) + NSHeight(frame) - 193, 170, 45);
            NSMutableParagraphStyle* text4Style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
            [text4Style setAlignment: NSCenterTextAlignment];
            
            NSDictionary* text4FontAttributes = [NSDictionary dictionaryWithObjectsAndKeys: 
                                                 [NSFont fontWithName: @"Helvetica" size: 12], NSFontAttributeName,
                                                 [NSColor blackColor], NSForegroundColorAttributeName,
                                                 text4Style, NSParagraphStyleAttributeName, nil];
            
            [text4Content drawInRect: NSOffsetRect(text4Rect, 0, 1) withAttributes: text4FontAttributes];
        }

    }
}

@end
