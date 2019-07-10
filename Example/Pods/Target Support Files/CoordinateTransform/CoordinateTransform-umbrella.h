#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CoorTran.h"
#import "CoorTranUtil.h"
#import "GaoDeCoorTrans.h"
#import "NNMatrix.h"
#import "TransferStruct.h"
#import "TransParamParser.h"

FOUNDATION_EXPORT double CoordinateTransformVersionNumber;
FOUNDATION_EXPORT const unsigned char CoordinateTransformVersionString[];

