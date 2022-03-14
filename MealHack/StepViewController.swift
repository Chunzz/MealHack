//
//  StepViewController.swift
//  MealHack
//
//  Created by Chun Long Fong on 12/5/21.
//

import UIKit
import FirebaseAuth
import Firebase

class StepViewController: UIViewController {
    //Variables
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var stepNumber: UILabel!
    @IBOutlet weak var stepInstruction: UITextView!
    @IBOutlet weak var bottomButton: UIButton!
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func bottomButtonAction(_ sender: Any) {
        //Update meal completed count if finished
        if (self.isLastPage!){
            guard let userID = Auth.auth().currentUser?.uid else {
             displayMessage(title: "Error", message: "No user logged in!")
             return
            }
            self.usersReference.document("\(userID)").collection("mealStats").document("mealsCompleted").setData(["number" : currentMealCount + 1])
            let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3]
            self.navigationController?.popToViewController(controller!, animated: true)
        }
    }
    
    var currentMealCount = 0
    var usersReference = Firestore.firestore().collection("users")
    var testTitle: String?
    var newStepNumber: String?
    var newStepInstruction: String?
    var isLastPage: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        //Set up page info
        testLabel.text = self.testTitle
        stepNumber.text = self.newStepNumber
        stepInstruction.text = self.newStepInstruction
        if (self.isLastPage!) {
            bottomButton.isHidden = false
            bottomButton.setTitle("Finish Cooking", for: .normal)
        } else {
            bottomButton.isHidden = true
        }
        
        //Get meal stats
        guard let userID = Auth.auth().currentUser?.uid else {
         displayMessage(title: "Error", message: "No user logged in!")
         return
        }
        
        let docRef = self.usersReference.document("\(userID)").collection("mealStats").document("mealsCompleted")

        docRef.getDocument{ (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.currentMealCount = snapshot!.get("number") as! Int
            }
     
        }
    }
    
    func displayMessage(title: String, message:String)  {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,
                                                handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
