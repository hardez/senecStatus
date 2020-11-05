//
//  senecView.swift
//  senecStatus
//
//  Created by Marco Eckhardt on 05.11.20.
//

import Cocoa
import SenecClient

class senecView: NSViewController {
    
    @IBOutlet weak var solarPowerLabel: NSTextField!
    @IBOutlet weak var batterieLoadLabel: NSTextField!
    @IBOutlet weak var housePowerLabel: NSTextField!
    @IBOutlet weak var powerGridConsumptionLabel: NSTextField! //Value
    @IBOutlet weak var powerBatteryConsumptionLabel: NSTextField!
    
    @IBOutlet weak var batteryLabel: NSTextField!
    @IBOutlet weak var photovoltLabel: NSTextField!
    @IBOutlet weak var houseLabel: NSTextField!
    @IBOutlet weak var powerBatteryLabel: NSTextFieldCell!
    @IBOutlet weak var powerGridLabel: NSTextField! //Netzbezug oder Einspeisung
    
    
    var timer = Timer()
    
    class func loadFromNib() -> senecView {
        let storyBoard = NSStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateController(withIdentifier: "senecView") as! senecView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        updateData()
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
    }
    
  
    
    @objc func updateData(){
        let url = URL(string: "http://senecspeicher.fritz.box/lala.cgi")
        guard let requestUrl = url else { fatalError() }
        let meinSenec = LocalSenecHost(url: requestUrl)
        meinSenec.getEnergyFlow(completion: { [self]data in
        
            switch data{
            case .failure(_):
                print("failure")
            case .success(let energyData):
                
                let photovoltaicPowerGeneration = Int(energyData.photovoltaicPowerGeneration)
                if photovoltaicPowerGeneration > 0 {
                    self.photovoltLabel.stringValue = "􀆮"
                } else {
                    self.photovoltLabel.stringValue = "􀆫"
                }
                self.solarPowerLabel.stringValue = "\(photovoltaicPowerGeneration) W"
                
                
                
                self.batteryLabel.stringValue = "􀛨"
                self.batterieLoadLabel.stringValue = "\(Int(energyData.batteryStateOfCharge * 100)) %"
                
                
                self.houseLabel.stringValue = "􀎟"
                self.housePowerLabel.stringValue = "\(Int(energyData.housePowerConsumption)) W"
                
                
                let batteryPowerFlow = Int(energyData.batteryPowerFlow)
                if batteryPowerFlow >= 0 {
                    self.powerBatteryLabel.stringValue = "􀛨􀁷"
                    self.powerBatteryConsumptionLabel.stringValue = "\(batteryPowerFlow * -1) W"
                } else {
                    self.powerBatteryLabel.stringValue = "􀛪􀁹"
                    self.powerBatteryConsumptionLabel.stringValue = "\(batteryPowerFlow) W"
                }
                
                let gridPowerFlow = Int(energyData.gridPowerFlow)
                if gridPowerFlow <= 0 {
                    self.powerGridLabel.stringValue = "􀋨􀁷"
                    self.powerGridConsumptionLabel.stringValue = "\(gridPowerFlow * -1) W"
                } else {
                    self.powerGridLabel.stringValue = "􀋧􀁸"
                    self.powerGridConsumptionLabel.stringValue = "\(gridPowerFlow) W"
                }
                
                
            }
        
            })
    }
    
}
