//
//  InsertIngredientViewController.swift
//  MealHack
//
//  Created by Chun Long Fong on 5/6/21.
//

import UIKit

class InsertIngredientViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddIngredientDelegate {
    //Variables
    @IBOutlet weak var ingredientTable: UITableView!
    @IBAction func cancelButton(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: false)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButton(_ sender: Any) {
    }
    
    var ingredientArray = [AddIngredient]()
    var pickerCount = 0
    var recipeName = ""
    var recipeTime = ""
    var recipeServing = ""
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 2
    var selectedRow = 0
    var selectedIngredient = ""
    var selectedQuantity = ""
    var selectedUnit = ""
    let SECTION_INGREDIENT = 0
    let SECTION_ADD = 1
    let CELL_INGREDIENT = "ingredientCell"
    let CELL_ADD = "addCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Table set up
        self.ingredientTable.delegate = self
        self.ingredientTable.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    //Section number
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //Row number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SECTION_INGREDIENT:
            return ingredientArray.count
        case SECTION_ADD:
            return 1
        default:
            return 0
        }
    }
    
    //Row info
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_INGREDIENT {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_INGREDIENT, for: indexPath)
            let meal = ingredientArray[indexPath.row]
            cell.textLabel?.text = meal.name?.capitalized
            
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 2
            formatter.numberStyle = .decimal
            let recipeAmount = formatter.string(from: meal.quantity! as NSNumber)
            cell.detailTextLabel?.text = "\(recipeAmount!) \(meal.unit!)"
            return cell
        }
        //Populate cells number of meals
        let addCell =  tableView.dequeueReusableCell(withIdentifier: CELL_ADD, for: indexPath)
        addCell.textLabel?.text = "Add Ingredients"
        return addCell
    }
    
    //Row select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_ADD {
            performSegue(withIdentifier: "searchIngredientSegue", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Add to ingredientarray
    func addIngredient(_ newIngredient: AddIngredient) -> Bool {
        self.ingredientArray.append(newIngredient)
        self.ingredientTable.reloadData()
        return true
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchIngredientSegue" {
            let destination = segue.destination as! SearchIngredientViewController
            destination.addIngredientDelegate = self
        }
        
        if segue.identifier == "addInstructionsSegue" {
            let destination = segue.destination as! InsertStepViewController
            destination.recipeName = recipeName
            destination.recipeTime = recipeTime
            destination.recipeServing = recipeServing
            destination.ingredientArray = ingredientArray
        }
    }
}
