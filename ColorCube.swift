/*
* RGB color cube class
*
*
*/

import Foundation

class ColorCube:CustomStringConvertible {

    let depth: Int = 0
    let cube:CubeNode = CubeNode(level:8)
    var colorCount = 0

    class CubeNode: Nodes{
        let level:Int
        private(set) var cubes:UInt8 = 0
        private(set) var cubesCount = 0
        private(set) var colorsCount = 0
        private(set) var cubesArray: [Nodes?] = Array(repeating:nil, count:8)
        
        init(level:Int){
            self.level = level
        }
        
        func addNode(level:Int)->Nodes{
            if level == 0 {
                return ColorNode()
            }
            return CubeNode(level:level)
        
        }
        
        func addColor(_ color:Color)->Bool{
            
            let index    = CubeNode.getIndexInCubeNodeFor(color:color, at:level)
            let position = CubeNode.getPositionInNodeFor(index:index)
            
            if (cubes & position) != position {
                
                let node = addNode(level:level-1)
                
                if node is CubeNode{
                
                    cubesCount+=1
                }
                
                cubesArray[Int(index)]=Optional(node)
                cubes = cubes | position
            }
            if cubesArray[Int(index)]!.addColor(color) {
                colorsCount+=1
                return true
            }
            return false
        }
        
        func getColorNodes()->[Nodes]{
            
            var ret:[Nodes]=[]

            for i:UInt8 in 0...7 {
                
                if (cubes & (1 << i)) != 0 {
                    
                    cubesArray[Int(i)]!.getColorNodes().forEach({e in ret.append(e)})
                }
                
            }
            return ret
            
        }
        
        func getColorNodeFor(color:Color)->ColorNode?{
            
            let index    = CubeNode.getIndexInCubeNodeFor(color:color, at:level)
            let position = CubeNode.getPositionInNodeFor(index:index)
            
            guard (cubes & position) == position else{
                return nil
            }
            
            let node = cubesArray[Int(index)]!
            
            return node.getColorNodeFor(color:color)
            
        }
        
        class func getIndexInCubeNodeFor(color:Color, at level:Int)->Int{
            
            return (((color.r & (1 << level)) >> level) << 2) | (((color.g & (1 << level)) >> level)<<1) | ((color.b & (1 << level)) >> level)
        }
        
        class func getPositionInNodeFor(index:Int)->UInt8{
            
            return UInt8(1<<index)
        }
        
        class func getIndexFor(position:UInt8)->Int{
            var ret:Int = 0
            
            for i:UInt8 in 0...7{
                
                ret += ret + Int(((position >> i) & 1))
                
            }
            
            return ret   
        }
    }
    
    class ColorNode: Nodes, CustomStringConvertible {
    
       private(set) var colors:UInt8 = 0
       private(set) var count:UInt8 = 0
       private(set) var stego:UInt8? = 0
       
       var description:String {
           return "\(colors)"
       }  
       
       func changeColors(with newColors:UInt8){
           
           
           guard countCheck(newColors) else{
               print("wrong color count")
               return
           }
           print("old colors \(colors)\tnewColors \(newColors)")
           colors=newColors
           return
           
       }
       
       func addStego(_ stego:UInt8){
           
           guard countCheck(stego) else{
               print("wrong stego")
               return
           }
           
           self.stego = stego
           return
           
       }
       
       func countCheck(_ a:UInt8)->Bool{
       
           return count == ColorNode.bitCount(a)
       }
       
       class func bitCount(_ a:UInt8)->UInt8{
            
            var countA:UInt8 = 0
            
            for i:UInt8 in 0...7 {
               
               countA += ((a & (1 << i)) >> i)
               
           }
           return countA
       }
       

       
       class func bitCountCompare(_ a:UInt8, _ b:UInt8)->Bool{
          /* 
           var countA:UInt8 = 0
           var countB:UInt8 = 0
           
           for i:UInt8 in 0...7 {
               
               countA = ((a & (1 << i)) >> i)
               countA = ((a & (1 << i)) >> i)
               
           }
          */ 
           return bitCount(a) == bitCount(b)
       }
       
       // func addColor returns true if unique color was added
       func addColor(_ color:Color)->Bool{
           
           let tmp = colors | ColorNode.getPositinInColorNodeFor(color:color)
           
           let ret:Bool = (tmp != colors)
           
           colors=tmp
           
           if ret {
                count += 1
           }
           
           return ret
       }
       func getColorNodes()->[Nodes]{
           
           let ret:[Nodes] = [self]
            
           return ret
           
       }
       
       func getColorNodeFor(color:Color)->ColorNode?{
           
           return self
       }
       
       class func getPositinInColorNodeFor(color:Color)->UInt8{
           return UInt8((1 << (((color.r & 1) << 2) | ((color.g & 1) << 1) | (color.b & 1))))
       }

       
    }
    
    init(with ids:ImageDataSource){

        while let c = ids.nextPixel{

            if cube.addColor(c) {
                colorCount += 1
            }

        }

    }
    
    func getColorNodeFor(color:Color)->ColorNode?{
       return cube.getColorNodeFor(color:color)
    }
    
    func getColorNodes()->[ColorNode]{
        return cube.getColorNodes() as! [ColorNode]
    }
    
    var description:String {
        return "colorCount: \(colorCount)"
    }
    
    

    
}
