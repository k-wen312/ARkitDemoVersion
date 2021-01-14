//
//  ViewController.swift
//  ARkitDemoVersion
//
//  Created by 黃湛仁 on 2020/12/1.
//
import UIKit
import ARKit
import CoreMotion
class ViewController: UIViewController , UITextFieldDelegate{
    

    @IBOutlet var distance: UILabel!
    

    @IBOutlet weak var angleLabel: UITextField!
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var centerView: CenterView!
    
    @IBAction func scanButton(_ sender: Any) {
        didCatch()
    }
    var motion = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        motion.deviceMotionUpdateInterval = 1.0
        myGyroscope()
        //Textfield.delegate = self
        //addBox()
        //addTapGestureToSceneView()
        // Do any additional setup after loading the view.
        //sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    var height = 0.0
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            height = Double(text) ?? 0.0
            print(height)
        }
    }
    
    var distance2 = 0.0
    func myGyroscope(){
        motion.startDeviceMotionUpdates(to: OperationQueue.current!) {(data, error) in print(data as Any)
            if let trueData = data {
                self.view.reloadInputViews()
                let x = trueData.attitude.yaw

                var angle = Double(x).rounded(toPlace:3)
                self.angleLabel.text = "旋轉角度：\(angle)"
                self.distance2 = self.height * tan(angle)
                
                
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
      }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func didCatch(){  //用按鈕抓特徵點
        let catchLocation = sceneView.center
        let hitTestResults = sceneView.hitTest(catchLocation)
        
        guard let node = hitTestResults.first?.node else {
            let hitTestResultWithFeaturePoints = sceneView.hitTest(catchLocation, types: .featurePoint)
            
            if let hitTestResultWithFeaturePoints = hitTestResultWithFeaturePoints.last{
                let translation = hitTestResultWithFeaturePoints.worldTransform.translation
                print(translation)
                let x = (translation.x * 100)
                let z = (translation.z * 100)
                distance.text = "距離：\( pow(( pow(x, 2) + pow(z, 2)), 0.5) ) 公分"
                addBox(x: translation.x, y: translation.y, z: translation.z)
            }
            return
        }
        node.removeFromParentNode()
    }
    
    func addBox(x: Float = 0, y: Float = 0, z: Float = -0.2){   //提供默認的參數值，意味著我們可以像在viewDidLoad()中那樣無需指定x,y,z座標即可調用addBox()
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)    //創建一個盒子 1 Float = 1 meter
       
       let boxNode = SCNNode() //創建一個框節點，表示3D物件的位置及座標，節點本身沒有可見的內容
       boxNode.geometry = box  //可通過給他一個形狀來給他可見的內容，在此，將框節點的幾何(geometry)形狀設置為box
       boxNode.position = SCNVector3(x, y, z)   //正x在右邊，正y在上面，正z向後，負z向前
       
       //let scene = SCNScene()  //創建一個場景，是要在視圖中顯示的SceneKit場景
        sceneView.scene.rootNode.addChildNode(boxNode)    //將框節點加到場景的根節點，現在的場景有一個盒子，該框位於設備攝像頭的中央，相對於相機向前0.2米
       //sceneView.scene = scene //顯示剛剛創建的場景
   }
    
}


extension float4x4{
    var translation: SIMD3<Float>{
        let translation = self.columns.3
        return SIMD3<Float>(translation.x, translation.y, translation.z)
    }
}   //此擴展將矩陣轉換為float3，為我們提供了矩陣的x,y,z

extension Double {
    func rounded (toPlace places:Int) -> Double{
        let divisor = pow(10.0 , Double(places))
        return (self * divisor ).rounded() * 57.32  / divisor
        
    }
}
/*
 
extension ARSCNView {
    /**
     Type conversion wrapper for original `unprojectPoint(_:)` method.
     Used in contexts where sticking to SIMD3<Float> type is helpful.
     */
    func unprojectPoint(_ point: SIMD3<Float>) -> SIMD3<Float> {
        return SIMD3<Float>(unprojectPoint(SCNVector3(point)))
    }
    
    // - Tag: CastRayForFocusSquarePosition
    func castRay(for query: ARRaycastQuery) -> [ARRaycastResult] {
        return session.raycast(query)
    }

    // - Tag: GetRaycastQuery
    func getRaycastQuery(from location: CGPoint, for alignment: ARRaycastQuery.TargetAlignment = .any) -> ARRaycastQuery? {
        return raycastQuery(from: location, allowing: .estimatedPlane, alignment: ARRaycastQuery.TargetAlignment = .any)
    }
    
}  */
