//
//  SearchIngredientViewController.swift
//  MealHack
//
//  Created by Chun Long Fong on 5/6/21.
//

import UIKit


class SearchIngredientViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    //Variable
    @IBOutlet weak var ingredientTable: UITableView!
    @IBOutlet weak var searchBarContainer: UIView!
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    weak var addIngredientDelegate: AddIngredientDelegate?
    var selectedRow = 0
    var selectedIngredient = ""
    var selectedQuantity = ""
    var selectedUnit = ""
    var newIngredients = [CustomIngredientData]()
    var indicator = UIActivityIndicatorView()
    var newUnitArray = ["", "teaspoon", "tablespoon", "cup", "mL", "L", "g", "kg", "pound", "piece"]
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 2
    let REQUEST_STRING = "https://api.spoonacular.com/food/ingredients/search?apiKey=&query="
    let CELL_INGREDIENT = "ingredientCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        //Set up table
        self.ingredientTable.delegate = self
        self.ingredientTable.dataSource = self
        
        //Set up search bar
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search ingredients..."
        searchBar.tintColor = UIColor.lightGray
        searchBar.barTintColor = UIColor.lightGray
        searchBar.isTranslucent = true
        searchBar.showsCancelButton = true
        var searchBarFrame = searchBar.frame
        searchBarFrame.size.width = self.searchBarContainer.frame.size.width
        searchBar.frame = searchBarFrame
        searchBar.becomeFirstResponder()
        self.searchBarContainer.addSubview(searchBar)
        
        //Set up indicator
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo:
                                                view.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo:
                                                view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    //Search ingredient
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        newIngredients.removeAll()
        self.ingredientTable.reloadData()
        guard let searchText = searchBar.text else {return}
        indicator.startAnimating()
        requestIngredient(searchText)
    }
    
    //Row select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIngredient = newIngredients[indexPath.row].name!
        showQuantityUnitPicker()
    }
    
    //Row number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newIngredients.count
    }
    
    //Row info
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_INGREDIENT, for: indexPath)
        cell.textLabel?.text = newIngredients[indexPath.row].name
        return cell
    }
    
    
    //Picker row view
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        label.text = Array(newUnitArray)[row]
        label.sizeToFit()
        return label
    }
    
    //Row height
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    //Row columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Row rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return newUnitArray.count
    }
    
    //Pop up
    func showQuantityUnitPicker(){
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 60, width: screenWidth, height:screenHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        
        let textField = UITextField(frame: CGRect(x: 20, y: 0, width: screenWidth-40, height: 50))
        textField.placeholder = "Enter quantity here"
        vc.view.addSubview(textField)
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        let alert = UIAlertController(title: "Select Ingredient", message: "", preferredStyle: .actionSheet)
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
        }))
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { [self] (UIAlertAction) in
            self.selectedRow = pickerView.selectedRow(inComponent: 0)
            self.selectedQuantity = textField.text!
            self.selectedUnit = Array(self.newUnitArray)[self.selectedRow]
            let newIngredient = AddIngredient(name: selectedIngredient, quantity: Float(selectedQuantity), unit: selectedUnit)
            let _ = addIngredientDelegate?.addIngredient(newIngredient)
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //Api call
    func requestIngredient(_ searchInput: String){
        guard let queryString = searchInput.addingPercentEncoding(withAllowedCharacters:
                                                                    .urlQueryAllowed) else {
            print("Query string can't be encoded.")
            return
        }
        guard let requestURL = URL(string: REQUEST_STRING + queryString) else {
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
                let rootData = try decoder.decode(CustomIngredientRootData.self, from: data!)
                if let ingredients = rootData.ingredients {
                    for ingredient in ingredients {
                        self.newIngredients.append(ingredient)
                    }
                    DispatchQueue.main.async {
                        self.ingredientTable.reloadData()
                    }
                }
            } catch let err {
                print(err)
            }
        }
        task.resume()
    }
}
