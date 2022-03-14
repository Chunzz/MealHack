//
//  PrivateRecipeViewController.swift
//  MealHack
//
//  Created by Chun Long Fong on 6/6/21.
//

import UIKit
import FirebaseAuth
import Firebase

class PrivateRecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //Variables
    @IBOutlet weak var recipeTable: UITableView!
    @IBAction func backButton(_ sender: Any) {
                self.navigationController?.popViewController(animated: true)

    }
    

    var usersReference = Firestore.firestore().collection("users")
    var selectedRecipeId: Int?
    var selectedRecipeName: String?
    var savedRecipeNames = Array<String>()
    var savedRecipeIds = Array<Int>()
    let CELL_RECIPE = "recipeCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Table set up
        self.recipeTable.delegate = self
        self.recipeTable.dataSource = self
        
        //Get personal recipe from firestore
        guard let userID = Auth.auth().currentUser?.uid else {
            displayMessage(title: "Error", message: "No user logged in!")
            return
        }
        let _ = self.usersReference.document("\(userID)").collection("privateRecipes").getDocuments(completion: { querySnapshot, error in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            guard let docs = querySnapshot?.documents else { return }
            for doc in docs{
                self.savedRecipeNames.append(doc.get("name") as! String)
            }
            self.recipeTable.reloadData()
        })
    }
    
    func displayMessage(title: String, message:String)  {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,
                                                handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Row number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        savedRecipeNames.count
    }
    
    //Row info
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_RECIPE, for: indexPath)
        cell.textLabel?.text = savedRecipeNames[indexPath.row]
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipePageSegue" {
            let destination = segue.destination as! RecipeViewController
            destination.selectedRecipeName = selectedRecipeName
            destination.selectedRecipeId = selectedRecipeId
        }
    }
}
