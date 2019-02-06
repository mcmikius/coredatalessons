//
//  ViewController.swift
//  MyCars
//
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCar: Car!
    
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
        getDataFromFile()
        
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        let mark = segmentedControl.titleForSegment(at: 0)
        fetchRequest.predicate = NSPredicate(format: "mark == %@", mark!)
        do {
            let results = try context.fetch(fetchRequest)
            selectedCar = results[0]
            insertDataFrom(selectedCar: selectedCar)
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func insertDataFrom(selectedCar: Car) {
        carImageView.image = UIImage(data: selectedCar.imageData! as Data)
        markLabel.text = selectedCar.mark
        modelLabel.text = selectedCar.model
        myChoiceImageView.isHidden = !(selectedCar.myChoice?.boolValue)!
        ratingLabel.text = "Rating: \(selectedCar.rating!.doubleValue) / 10.0"
        numberOfTripsLabel.text = "Number of trips: \(selectedCar.timesDriven!.intValue)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        lastTimeStartedLabel.text = "Last time started: \(dateFormatter.string(from: selectedCar.lastStarted! as Date))"
        segmentedControl.tintColor = (selectedCar.tintColor as! UIColor)
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
        let mark = sender.titleForSegment(at: sender.selectedSegmentIndex)
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "mark == %@", mark!)
        
        do {
            let results = try context.fetch(fetchRequest)
            selectedCar = results[0]
            insertDataFrom(selectedCar: selectedCar)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func startEnginePressed(_ sender: UIButton) {
        let timesDriven = selectedCar.timesDriven?.intValue
        selectedCar.timesDriven = NSNumber(value: timesDriven! + 1)
        selectedCar.lastStarted = NSDate()
        
        do {
            try context.save()
            insertDataFrom(selectedCar: selectedCar)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func rateItPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Rate it", message: "Rate this car please", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            let textField = alertController.textFields?[0]
            self.update(rating: textField!.text!)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addTextField { textField in
            textField.keyboardType = .numberPad
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    func update(rating: String) {
        selectedCar.rating = NSNumber(value: Double(rating)!)
        
        do {
            try context.save()
            insertDataFrom(selectedCar: selectedCar)
        } catch {
            let alertController = UIAlertController(title: "Wrong value", message: "Wrong input", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            present(alertController,animated: true, completion: nil)
            print(error.localizedDescription)
        }
    }
}





