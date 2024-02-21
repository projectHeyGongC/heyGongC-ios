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
    
    private let viewModel = QRCodeReaderVM()
    
    @IBOutlet weak var viewCamera: UIView!
    @IBOutlet weak var imgViewScanArea: UIImageView!
    @IBOutlet weak var btnDismiss: UIButton!
    
    var video = AVCaptureVideoPreviewLayer()
    let session = AVCaptureSession()
    
    override func initialize() {
        setupAVCatureInfo()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        session.stopRunning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DispatchQueue.global(qos: .background).async{
            self.session.startRunning()
        }
    }
    
    override func bind() {
        btnDismiss.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            dismiss(animated: true)
        }
        .disposed(by: viewModel.bag)
    }
    
    override func setupHandler() {
        self.setErrorHandler(vm: viewModel)
    }
    
    deinit {
        print("[Clear... QRCodeReaderVC ViewModel]")
        onBack(vm: viewModel)
    }
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
