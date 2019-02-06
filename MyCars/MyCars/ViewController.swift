//
//  ViewController.swift
//  MyCars
//
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var lastTimeStartedLabel: UILabel!
    @IBOutlet weak var numberOfTripsLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var myChoiceImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getDataFromFile() {
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "mark != nil")
        
        var records = 0
        
        do {
            let count = try context.count(for: fetchRequest)
            records = count
            print("Data is there already?")
        } catch {
            print(error.localizedDescription)
        }
        guard records == 0 else { return }
        
        let pathToFile = Bundle.main.path(forResource: "data", ofType: "plist")
        let dataArray = NSArray(contentsOfFile: pathToFile!)!
        
        for dictionary in dataArray {
            let entity = NSEntityDescription.entity(forEntityName: "Car", in: context)
            let car = NSManagedObject(entity: entity!, insertInto: context) as! Car
            let carDictionary = dictionary as! NSDictionary
            car.mark = carDictionary["mark"] as? String
            car.model = carDictionary["model"] as? String
            car.rating = carDictionary["rating"] as? NSNumber
            car.lastStarted = carDictionary["lastStarted"] as? NSDate
            car.timesDriven = carDictionary["timesDriven"] as? NSNumber
            car.myChoice = carDictionary["myChoice"] as? NSNumber
            
            let imageName = carDictionary["imageName"] as? String
            let image = UIImage(named: imageName!)
            let imageData = UIImagePNGRepresentation(image!)
            car.imageData = imageData as NSData?
            
            let colorDictionary = carDictionary["tintColor"] as? NSDictionary
            car.tintColor = getColor(colorDictionary: colorDictionary!)
        }
    }
    
    func getColor(colorDictionary: NSDictionary) -> UIColor {
        let red = colorDictionary["red"] as! NSNumber
        let green = colorDictionary["green"] as! NSNumber
        let blue = colorDictionary["blue"] as! NSNumber
        return UIColor(red: CGFloat(truncating: red) / 255, green: CGFloat(truncating: green) / 255, blue: CGFloat(truncating: blue) / 255, alpha: 1.0)
    }
    
    @IBAction func segmentedCtrlPressed(_ sender: UISegmentedControl) {
        
    }
    
    @IBAction func startEnginePressed(_ sender: UIButton) {
        
    }
    
    @IBAction func rateItPressed(_ sender: UIButton) {
        
    }
}





