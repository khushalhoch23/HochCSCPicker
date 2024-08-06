//
//  PickerView.swift
//  SQLiteDemo
//
//  Created by Lenovo on 31/07/24.
//

import UIKit

class PickerView: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var tblPicker: UITableView!
    //@IBOutlet weak var searchBar: UISearchBar!
    
    let searchBar = UISearchBar()
    
    var selectType: PickerType = .Country
    let databaseManager = DatabaseManager()
    
    var filterId:Int?
    
    var arrCountry = [Country]()
    var arrState = [State]()
    var arrCity = [City]()
    
    var arrList = [String]()
    var filteredList = [String]()
    
    
    var onItemSelected: ((String, Int) -> Void)?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overCurrentContext // Set the presentation style here
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "PickerViewCell", bundle: nil)
        tblPicker.register(nib, forCellReuseIdentifier: "PickerViewCell")
        
        searchBar.delegate = self

        
        if selectType == .Country{
            let dbHelper = SQLiteHelper()

            arrCountry = dbHelper.fetchAllCountries()
            
            arrList = arrCountry.compactMap({$0.name})
            
            tblPicker.reloadData()
        }
        
        if selectType == .State{
            
            if let countryId = filterId{
                let dbHelper = SQLiteHelper()

                arrState = dbHelper.fetchStatesWithFilter(id: countryId)
                
                arrList = arrState.compactMap({$0.name})
                
                tblPicker.reloadData()
            }else{
                let dbHelper = SQLiteHelper()

                arrState = dbHelper.fetchStatesWithoutFilter()
                
                arrList = arrState.compactMap({$0.name})
                
                tblPicker.reloadData()
            }
            
        }
        
        if selectType == .City{
            
            if let stateId = filterId{
                let dbHelper = SQLiteHelper()

                arrCity = dbHelper.fetchCitiesWithFilter(id: stateId)
                
                arrList = arrCity.compactMap({$0.name})
                
                tblPicker.reloadData()
            }else{
                let dbHelper = SQLiteHelper()

                arrCity = dbHelper.fetchCitiesWithoutFilter()
                
                arrList = arrCity.compactMap({$0.name})
                
                tblPicker.reloadData()
            }
        }
        
        filteredList = arrList
        
        tblPicker.keyboardDismissMode = .onDrag
    }
    
  
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredList = arrList
        } else {
            filteredList = arrList.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
        tblPicker.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    @IBAction func btnSELECT_COUNTRY(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PickerView: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PickerViewCell", for: indexPath) as? PickerViewCell else {
            return UITableViewCell()
        }
        
        cell.lblTitle.text = filteredList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.dismiss(animated: true)
        let selectedItem = filteredList[indexPath.row]
        if let originalIndex = arrList.firstIndex(of: selectedItem) {
            print("Selected item: \(selectedItem) at original index: \(originalIndex)")
            // You can now use the originalIndex as needed
            callCloser(selectedIndex: originalIndex)
        }
        
        self.dismiss(animated: true)
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50 // Adjust the height as needed
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        searchBar.backgroundColor = .yellow
        searchBar.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
        return searchBar
    }

    
    func callCloser(selectedIndex: Int){
        if selectType == .Country{
            let name = arrCountry[selectedIndex].name
            let id = arrCountry[selectedIndex].id
            
            onItemSelected?(name, id)
        }
        
        if selectType == .State{
            let name = arrState[selectedIndex].name
            let id = arrState[selectedIndex].id
            
            onItemSelected?(name, id)
        }
        
        if selectType == .City{
            let name = arrCity[selectedIndex].name
            let id = arrCity[selectedIndex].id
            
            onItemSelected?(name, id)
        }
    }
    
}


enum PickerType {
    case Country
    case State
    case City
}



