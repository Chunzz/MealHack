//
//  RecipeViewController.swift
//  MealHack
//
//  Created by Chun Long Fong on 28/4/21.
//

import UIKit
import FirebaseAuth
import Firebase

class RecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //Variables
    @IBOutlet var MainView: UIView!
    @IBOutlet weak var loveButton: UIButton!
    @IBOutlet weak var ingredientTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var recipeIngredientLabel: UILabel!
    @IBOutlet weak var ingredientTable: UITableView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTime: UILabel!
    @IBOutlet weak var recipeServing: UILabel!
    
    //Go back
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    //If already loved, unlove, else love
    @IBAction func loveRecipe(_ sender: Any) {
        guard let userID = Auth.auth().currentUser?.uid else {
         displayMessage(title: "Error", message: "No user logged in!")
         return
        }
        
        let docRef = self.usersReference.document("\(userID)").collection("mealStats").document("loveMeals")

        docRef.getDocument{ (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.loveArrayIds = snapshot!.get("ids") as! Array<Int>
                self.loveArrayNames = snapshot!.get("names") as! Array<String>
                if (!self.isLoved){
                    if (self.loveArrayIds.contains(self.selectedRecipeId!)){
                    } else {
                        self.loveArrayIds.append(self.selectedRecipeId!)
                        self.loveArrayNames.append(self.selectedRecipeName!)

                    }
                    self.usersReference.document("\(userID)").collection("mealStats").document("loveMeals").setData(["ids": self.loveArrayIds, "names": self.loveArrayNames])
                    self.loveButton.setBackgroundImage(UIImage(named: "like"), for: .normal)
                    self.isLoved = true
                } else {
                    if let index = self.loveArrayIds.firstIndex(of: self.selectedRecipeId!){
                        self.loveArrayIds.remove(at: index)
                        self.loveArrayNames.remove(at: index)
                        self.usersReference.document("\(userID)").collection("mealStats").document("loveMeals").setData(["ids": self.loveArrayIds, "names": self.loveArrayNames])
                        self.loveButton.setBackgroundImage(UIImage(named: "heart"), for: .normal)
                        self.isLoved = false
                    }
                }
            }
        }
    }
    
    var usersReference = Firestore.firestore().collection("users")
    var loveArrayIds = Array<Int>()
    var loveArrayNames = Array<String>()
    var isLoved = false
    var selectedRecipeId: Int?
    var selectedRecipeName: String?
    var indicator = UIActivityIndicatorView()
    var recipeIngredients = [IngredientData]()
    var recipeNutrition = [NutritionData]()
    let SECTION_INGREDIENT = 0
    let SECTION_NUTRIENT = 1
    let CELL_INGREDIENT = "ingredientCell"
    let CELL_NUTRIENT = "nutrientCell"
    
    func displayMessage(title: String, message:String)  {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,
                                                handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Table set up
        self.ingredientTable.isScrollEnabled = false
        self.ingredientTable.delegate = self
        self.ingredientTable.dataSource = self
        navigationItem.title = self.selectedRecipeName
        
        //Indicator set up
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo:
                                                view.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo:
                                                view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        indicator.startAnimating()
        recipeName.isHidden = true
        loveButton.isHidden = true
        recipeImage.isHidden = true
        recipeTime.isHidden = true
        recipeServing.isHidden = true
        ingredientTable.isHidden = true
        recipeIngredientLabel.isHidden = true
        
        //Load recipe info
        let imageUrl = "https://spoonacular.com/recipeImages/\(selectedRecipeId!)-480x360.jpg"
        
        do {
            let url = URL(string: imageUrl)
            let data = try Data(contentsOf: url!)
            recipeImage.image = UIImage(data: data)
            recipeImage.contentMode = .scaleAspectFill
        }catch {
            print(error)
        }
        getRecipeInfo()
        
        //Check for loved
        guard let userID = Auth.auth().currentUser?.uid else {
         displayMessage(title: "Error", message: "No user logged in!")
         return
        }
        
        let docRef = self.usersReference.document("\(userID)").collection("mealStats").document("loveMeals")

        docRef.getDocument{ (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.loveArrayIds = snapshot!.get("ids") as! Array<Int>
                
                if (self.loveArrayIds.contains(self.selectedRecipeId!)){
                    self.isLoved = true
                    self.loveButton.setBackgroundImage(UIImage(named: "like"), for: .normal)
                } else {
                    self.isLoved = false
                    self.loveButton.setBackgroundImage(UIImage(named: "heart"), for: .normal)
                }
            }
        }
    }
    
    //Section number
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //Row number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SECTION_INGREDIENT:
            return recipeIngredients.count
        case SECTION_NUTRIENT:
            return 1
        default:
            return 0
        }
    }
    
    //Row info
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_INGREDIENT{
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_INGREDIENT, for: indexPath)
            cell.textLabel?.text = recipeIngredients[indexPath.row].name?.capitalized
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 2
            formatter.numberStyle = .decimal
            let recipeAmount = formatter.string(from: recipeIngredients[indexPath.row].amount! as NSNumber)
            cell.detailTextLabel?.text = "\(recipeAmount!) \(recipeIngredients[indexPath.row].unit!)"
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_NUTRIENT, for: indexPath)
        cell.textLabel?.text = "Nutrition Info"
        cell.isSelected = false
        return cell
    }
    
    //Row select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == SECTION_NUTRIENT {
            performSegue(withIdentifier: "nutritionSegue", sender: self)
        }
    }
    
    //Searching api for meals
    func getRecipeInfo(){
        let recipeInfoUrl = "https://api.spoonacular.com/recipes/\(selectedRecipeId!)/information?apiKey=&includeNutrition=true"
        guard let requestURL = URL(string: recipeInfoUrl) else {
            print("Invalid URL.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestURL) {
            (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let rootData = try decoder.decode(RootData.self, from: data!)
                if let ingredients = rootData.extendedIngredients {
                    for ingredient in ingredients {
                        self.recipeIngredients.append(ingredient)
                    }
                }
                
                if let nutrition = rootData.nutrients {
                    for nutrient in nutrition {
                        self.recipeNutrition.append(nutrient)
                    }
                    DispatchQueue.main.async {
                        //Modify page
                        self.recipeName.text = rootData.title
                        self.recipeTime.text = "\(String(rootData.readyInMinutes!)) MINS"
                        self.recipeServing.text = "\(String(rootData.servings!)) serving(s)"
                        self.indicator.stopAnimating()
                        self.recipeName.isHidden = false
                        self.loveButton.isHidden = false
                        self.recipeImage.isHidden = false
                        self.recipeTime.isHidden = false
                        self.recipeServing.isHidden = false
                        self.ingredientTable.isHidden = false
                        self.recipeIngredientLabel.isHidden = false
                        self.scrollViewHeightConstraint?.constant -= self.ingredientTableHeightConstraint!.constant
                        self.ingredientTable.reloadData()
                        self.scrollViewHeightConstraint?.constant += self.ingredientTable.contentSize.height
                        self.ingredientTableHeightConstraint?.constant = self.ingredientTable.contentSize.height
                    }
                }
                
            } catch let err {
                print(err)
            }
        }
        task.resume()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nutritionSegue" {
            let destination = segue.destination as! NutritionViewController
            destination.recipeNutrition = recipeNutrition
        }
        
        if segue.identifier == "preStepSegue" {
            let destination = segue.destination as! PreStepViewController
            destination.selectedRecipeId = selectedRecipeId
            destination.selectedRecipeName = selectedRecipeName
            destination.recipeIngredients = recipeIngredients
        }
    }
}
