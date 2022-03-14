//
//  ProfileViewController.swift
//  MealHack
//
//  Created by Chun Long Fong on 24/5/21.
//

import UIKit
import FirebaseAuth
import Firebase

class ProfileViewController: UIViewController {
    //Variables
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var mealsCompleted: UILabel!
    @IBAction func privateRecipeButton(_ sender: Any) {
        //        print("going ot private recipe")
    }
    
    
    @IBAction func savedRecipeButton(_ sender: Any) {
        //        print("going to saved recipe")
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Log out error: \(error.localizedDescription)")
        }
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "someID2") as! UINavigationController
        self.view.window?.rootViewController = viewController
        self.view.window?.makeKeyAndVisible()
    }
    
    var usersReference = Firestore.firestore().collection("users")
    var savedRecipeNames = Array<String>()
    var savedRecipeIds = Array<Int>()
    var selectedRecipeId: Int?
    var currentMealCount = 0
    var selectedRecipeName: String?
    let CELL_PERSONAL = "personalCell"
    let CELL_SAVED = "savedCell"
    let CELL_RECIPE = "recipeCell"
    
    override func viewWillAppear(_ animated: Bool) {
        getMealStats()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMealStats()
    }
    
    func displayMessage(title: String, message:String)  {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,
                                                handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Section number
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    //Row number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //Row info
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_SAVED, for:
                                                        indexPath)
            cell.textLabel?.text = "Saved Recipes"
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_PERSONAL, for: indexPath)
        cell.textLabel?.text = "Personal Recipe"
        return cell
    }
    
    //Row select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Get meal completed
    func getMealStats(){
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
                
                self.mealsCompleted.text = "\(String(self.currentMealCount))"
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipePageSegue" {
            let destination = segue.destination as! RecipeViewController
            destination.selectedRecipeName = selectedRecipeName
            destination.selectedRecipeId = selectedRecipeId
        }
    }
}
