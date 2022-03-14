//
//  AddRecipeViewController.swift
//  MealHack
//
//  Created by Chun Long Fong on 5/6/21.
//

import UIKit

class AddRecipeViewController: UIViewController {
    //Variables
    @IBOutlet weak var recipeNameText: UITextField!
    @IBOutlet weak var recipeTimeText: UITextField!
    @IBOutlet weak var recipeServingText: UITextField!
    
    @IBAction func nextButton(_ sender: Any) {
    }
    

    var ingredientArray = [AddIngredient]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addIngredientsSegue" {
            let destination = segue.destination as! InsertIngredientViewController
            destination.recipeName = recipeNameText.text!
            destination.recipeTime = recipeTimeText.text!
            destination.recipeServing = recipeServingText.text!

        }
    }
}
