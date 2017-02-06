//
//  ViewController.m
//  opencv-osx
//
//  Created by Giovanni Murru on 01/02/2017.
//  Copyright © 2017 Giovanni Murru. All rights reserved.
//

#import "ViewController.h"
#include "FaceDetector.hpp"

using namespace gm;

@implementation ViewController
{
    std::shared_ptr<FaceDetector> m_face_detector;
}

- (void)viewDidAppear {
    [super viewDidAppear];
    
    NSString *xmlPath = [[NSBundle mainBundle ] pathForResource:@"haarcascade_frontalface_default"
                                                         ofType: @"xml"];
    m_face_detector = std::make_shared<FaceDetector>([xmlPath cStringUsingEncoding:NSUTF8StringEncoding]);
    m_face_detector->executeVideoCapture();
    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
