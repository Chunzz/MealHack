//
//  NutritionViewController.swift
//  MealHack
//
//  Created by Chun Long Fong on 19/5/21.
//

import UIKit

class NutritionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var nutritionTable: UITableView!
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
    var recipeNutrition = [NutritionData]()
    let CELL_NUTRIENT = "nutritionCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Table set up
        self.nutritionTable.delegate = self
        self.nutritionTable.dataSource = self
    }
    
    //Row number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeNutrition.count

    }
    
    //Row info
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_NUTRIENT, for: indexPath)
        cell.textLabel?.text = recipeNutrition[indexPath.row].name
        cell.detailTextLabel?.text = "\(String(recipeNutrition[indexPath.row].amount!)) \(recipeNutrition[indexPath.row].unit!)"
        return cell
    }
}
