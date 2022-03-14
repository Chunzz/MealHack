//
//  InsertStepViewController.swift
//  MealHack
//
//  Created by Chun Long Fong on 6/6/21.
//

import UIKit
import FirebaseAuth
import Firebase
class InsertStepViewController: UIViewController {
    //Variables
    @IBOutlet weak var addStepLabel: UIButton!
    @IBOutlet weak var nextButtonLabel: UIButton!
    @IBOutlet weak var stepNumber: UILabel!
    @IBOutlet weak var stepDescription: UITextView!
    
    //Add a step
    @IBAction func addStepButton(_ sender: Any) {
        if (stepDescription.text.isEmpty){
        } else {
            
        }
        instructionArray[currentStep] = stepDescription.text
        stepDescription.text = ""
        stepNumber.text = "Step \(instructionArray.count+1)"
        currentStep += 1
        instructionArray.append("")
    }
    
    //Go to next step if available
    @IBAction func nextButton(_ sender: Any) {
        instructionArray[currentStep] = stepDescription.text
        currentStep += 1
        if (currentStep+1 == instructionArray.count){
            nextButtonLabel.isHidden = true
            addStepLabel.isHidden = false
        } else {
            nextButtonLabel.isHidden = false
            addStepLabel.isHidden = true
        }
        stepDescription.text = instructionArray[currentStep]
        stepNumber.text = "Step \(currentStep+1)"
    }
    
    //Go back a step or page
    @IBAction func backButton(_ sender: Any) {
        if (currentStep == 0){
            self.navigationController?.popViewController(animated: true)
        } else {
            instructionArray[currentStep] = stepDescription.text
            currentStep -= 1
            stepDescription.text = instructionArray[currentStep]
            stepNumber.text = "Step \(currentStep+1)"
            nextButtonLabel.isHidden = false
            addStepLabel.isHidden = true
        }
    }
    
    //Cancel everything
    @IBAction func cancelButton(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]

        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: false)
    }
    
    //Upload to firestore
    @IBAction func uploadButton(_ sender: Any) {
        instructionArray[currentStep] = stepDescription.text
        guard let userID = Auth.auth().currentUser?.uid else {
            displayMessage(title: "Error", message: "No user logged in!")
            return
        }
        var ingredientNameArray = [String]()
        var ingredientQuantityArray = [Float]()
        var ingredientUnitArray = [String]()
        for ingredient in ingredientArray{
            ingredientNameArray.append(ingredient.name!)
            ingredientQuantityArray.append(ingredient.quantity!)
            ingredientUnitArray.append(ingredient.unit!)
        }
        self.usersReference.document("\(userID)").collection("privateRecipes").addDocument(data: ["name": recipeName, "time": recipeTime,"serving": recipeServing, "ingredientNames": ingredientNameArray, "ingredientQuantityies": ingredientQuantityArray, "ingredientUnits": ingredientUnitArray, "instructions": self.instructionArray])
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: false)
    }
    
    var recipeName = ""
    var recipeTime = ""
    var recipeServing = ""
    var ingredientArray = [AddIngredient]()
    var currentStep = 0
    var instructionArray = [String]()
    var usersReference = Firestore.firestore().collection("users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepNumber.text = "Step 1"
        instructionArray.append("")
        if (currentStep + 1 == instructionArray.count){
            nextButtonLabel.isHidden = true
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
