//
//  ViewController.swift
//  gyroscopeSample
//
//  Created by Guang Zhu on 6/27/19.
//  Copyright © 2019 waterBB. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var x_ais: UILabel!

    @IBOutlet weak var y_ais: UILabel!

    
    @IBOutlet weak var z_ais: UILabel!
    let mManager = CMMotionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard mManager.isAccelerometerAvailable else { return }

        mManager.deviceMotionUpdateInterval = 0.01
        mManager.startDeviceMotionUpdates(to: OperationQueue.current!) { [weak self] (data, error) in

            guard let data = data, error == nil else {
                return
            }

//            let rotation = atan2(data.gravity.x,
//                                 data.gravity.y) - .pi

            //print(rotation)
            if data.userAcceleration.x < -2 {
                self?.view.backgroundColor = .green
            }

            if data.userAcceleration.y < -2 {
                self?.view.backgroundColor = .red
            }

            if data.userAcceleration.z < -2 {
                self?.view.backgroundColor = .black
            }

            if data.userAcceleration.z > 2 {
                self?.view.backgroundColor = .gray
            }
        }

        //seamlessUpdate()

        timedGyrosUpdate()
        //testMotionAction()
    }

    func seamlessUpdate() {

        if mManager.isGyroActive {
            mManager.gyroUpdateInterval = 1/5
            //mManager.startAccelerometerUpdates()
            mManager.startGyroUpdates(to: .main) { (data, error) in //startGyroUpdates
                guard let data = data, error == nil else { return }

                let textCoords = (data.rotationRate.x.round2(), data.rotationRate.y.round2(), data.rotationRate.z.round2())

                self.x_ais.text = String(textCoords.0)
                self.y_ais.text = String(textCoords.1)
                self.z_ais.text = String(textCoords.2)

                [self.x_ais, self.y_ais, self.z_ais].forEach({ e in
                    e?.setNeedsLayout()
                })

//                if data.userAcceleration.x < -2.5 {
//                    self.view.backgroundColor = .blue
//                }
//                print(data.magneticField, data.gravity, data.rotationRate, data.userAcceleration)
            }
        }
    }

    func timedGyrosUpdate() {
        if mManager.isGyroAvailable {
            self.mManager.gyroUpdateInterval = 1.0 / 5.0
            self.mManager.startGyroUpdates()

            // Configure a timer to fetch the accelerometer data.
            let timer = Timer(fire: Date(), interval: 1/5 /*(1.0/10.0)*/,
                               repeats: true, block: { [weak self] (timer) in

                                guard let self = self else { return }
                                // Get the gyro data.
                                if let data = self.mManager.gyroData {
                                    let x = data.rotationRate.x
                                    let y = data.rotationRate.y
                                    let z = data.rotationRate.z
                                    let textCoords = (x.round2(), y.round2(),z.round2())
                                    print(textCoords)

                                    self.x_ais.text = String(textCoords.0)
                                    self.y_ais.text = String(textCoords.1)
                                    self.z_ais.text = String(textCoords.2)

//                                    self.coords.text = String(textCoords.0) //+ "\n"
//                                                     + String(textCoords.1) //+ "\n"
//                                                     + String(textCoords.2) //+ "\n"
//                                    self.coords.setNeedsLayout()
                                    [self.x_ais, self.y_ais, self.z_ais].forEach({ e in
                                        e?.setNeedsLayout()
                                    })
                                }
            })

            // Add the timer to the current run loop.
            RunLoop.current.add(timer, forMode: .default)
        }
    }

    func testMotionAction () {
        if mManager.isDeviceMotionActive {
            mManager.deviceMotionUpdateInterval = 0.01
            mManager.startDeviceMotionUpdates(to: .main) {
            [weak self] (data, error) in

            guard let data = data, error == nil else {
                return
            }

            let rotation = atan2(data.gravity.x,
                                 data.gravity.y) - .pi

                print(rotation)
            }
        }
    }
}

extension Double {
    func round2() -> Double {
        return (self*1000).rounded()/1000
    }
}
