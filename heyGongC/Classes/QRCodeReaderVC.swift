//
//  QRCodeReaderVC.swift
//  heyGongC
//
//  Created by 장예지 on 1/17/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import SwiftyUserDefaults
import AVFoundation

class QRCodeReaderVC: BaseVC {
    
    @IBOutlet weak var viewCamera: UIView!
    @IBOutlet weak var imgViewScanArea: UIImageView!
    
    var video = AVCaptureVideoPreviewLayer()
    
    //1. AVSession만들기
    let session = AVCaptureSession()
    
    override func initialize() {
        setupAVCatureInfo()
        
    }
    
    override func bind() { }
    
    override func setupHandler() { }
}

extension QRCodeReaderVC: AVCaptureMetadataOutputObjectsDelegate {
    private func setupAVCatureInfo(){
        let rectOfInterest = CGRect(x: imgViewScanArea.frame.origin.x, y: imgViewScanArea.frame.origin.y, width: imgViewScanArea.frame.width, height: imgViewScanArea.frame.height)

        //2. Capture Device 정의
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        } catch {
            print("error")
        }
        
        let output = AVCaptureMetadataOutput()
        
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        let rectConverted = setVideoLayer(rectOfInterest: rectOfInterest)
        output.rectOfInterest = rectConverted
        viewCamera.bringSubviewToFront(imgViewScanArea)
        
        DispatchQueue.global(qos: .background).async{
            self.session.startRunning()
        }
        
    }
    
    private func setVideoLayer(rectOfInterest: CGRect) -> CGRect{
        let videoLayer = AVCaptureVideoPreviewLayer(session: session)
        videoLayer.frame = viewCamera.layer.bounds
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        viewCamera.layer.addSublayer(videoLayer)

        return videoLayer.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            print(object.stringValue!)
            self.session.stopRunning()
            
            if let secondViewController = storyboard?.instantiateViewController(withIdentifier: "DeviceNaming") as? DeviceNamingVC {
                secondViewController.modalPresentationStyle = .fullScreen
                present(secondViewController, animated: true, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
