/*
* Color cube nodes
*
*
*/

protocol Nodes {
    func addColor(_ color:Color)->Bool
    func getColorNodes()->[Nodes]
    func getColorNodeFor(color:Color)->ColorCube.ColorNode?
}
