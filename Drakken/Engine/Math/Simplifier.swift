import Foundation
import UIKit

func toRadians(degrees : CGFloat) -> CGFloat {
    return degrees * CGFloat(M_PI) / 180.0
}

public func subtract(pt1 : CGPoint, pt2 : CGPoint) -> CGPoint {
    return CGPoint(x: pt1.x - pt2.x, y: pt1.y - pt2.y);
}

public func sizeSqr(pt : CGPoint) -> CGFloat {
    return pt.x * pt.x + pt.y * pt.y;
}

public func distanceSqr(pt1 : CGPoint, pt2 : CGPoint) -> CGFloat {
    return sizeSqr(subtract(pt1, pt2: pt2));
}

public func angle(pt : CGPoint) -> CGFloat {
    return atan2(pt.y, pt.x);
}

public protocol Simplifier {
    func simplify(polygons : [[CGPoint]]) -> [[CGPoint]]
}

public class AbstractSimplifier : Simplifier
{
    func reduce(polygon : [CGPoint]) -> [CGPoint] {
        return polygon
    }
    
    public func simplify(polygons : [[CGPoint]]) -> [[CGPoint]] {
        var result = [[CGPoint]]()
        for polygon in polygons {
            result.append(reduce(polygon))
        }
        return result;
    }
}

public class DistanceSimplifier : AbstractSimplifier {
    var distance : CGFloat
    
    init(distance : CGFloat) {
        self.distance = distance
    }
    
    override func reduce(polygon: [CGPoint]) -> [CGPoint] {
        if (polygon.count <= 4) {
            return polygon
        }
        var reduced = [CGPoint]()
        var begin = polygon[0]
        var end = polygon[1]
        reduced.append(begin)
        
        for var i = 2; i < polygon.count; i++ {
            if (distanceSqr(begin, pt2: end) > (distance * distance)) {
                reduced.append(end)
                begin = end
            }
            end = polygon[i]
		}
		reduced.append(end)
		
        return reduced;
    }
}

public class DistanceAngleSimplifier : AbstractSimplifier {
    var distance : CGFloat
    var maxAngle : CGFloat
    
    init(distance : CGFloat, maxAngle : CGFloat) {
        self.distance = distance;
        self.maxAngle = toRadians(maxAngle);
    }
    
    override func reduce(polygon: [CGPoint]) -> [CGPoint] {
        var polygonResult = DistanceSimplifier(distance: distance).reduce(polygon)
        if (polygonResult.count <= 3) {
            return polygonResult
        }
        
        var p1 = polygonResult[0]
        var p2 = polygonResult[1]
        var result = [CGPoint]();
        result.append(p1);
        
        for var i = 2; i < polygonResult.count; i++ {
            let p3 = polygonResult[i];
            let angle1 = angle(subtract(p1, pt2: p2));
            let angle2 = angle(subtract(p2, pt2: p3));
            if abs(angle1 - angle2) < maxAngle {
                p2 = p3
            } else {
                result.append(p2);
                p1 = p2
                p2 = p3
            }
        }
        result.append(polygon[polygon.count-1]);
        return result
    }
}