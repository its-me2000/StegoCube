/*
* Class for access image raw data
*
*
*/

import Foundation

class ImageDataSource:CustomStringConvertible {
    
    // data - pointer to image bitmap in memory
    let data: UnsafeMutableRawBufferPointer
    
    // bitmapInfo - rules on structure of data
    let bitmapInfo: BitmapInfo
    
    // next - method to get next pixel color from data. this will set in initializer depending on bitmapInfo
    var next: ()->Color? = {nil}
    
    // nextPixel - same as next, but made as computable property    
    var nextPixel:Color? {get{return next()}}
    
    // getPixelAt - method to get pixel color on given coordinates 
    var getPixelAt: (_:Int, _:Int)->Color? = {_,_ in nil}
   
    
    // iterator - iterator for use in next methods
    var iterator:UnsafeMutableRawBufferPointer.Iterator
    
    var description:String {
        return String("base adress \(data.baseAddress!) \n bytes count \(data.count) \n pixels? \(data.count/4)")
    }
    
    init(data:UnsafeMutableRawBufferPointer,bitmapInfo:BitmapInfo){
    
        self.data       = data
        self.bitmapInfo = bitmapInfo
        self.iterator   = data.makeIterator()
        
        switch (bitmapInfo){
        
            case let bi where bi.colorMode == .RGBA &&
                                    bi.bpc == 8888:
                self.next       = self.NextAsRGBA8888
                self.getPixelAt = self.getPixelAsRGBA8888At
            
            default:
                self.next       = self.NextAsRGBA8888
                self.getPixelAt = self.getPixelAsRGBA8888At
        }   
        

    }
    func NextAsRGBA8888()->Color?{
    
        guard let r = iterator.next(),
              let g = iterator.next(),
              let b = iterator.next(),
              let a = iterator.next() else{
        
            resetIterator()
            return nil
        }
        return Color(r:r,g:g,b:b,a:a)
        
    }
    
    func getPixelAsRGBA8888At(x:Int,y:Int)->Color?{
    
        guard let index = getValidIndexOfPixelAt(x:x, y:y) else {
            return nil
        }
        return Color(r:data[index],
                     g:data[index+1],
                     b:data[index+2],
                     a:data[index+3])
        
    }
    
    func resetIterator(){
        iterator = data.makeIterator()
    }
    
@discardableResult func setPixelAsRGBA8888At(x:Int, y:Int, withColor color:Color)->Bool{
        
        guard let index = getValidIndexOfPixelAt(x:x, y:y) else {
            return false
        }
        let c=color.getUInt8RGBAValues()
        data[index]   = c.r
        data[index+1] = c.g
        data[index+2] = c.b
        data[index+3] = c.a
        return true    
    }
    
    func getValidIndexOfPixelAt(x:Int,y:Int)->Int?{
        let index = x * (y * bitmapInfo.width)
        guard (index > 0) && ((index + 3) < data.count) else {
            print("getValidIndex \(index)")
            return nil
        }
        return index
    }

}
