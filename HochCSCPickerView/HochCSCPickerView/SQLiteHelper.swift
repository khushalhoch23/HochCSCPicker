//
//  SQLiteHelper.swift
//  SQLiteDemo
//
//  Created by Lenovo on 24/07/24.
//

import Foundation
import SQLite3

class SQLiteHelper {
    private var db: OpaquePointer?
    
    init() {
        self.openDatabase()
        self.createTables()
    }
    
    private func openDatabase() {
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("myApp.sqlite")
        
        print("PATH : \(fileUrl)")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            print("Error opening database")
        }
    }
    
    // Create Tables
    private func createTables() {
        let createCountryTableQuery = """
            CREATE TABLE IF NOT EXISTS countries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            sortname TEXT,
            nationality TEXT,
            phonecode TEXT);
            """
        
        let createStateTableQuery = """
            CREATE TABLE IF NOT EXISTS states (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            country_id INTEGER,
            name TEXT,
            updated_at TEXT,
            FOREIGN KEY (country_id) REFERENCES Country(id));
            """
        
        let createCityTableQuery = """
            CREATE TABLE IF NOT EXISTS cities (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            state_id INTEGER,
            FOREIGN KEY (state_id) REFERENCES State(id));
            """
        
        if sqlite3_exec(db, createCountryTableQuery, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error creating Country table: \(errmsg)")
        }
        
        if sqlite3_exec(db, createStateTableQuery, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error creating State table: \(errmsg)")
        }
        
        if sqlite3_exec(db, createCityTableQuery, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error creating City table: \(errmsg)")
        }
    }
    
    // Fetch All Countries
    func fetchAllCountries() -> [Country] {
        var stmt: OpaquePointer?
        let selectQuery = "SELECT id, name, sortname, phonecode FROM countries"
        var countries: [Country] = []
        
        if sqlite3_prepare_v2(db, selectQuery, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing select: \(errmsg)")
            return countries
        }
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let sortname = String(cString: sqlite3_column_text(stmt, 2))
            let phonecode = String(cString: sqlite3_column_text(stmt, 3))
            countries.append(Country(id: Int(id), name: name, sortname: sortname, phonecode: phonecode))
        }
        
        sqlite3_finalize(stmt)
        return countries
    }
    
    func fetchStatesWithFilter(id:Int) -> [State] {
        var stmt: OpaquePointer?
        let selectQuery = "SELECT id, name, country_id FROM states WHERE country_id = \(id)"
        var states: [State] = []
        
        if sqlite3_prepare_v2(db, selectQuery, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing select: \(errmsg)")
            return states
        }
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let country_id = sqlite3_column_int(stmt, 2)
            states.append(State(id: Int(id), name: name, country_id: Int(country_id)))
        }
        
        sqlite3_finalize(stmt)
        return states
    }
    
    func fetchStatesWithoutFilter() -> [State] {
        var stmt: OpaquePointer?
        let selectQuery = "SELECT id, name, country_id FROM states"
        var states: [State] = []
        
        if sqlite3_prepare_v2(db, selectQuery, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing select: \(errmsg)")
            return states
        }
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let country_id = sqlite3_column_int(stmt, 2)
            states.append(State(id: Int(id), name: name, country_id: Int(country_id)))
        }
        
        sqlite3_finalize(stmt)
        return states
    }


    func fetchCitiesWithFilter(id:Int) -> [City] {
        var stmt: OpaquePointer?
        let selectQuery = "SELECT id, name, state_id FROM cities WHERE state_id = \(id)"
        var city: [City] = []
        
        if sqlite3_prepare_v2(db, selectQuery, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing select: \(errmsg)")
            return city
        }
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let state_id = sqlite3_column_int(stmt, 2)
            city.append(City(id: Int(id), name: name, state_id: Int(state_id)))
        }
        
        sqlite3_finalize(stmt)
        return city
    }
    
    func fetchCitiesWithoutFilter() -> [City] {
        var stmt: OpaquePointer?
        let selectQuery = "SELECT id, name, state_id FROM cities"
        var city: [City] = []
        
        if sqlite3_prepare_v2(db, selectQuery, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing select: \(errmsg)")
            return city
        }
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let state_id = sqlite3_column_int(stmt, 2)
            city.append(City(id: Int(id), name: name, state_id: Int(state_id)))
        }
        
        sqlite3_finalize(stmt)
        return city
    }

}


struct Country {
    let id: Int
    let name: String
    let sortname: String
    let phonecode: String
}

struct State {
    let id: Int
    let name: String
    let country_id: Int
}

struct City {
    let id: Int
    let name: String
    let state_id: Int
}


class DatabaseManager {
    var db: OpaquePointer?

    private func openDatabase() {
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("myApp.sqlite")
        
        print("PATH : \(fileUrl)")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            print("Error opening database")
            return
        }

        print("Successfully opened connection to database at \(fileUrl.path)")
    }

    init() {
        openDatabase()
    }

    deinit {
        sqlite3_close(db)
    }
}
