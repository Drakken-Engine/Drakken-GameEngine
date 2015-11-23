//
//  Math.swift
//  HelloMetal
//
//  Created by Vinícius Godoy on 02/09/15.
//  Copyright © 2015 BEPiD. All rights reserved.
//

import Foundation
import UIKit

import simd

let EPSILON = Float(0.000001)

//Box2D functions and scales
//--------------------------

public func pixelToMeter(pixel: Float) -> Float {
	return pixel / kWorldScale
}

public func meterToPixel(meter: Float) -> Float {
	return meter * kWorldScale
}

public func pixelToMeter(pixel: Float) -> CGFloat {
	return CGFloat(pixel / kWorldScale)
}

public func meterToPixel(meter: Float) -> CGFloat {
	return CGFloat(meter * kWorldScale)
}

//General matrices functions
//--------------------------

public func newMatrix(values : [Float]) -> float4x4 {
    let P = float4(values[ 0], values[ 1], values[ 2], values[ 3])
    let Q = float4(values[ 4], values[ 5], values[ 6], values[ 7])
    let R = float4(values[ 8], values[ 9], values[10], values[11])
    let S = float4(values[12], values[13], values[14], values[15])
    
    return float4x4([P, Q, R, S])
}

public func toRadians(degrees : Float) -> Float {
    return degrees * Float(M_PI) / 180.0
}

public func toDegrees(radians : Float) -> Float {
	return radians * 180.0 / Float(M_PI)
}

//Projection matrices
//-------------------

public func newPerspective(fovy: Float, aspect: Float, near: Float, far: Float) -> float4x4 {
    let f = 1.0 / tan(fovy / 2.0)
    let nf = 1.0 / (near - far)
    
    return newMatrix([
        f / aspect, 0,                          0,  0,
        0,          f,                          0,  0,
        0,          0,          (far + near) * nf, -1,
        0,          0,    (2.0 * far * near) * nf,  0])
}

public func newOrtho(left: Float, right: Float, bottom: Float, top : Float, near: Float, far: Float) -> float4x4 {
    let lr = 1.0 / (left - right)
    let bt = 1.0 / (bottom - top)
    let nf = 1.0 / (near - far)
    
    return newMatrix([
                  -2.0 * lr,                   0.0,                 0.0,         0.0,
                        0.0,             -2.0 * bt,                 0.0,         0.0,
                        0.0,                   0.0,              2 * nf,         0.0,
        (left + right) * lr,   (top + bottom) * bt,   (far + near) * nf,         1.0
    ]);
}

//View matrices
//-------------

public func newLookAt(eye: float3, center: float3, up: float3) -> float4x4 {
    var z0 = eye.x - center.x;
    var z1 = eye.y - center.y;
    var z2 = eye.z - center.z;

    if (abs(z0) < EPSILON && abs(z1) < EPSILON && abs(z2) < EPSILON) {
            return float4x4(1.0);
    }
    
    var len = 1.0 / sqrt(z0 * z0 + z1 * z1 + z2 * z2)
    z0 *= len
    z1 *= len
    z2 *= len
    
    var x0 = up.y * z2 - up.z * z1;
    var x1 = up.z * z0 - up.x * z2;
    var x2 = up.x * z1 - up.y * z0;
    len = sqrt(x0 * x0 + x1 * x1 + x2 * x2);
    if (len <= EPSILON) {
        x0 = 0.0;
        x1 = 0.0;
        x2 = 0.0;
    } else {
        len = 1.0 / len;
        x0 *= len;
        x1 *= len;
        x2 *= len;
    }
    
    var y0 = z1 * x2 - z2 * x1;
    var y1 = z2 * x0 - z0 * x2;
    var y2 = z0 * x1 - z1 * x0;
    len = sqrt(y0 * y0 + y1 * y1 + y2 * y2);
    if (len <= EPSILON) {
        y0 = 0.0;
        y1 = 0.0;
        y2 = 0.0;
    } else {
        len = 1.0 / len;
        y0 *= len;
        y1 *= len;
        y2 *= len;
    }
    
    let dx = (x0 * eye.x + x1 * eye.y + x2 * eye.z)
    let dy = (y0 * eye.x + y1 * eye.y + y2 * eye.z)
    let dz = (z0 * eye.x + z1 * eye.y + z2 * eye.z)
    
    return newMatrix([
        x0,  y0,  z0, 0.0,
        x1,  y1,  z1, 0.0,
        x2,  y2,  z2, 0.0,
	   -dx, -dy, -dz, 1.0
    ]);
}

//Model matrices
//--------------

public func newScale(scale: Float) -> float4x4 {
    return newScale(scale, y: scale, z: scale);
}

public func newScale(x: Float, y: Float, z: Float) -> float4x4 {
    return newMatrix([
          x, 0.0, 0.0, 0.0,
        0.0,   y, 0.0, 0.0,
        0.0, 0.0,   z, 0.0,
        0.0, 0.0, 0.0, 1.0
    ]);
}

public func newTranslation(p: float3) -> float4x4 {
    return newMatrix([
          1,   0,   0,   0,
          0,   1,   0,   0,
          0,   0,   1,   0,
	    p.x, p.y, p.z,   1
    ]);
}

public func newRotation(angle: Float, axis : float3) -> float4x4 {
    var len = length(axis);
    
    if (len <= EPSILON) {
        return float4x4(1.0)
    }
    
    len = 1.0 / len
    
    let x = axis.x * len
    let y = axis.y * len
    let z = axis.z * len
    
    let s = sin(angle);
    let c = cos(angle);
    let t = 1.0 - c;
    
    return newMatrix([
        x * x * t + c,
        y * x * t + z * s,
        z * x * t - y * s,
        0.0,
        
        x * y * t - z * s,
        y * y * t + c,
        z * y * t + x * s,
        0.0,
        
        x * z * t + y * s,
        y * z * t - x * s,
        z * z * t + c,
        0.0,
        
        0.0,
        0.0,
        0.0,
        1.0
    ])
}

public func newRotationX(angle: Float) -> float4x4 {
    let s = sin(angle)
    let c = cos(angle)
    return newMatrix([
        1.0, 0.0, 0.0, 0.0,
        0.0,   c,   s, 0.0,
        0.0,  -s,   c, 0.0,
        0.0, 0.0, 0.0, 1.0
    ])
}

public func newRotationY(angle: Float) -> float4x4 {
    let s = sin(angle)
    let c = cos(angle)
    return newMatrix([
          c, 0.0,  -s, 0.0,
        0.0, 1.0, 0.0, 0.0,
          s, 0.0,   c, 0.0,
        0.0, 0.0, 0.0, 1.0
    ])
}

public func newRotationZ(angle: Float) -> float4x4 {
    let s = sin(angle)
    let c = cos(angle)
    return newMatrix([
          c,   s, 0.0, 0.0,
         -s,   c, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        0.0, 0.0, 0.0, 1.0
    ])
}

