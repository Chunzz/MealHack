//
//  PreStepViewController.swift
//  MealHack
//
//  Created by Chun Long Fong on 16/5/21.
//

import UIKit

class PreStepViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //Variables
    @IBOutlet weak var ingredientChecklistTable: UITableView!
    @IBOutlet weak var recipeTitle: UILabel!
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var recipeIngredients = [IngredientData]()
    var indicator = UIActivityIndicatorView()
    var stepArray = [StepData]()
    var instructionArray = [InstructionData]()
    var selectedRecipeId: Int?
    var selectedRecipeName: String?
    let REQUEST_STRING_TWO = "/analyzedInstructions?stepBreakdown=true&apiKey="
    let REQUEST_STRING_ONE = "https://api.spoonacular.com/recipes/"
    let CELL_INGREDIENT = "ingredientCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Table set up
        self.ingredientChecklistTable.delegate = self
        self.ingredientChecklistTable.dataSource = self
        
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
        
        //Set up page
        recipeTitle.text = selectedRecipeName
        getInstructions()
        
    }
    
    //Row number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeIngredients.count
    }
    
    //Row info
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_INGREDIENT, for: indexPath)
        cell.textLabel?.text = recipeIngredients[indexPath.row].name?.capitalized
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        let recipeAmount = formatter.string(from: recipeIngredients[indexPath.row].amount! as NSNumber)
        cell.detailTextLabel?.text = "\(recipeAmount!) \(recipeIngredients[indexPath.row].unit!)"
        if (recipeIngredients[indexPath.row].checked){
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    //Swipe front action (checkmark)
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if (self.recipeIngredients[indexPath.row].checked){
            return .none
        }
        let action = UIContextualAction(style: .normal,
                                        title: "Check") { [weak self] (action, view, completionHandler) in
            self!.recipeIngredients[indexPath.row].checked = true
            self!.ingredientChecklistTable.reloadData()
            completionHandler(true)
        }
        action.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    //Swipe back
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if !(self.recipeIngredients[indexPath.row].checked){
            return .none
        }
        let action = UIContextualAction(style: .normal,
                                        title: "Uncheck") { [weak self] (action, view, completionHandler) in
            self!.recipeIngredients[indexPath.row].checked = false
            self!.ingredientChecklistTable.reloadData()
            completionHandler(true)
        }
        action.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    //Searching api for meals
    func getInstructions(){
        guard let requestURL = URL(string: "\(REQUEST_STRING_ONE)\(String(selectedRecipeId!))\(REQUEST_STRING_TWO)")
        else {
            print("Invalid URL.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestURL) {
            (data, response, error) in
            // This closure is executed on a different thread at a later point in
            // time!
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
            }
            
            if let error = error {
                print(error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let rootData = try decoder.decode([InstructionData].self, from: data!)
                for instruction in rootData {
                    self.instructionArray.append(instruction)
                }
                
                DispatchQueue.main.async {
                    for i in 0..<self.instructionArray.count{
                        let bottomMargin = CGFloat(100) //Space between button and bottom of the screen
                        let buttonSize = CGSize(width: 200, height: 50)
                        
                        let button:UIButton = UIButton(frame: CGRect(
                            x: 0, y: 0, width: buttonSize.width, height: buttonSize.height
                        ))
                        
                        if var currentInstructionName = self.instructionArray[i].name {
                            if currentInstructionName.isEmpty{
                                currentInstructionName = "Start Cooking"
                            }
                            button.setTitle(currentInstructionName, for: .normal)
                        }
                        
                        button.frame = CGRect(x: 100, y: (i+1)*150, width: 200, height: 50)
                        button.setTitleColor(.black, for: .normal)
                        button.backgroundColor = UIColor(red: 211/255, green: 224/255, blue: 220/255, alpha: 1)
                        button.layer.cornerRadius = 10
                        button.setTitle(String(i), for: .disabled)
                        button.addTarget(self, action: #selector(self.buttonTapped),for: .touchUpInside)
                        button.center = CGPoint(x: self.view.bounds.size.width / 2,
                                                y: self.view.bounds.size.height - buttonSize.height / 2 - bottomMargin)
                        
                        self.view.addSubview(button)
                    }
                }
            } catch let err {
                print(err)
            }
        }
        task.resume()
    }
    
    //Go to instruction
    @objc func buttonTapped(sender: UIButton){
        stepArray = self.instructionArray[Int(sender.title(for: .disabled)!)!].steps!
        performSegue(withIdentifier: "instructionSegue", sender: nil)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "instructionSegue" {
            let destination = segue.destination as! InstructionViewController
            destination.stepArray = stepArray
            destination.selectedRecipeName = selectedRecipeName
        }
    }
}
