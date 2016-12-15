/*
* Data source for stego
*
*
*/

class DataSource : CustomStringConvertible {
    let data:Data
    var iterator:Data.Iterator
    var lastByteBits:UInt8=8
    var lastByte:UInt8=0
    
    var description:String {
        return data.description
    }
    
    init(with data:Data){
        self.data = data
        iterator = data.makeIterator()
    }
    
    init(with str:String){
        guard let d = str.data(using:.utf8) else{
            data = Data()
            iterator = data.makeIterator()
            print("Source data loading error")
            return
        }
        data=d
        iterator = data.makeIterator()
    }
    
    func nextByte()->UInt8?{
        guard let newByte = iterator.next() else{
                return nil
            }
        lastByte = newByte
        lastByteBits=0
       
        return lastByte
    }
    
    func getNextBit()->UInt8?{
        
        if lastByteBits > 7 {
            guard nextByte() != nil else{
                return nil
            }
        }
        
        let index:UInt8 = UInt8(1) << lastByteBits
        let ret:UInt8 = (lastByte & index) >> lastByteBits
        lastByteBits+=1
        return ret
   
    }
    
    class func TreeBitsToUInt8(a:UInt8,b:UInt8,c:UInt8)->UInt8{
        
        let aa = a << 2
        let bb = b << 1
        
        let index = aa + bb + c
        
        return 1 << index
        
    } 
        
}
