//
//  ViewController.m
//  opencv-osx
//
//  Created by Giovanni Murru on 01/02/2017.
//  Copyright © 2017 Giovanni Murru. All rights reserved.
//

#import "ViewController.h"
#import <opencv2/opencv.hpp>
#import <opencv2/video.hpp>
#import <opencv2/objdetect.hpp>
#include <opencv2/video/tracking.hpp>
#include <opencv2/highgui/highgui.hpp>

using namespace cv;
using namespace std;

@implementation ViewController
{
    std::shared_ptr<CascadeClassifier> m_cascade;
}

- (void)viewDidAppear {
    [super viewDidAppear];
    
    NSString *xmlPath = [[NSBundle mainBundle ] pathForResource:@"haarcascade_frontalface_default"
                                                         ofType: @"xml"];
    NSLog(@"%@", xmlPath);
    std::string xml_path = [xmlPath cStringUsingEncoding:NSUTF8StringEncoding];
    m_cascade = make_shared<CascadeClassifier>();
    m_cascade->load(xml_path.c_str());
    
    // Do any additional setup after loading the view.
    [self executeVideoCapture];
}

- (void)executeVideoCapture
{
    
    cv::VideoCapture cap;
    
    cap.open(0);
    
    cap.set(CV_CAP_PROP_FRAME_WIDTH,320);
    cap.set(CV_CAP_PROP_FRAME_HEIGHT,240);
    
    if( !cap.isOpened() )
    {
        std::cerr << "***Could not initialize capturing...***\n";
        std::cerr << "Current parameter's value: \n";
    }
    
    cv::Mat frame;
    while(YES)
    {
        cap >> frame;
        if(frame.empty()){
            std::cerr<<"frame is empty"<<std::endl;
            break;
        }
        
        [self processImage:frame];
        
        cv::imshow("", frame);
        cv::waitKey(10);
    }
}


- (void)processImage:(cv::Mat &)image
{
    CFTimeInterval t1 = CACurrentMediaTime();
    
    cvSetErrMode( CV_ErrModeParent );
    
    //(const Mat& img, CV_OUT vector<Rect>& foundLocations,
    //double hitThreshold=0, Size winStride=Size(),
    //Size padding=Size(), double scale=1.05,
    //double finalThreshold=2.0, bool useMeanshiftGrouping = false)
    
    
    int flags = cv::CASCADE_FIND_BIGGEST_OBJECT | cv::CASCADE_DO_ROUGH_SEARCH;
    std::vector<cv::Rect> faces;
    cv::Size minFeatureSize = cv::Size(20, 20);
    Mat gray_image;
    if (image.channels() > 1)
    {
        cvtColor(image, gray_image, CV_BGR2GRAY );
    }
    m_cascade->detectMultiScale( gray_image, faces, 1.3, 7, flags, minFeatureSize);
    gray_image.release();
    //    faces   = cvHaarDetectObjects( &tmp_image, _cascade, storage, ( float )1.2, 2, CV_HAAR_DO_CANNY_PRUNING, cvSize( 20, 20 ) );
    
    if (faces.size() > 0)
    {
        for(int i = 0; i < faces.size(); i++ )
        {
            cv::Rect rect = faces[i];
            rectangle(image, cv::Point(rect.x, rect.y), cv::Point(rect.x+rect.width, rect.y+rect.height), Scalar(0,255,0,255), 4);
        }
    }
    
    CFTimeInterval deltaTime = CACurrentMediaTime() - t1;
    NSLog(@"delta time %.0fms", deltaTime*1000);
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
