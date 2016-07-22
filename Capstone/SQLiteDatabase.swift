//
//  SQLiteDatabase.swift
//  SQL_App
//
//  Created by Angela Liu on 6/25/16.
//  Copyright © 2016 amliu. All rights reserved.
//

// STEPS TO ADD FRAMEWORKLESS C API SQLite SUPPORT
// 1. In app > build settings, add "./SQL_App/BridgingHeader.h" to the setting "Objective-C Bridging Header"
// 2. Create the file itself, have it have "#import <sqlite3.h>" somewhere
// 3. Go to app, scroll to bottom, to "Linked Frameworks and Libraries" press plus and add "libsqlite3.0tbd"
// Now you can use it, without any need of "import" anywhere

// About bridging headers AKA exposing C functionality with Swift -> https://developer.apple.com/library/ios/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html
// About getting sqlite to work in Swift -> http://stackoverflow.com/questions/24102775/accessing-an-sqlite-database-in-swift

// Based off code/tutorial, extended for our own needs
// https://www.raywenderlich.com/123579/sqlite-tutorial-swift


// FYI: Inserts, drops, and destructive DB actions will not work on the device
// For now, simply create, then update the DB found in the assets


import Foundation

enum SQLiteError: ErrorType {
    case OpenDatabase(message: String)
    case Prepare(message: String)
    case Step(message: String)
    case Bind(message: String)
}

/**
 Handles querying, maintaining, etc of the database
 
 EX Usage:
 guard let db = try? SQLiteDatabase.open() else { return } 
 // This returns a SQLiteDatabase object wrapped in an optional, where the value is nil if it fails and errors out
 
 let placesArr = db.getPlaces("13:00", longitude: 100, latitude: 900, radius: 100)
 db.close() // close the connection when you're done getting stuff

*/
class SQLiteDatabase {
    private let dbPointer: COpaquePointer
    
    private init(dbPointer: COpaquePointer) {
        self.dbPointer = dbPointer
    }
    
    deinit {
        sqlite3_close(dbPointer)
    }
    
    /**
     Opens a connection to the database and returns a SQLiteDatabase
     object to use to mess with the database
     */
    static func open() throws -> SQLiteDatabase {
        var db: COpaquePointer = nil
        if Constants.dbpath != nil { // On devices you cannot write in the bundle so it must already exist
            if sqlite3_open(Constants.dbpath!, &db) == SQLITE_OK {
                return SQLiteDatabase(dbPointer: db)
            } else {
                defer { // Defer is a new control that happens always AFTER this block is done executing
                    // About defer, see: http://nshipster.com/guard-and-defer/
                    if db != nil {
                        sqlite3_close(db)
                    }
                }
                // So this error handling below will happen first, before the defer block
                if let message = String.fromCString(sqlite3_errmsg(db)) {
                    throw SQLiteError.OpenDatabase(message: message)
                } else {
                    throw SQLiteError.OpenDatabase(message: "No error message provided from sqlite.")
                }
            }
        } else {
            throw SQLiteError.OpenDatabase(message: "Could not find the db.sqlite file, stopping load attempt")
        }
    }
    
    func close() {
        print("Closing connection. Thanks!")
        sqlite3_close(dbPointer)
    }
    
    
    // ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
    // STATIC FUNCTIONS - DB MAINTENANCE
    // Used to manage the database itself (e.g. dropping, recreating, connecting)
    // ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
    
    /**
        Creates the database on the device only if it doesn't exist yet. If a DB exists already, it doesn't do anything
    */
    static func safeCreate() -> Void {
        if Constants.dbpath != nil {
            let fileManager = NSFileManager.defaultManager()
            guard fileManager.fileExistsAtPath(Constants.dbpath!) else {
                print("Existing database does not exist. Creating a new one")
                create()
                return
            }
        } else {
            print("Could not create database - path error. Could not find db.sqlite")
        }
    }
    
    /** 
     Creates the database on the device. (If one exists already, drops it and recreates)
    */
    static func create() -> Void {
        if Constants.dbpath != nil {
            createFromPath(Constants.dbpath!)
        } else {
            print("Could not create database - path error. Could not find db.sqlite")
        }
    }
    
    /**
     Creates the database on the desktop, which makes no sense since this is running on iOS.
     Mostly for debugging purposes
    */
    static func createOnDesktop() -> Void {
        let dbpath = "/Users/Angela/Desktop/db.sqlite"
        createFromPath(dbpath)
    }
    
    /**
     Given a path, creates the database at that location
    */
    private static func createFromPath(dbpath: String) -> Void {
        print("Creating database at " + dbpath)
        var db: COpaquePointer = nil
        if sqlite3_open(dbpath, &db) == SQLITE_OK {
            print("Successfully opened connection to database")
            drop(db)
            migrateTables(db)
            populate(db)
        }
        defer { sqlite3_close(db) }
    }

    /**
     Prepares a statement, runs it, and finalizes it. Assumes you don't need to reuse/reset the statement
    */
    static private func quickRunStatement(db: COpaquePointer, stringStatement:String) {
        var statement: COpaquePointer = nil
        if sqlite3_prepare_v2(db, stringStatement, -1, &statement, nil) == SQLITE_OK {
            sqlite3_step(statement)
            sqlite3_finalize(statement)
        } else {
            print("Could not prepare insert places statement")
        }
    }
    
    /**
     Destroys the tables in the database
     */
    static private func drop(db: COpaquePointer) {
        let dropPlace: String = "DROP TABLE Place;"
        let dropGuide: String = "DROP TABLE Guide;"
        let dropPage: String = "DROP TABLE Page;"
        let dropPlaceGuide: String = "DROP TABLE PlaceGuide;"

        quickRunStatement(db, stringStatement: dropPlace)
        quickRunStatement(db, stringStatement: dropGuide)
        quickRunStatement(db, stringStatement: dropPage)
        quickRunStatement(db, stringStatement: dropPlaceGuide)
    }
    
    /**
     Creates tables in the database
    */
    static private func migrateTables(db: COpaquePointer) {
        let createPlace: String = "CREATE TABLE Place(Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL," +
            "Longitude FLOAT, Latitude FLOAT, Category CHARACTER(255)," +
            "Subcategory CHARACTER(255), Name CHARACTER(255)," +
            "Address VARCHAR(255), Phone CHARACTER(255), Open_hour TIME," +
            "Close_hour TIME, Image_url VARCHAR(255), Tags VARCHAR(255)" +
        ");"
        quickRunStatement(db, stringStatement: createPlace)
        
        let createGuide: String = "CREATE TABLE Guide(Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL," +
            "Title CHARACTER(255), Category CHARACTER(255), Subcategory CHARACTER(255)," +
            "Hidden BOOLEAN, Image_url VARCHAR(255), Description TEXT, Tags VARCHAR(255)" +
        ");"
        quickRunStatement(db, stringStatement: createGuide)
        
        let createPage: String = "CREATE TABLE Page(Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL," +
            "Title CHARACTER(255), Description TEXT, Image_url CHARACTER(255)," +
            "Guide_id INTEGER NOT NULL REFERENCES Guides(id));"
        quickRunStatement(db, stringStatement: createPage)
        
        let createPlaceGuide: String = "CREATE Table PlaceGuide(Place_id INTEGER NOT NULL REFERENCES Places(id)," +
        "Guide_id INTEGER NOT NULL REFERENCES Guides(id), PRIMARY KEY (Place_id, Guide_id));"
        quickRunStatement(db, stringStatement: createPlaceGuide)
    }
    
    /**
     Reads from a JSON file to add in records (places, guides, pages)
    */
    static private func populate(db:COpaquePointer) {
        if let path = NSBundle.mainBundle().pathForResource("data", ofType: "json") {
            let jsonData:NSData = NSData(contentsOfFile: path)!
            do {
                let jsonDict = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                let placesArr = jsonDict.valueForKey("Places") as! NSArray
                insertPlaces(db, placesArr: placesArr)
                
                let guidesArr = jsonDict.valueForKey("Guides") as! NSArray
                insertGuidesAndPages(db, guidesArr: guidesArr)
                
                let placeGuidesArr = jsonDict.valueForKey("PlaceGuides") as! NSArray
                insertPlaceGuides(db, placeGuidesArr: placeGuidesArr)
            } catch { }
        }
    }
    
    /**
     Given starter content from the JSON, populates the DB with the places
    */
    static private func insertPlaces(db:COpaquePointer, placesArr : NSArray) {
        let insertStatementString = "INSERT INTO Place (Longitude,Latitude,Category,Subcategory,Name,Address,Phone,Open_hour,Close_hour,Image_url,Tags)" +
            " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: COpaquePointer = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            for place in placesArr {
                let placeDict = place as! NSDictionary
                sqlite3_bind_double(insertStatement, 1, placeDict.valueForKey("Longitude") as! Double)
                sqlite3_bind_double(insertStatement, 2, placeDict.valueForKey("Latitude") as! Double)
                sqlite3_bind_text(insertStatement, 3, (placeDict.valueForKey("Category")?.UTF8String)!, -1, nil)
                sqlite3_bind_text(insertStatement, 4, (placeDict.valueForKey("Subcategory")?.UTF8String)!, -1, nil)
                sqlite3_bind_text(insertStatement, 5, (placeDict.valueForKey("Name")?.UTF8String)!, -1, nil)
                sqlite3_bind_text(insertStatement, 6, (placeDict.valueForKey("Address")?.UTF8String)!, -1, nil)
                sqlite3_bind_text(insertStatement, 7, (placeDict.valueForKey("Phone")?.UTF8String)!, -1, nil)
                
                // Inserting time AKA Sqlite actually doesn't have a time class: http://stackoverflow.com/questions/1933720/how-do-i-insert-datetime-value-into-a-sqlite-database
                sqlite3_bind_text(insertStatement, 8, (placeDict.valueForKey("Open_hour")?.UTF8String)!, -1, nil)
                sqlite3_bind_text(insertStatement, 9, (placeDict.valueForKey("Close_hour")?.UTF8String)!, -1, nil)
                sqlite3_bind_text(insertStatement, 10, (placeDict.valueForKey("Image_url")?.UTF8String)!, -1, nil)
                
                sqlite3_bind_text(insertStatement, 11, (placeDict.valueForKey("Tags") as! NSArray).componentsJoinedByString(" "), -1 ,nil)
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("Successfully inserted place row.")
                } else {
                    print("Could not insert row.")
                }
                sqlite3_reset(insertStatement) // Get ready for next insert
            }
            sqlite3_finalize(insertStatement)
        } else {
            print(sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil))
            print("Could not prepare insert places statement")
        }
    }
    
    /**
     Given starter content from the JSON, populates the DB with the guides and pages (parts of the guide)
    */
    static private func insertGuidesAndPages(db:COpaquePointer, guidesArr: NSArray) {
        let insertGuideStatementString = "INSERT INTO Guide (Title,Category,Subcategory,Hidden,Image_url,Description,Tags) VALUES (?, ?, ?, ?, ?, ?, ?);"
        let insertPageStatementString = "INSERT INTO Page (Title,Description,Image_url,Guide_id) VALUES (?, ?, ?, ?);"
        
        var insertGuideStatement: COpaquePointer = nil
        var insertPageStatement: COpaquePointer = nil
        if sqlite3_prepare_v2(db, insertGuideStatementString, -1, &insertGuideStatement, nil) == SQLITE_OK {
            
            for (var i = 0; i < guidesArr.count; i += 1) {
                let guideDict = guidesArr[i] as! NSDictionary
                sqlite3_bind_text(insertGuideStatement, 1, (guideDict.valueForKey("Title")?.UTF8String)!, -1, nil)
                sqlite3_bind_text(insertGuideStatement, 2, (guideDict.valueForKey("Category")?.UTF8String)!, -1, nil)
                sqlite3_bind_text(insertGuideStatement, 3, (guideDict.valueForKey("Subcategory")?.UTF8String)!, -1, nil)
                sqlite3_bind_int(insertGuideStatement, 4, guideDict.valueForKey("Hidden") as! Bool == true ? 1 : 0)
                sqlite3_bind_text(insertGuideStatement, 5, (guideDict.valueForKey("Image_url")?.UTF8String)!, -1, nil)
                sqlite3_bind_text(insertGuideStatement, 6, (guideDict.valueForKey("Description")?.UTF8String)!, -1, nil)
                sqlite3_bind_text(insertGuideStatement, 7, (guideDict.valueForKey("Tags") as! NSArray).componentsJoinedByString(" "), -1 ,nil)

                if sqlite3_step(insertGuideStatement) == SQLITE_DONE {
                    print("Successfully inserted guide row")
                    
                    // Checking if pages are connected to this guide and inserting them now
                    if guideDict.valueForKey("Pages") != nil && sqlite3_prepare_v2(db, insertPageStatementString, -1, &insertPageStatement, nil) == SQLITE_OK {
                        let pageArr = guideDict.valueForKey("Pages") as! NSArray
                        for page in pageArr {
                            let pageDict = page as! NSDictionary
                            sqlite3_bind_text(insertPageStatement, 1, (pageDict.valueForKey("Title")?.UTF8String)!, -1, nil)
                            sqlite3_bind_text(insertPageStatement, 2, (pageDict.valueForKey("Description")?.UTF8String)!, -1, nil)
                            sqlite3_bind_text(insertPageStatement, 3, (pageDict.valueForKey("Image_url")?.UTF8String)!, -1, nil)
                            sqlite3_bind_int(insertPageStatement, 4, i+1)
                            if sqlite3_step(insertPageStatement) == SQLITE_DONE {
                                print("Successfully inserted a page associated to guide")
                            } else {
                                print("Could not insert page row")
                            }
                            sqlite3_reset(insertPageStatement)
                        }
                    }
                } else {
                    print("Could not insert guide row")
                }
                sqlite3_reset(insertGuideStatement)
            }
            sqlite3_finalize(insertPageStatement)
            sqlite3_finalize(insertGuideStatement)
        } else {
            print(sqlite3_prepare_v2(db, insertGuideStatementString, -1, &insertGuideStatement, nil))
            print("Could not prepare insert guides statement")
        }
    }
    
    /**
     Given starter content from the JSON, populates teh DB with placeGuides, which connect places and guides (many-to-many)
    */
    static private func insertPlaceGuides(db:COpaquePointer, placeGuidesArr: NSArray) {
        let insertPlaceGuideStatementString = "INSERT INTO PlaceGuide(Place_id,Guide_id) VALUES (?,?);"
        var insertPlaceGuideStatement: COpaquePointer = nil
        if sqlite3_prepare_v2(db, insertPlaceGuideStatementString, -1, &insertPlaceGuideStatement, nil) == SQLITE_OK {
            for placeGuide in placeGuidesArr {
                let placeGuideDict = placeGuide as! NSDictionary
                sqlite3_bind_double(insertPlaceGuideStatement, 1, placeGuideDict.valueForKey("Place") as! Double)
                sqlite3_bind_double(insertPlaceGuideStatement, 2, placeGuideDict.valueForKey("Guide") as! Double)
                if sqlite3_step(insertPlaceGuideStatement) == SQLITE_DONE {
                    print("Successfully inserted placeGuide row.")
                } else {
                    print("Could not insert placeGuide row.")
                }
                sqlite3_reset(insertPlaceGuideStatement)
            }
            sqlite3_finalize(insertPlaceGuideStatement)
        } else {
            print("Could not prepare insert placeGuides statement")
        }
    }
    
    // ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
    // QUERY / ETC ...
    // Uses an instance of a connection to the db
    // ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----

    private var errorMessage: String {
        if let errorMessage = String.fromCString(sqlite3_errmsg(dbPointer)) {
            return errorMessage
        } else {
            return "No error message provided from sqlite."
        }
    }

    func prepareStatement(sql: String) throws -> COpaquePointer {
        var statement: COpaquePointer = nil
        guard sqlite3_prepare_v2(dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
            throw SQLiteError.Prepare(message: errorMessage)
        }
        return statement
    }
    
    /**
      Given a longitude, latitude, and search radius, and current time (in string format e.g. '0:20'), 
      returns (roughly) all open places within the radius... though as a square
    */
    func getPlaces(time:String, longitude:Float, latitude:Float, radius:Float) -> [Place] {
        var placesArr = [Place]()
        let querySql = "SELECT id, longitude, latitude, category, subcategory, name, address, phone, open_hour, close_hour, image_url, tags FROM Place" +
            " WHERE Longitude BETWEEN ? AND ? AND Latitude BETWEEN ? AND ? AND ? BETWEEN Open_hour AND Close_hour;"
        guard let queryStatement = try? prepareStatement(querySql) else { // If the statement after guard fails, we stop trying to get altogether
            return []
        }
        
        defer { sqlite3_finalize(queryStatement) }
        
        let longitude_start = longitude - radius
        let longitude_end = longitude + radius
        let latitude_start = latitude - radius
        let latitude_end = latitude + radius
        
        sqlite3_bind_double(queryStatement, 1, Double(longitude_start))
        sqlite3_bind_double(queryStatement, 2, Double(longitude_end))
        sqlite3_bind_double(queryStatement, 3, Double(latitude_start))
        sqlite3_bind_double(queryStatement, 4, Double(latitude_end))
        let nsTime: NSString = time
        sqlite3_bind_text(queryStatement, 5, nsTime.UTF8String, -1, nil)
        
        while(true) {
            guard sqlite3_step(queryStatement) == SQLITE_ROW else { // Stop looping when we step and it's not another record
                break
            }
            placesArr.append(SQLiteDatabase.placeFromQuery(queryStatement))
        }
        return placesArr
    }
    
    /**
      Given a place, returns all associated guides (and pages attached to the guide) as an array
    */
    func getGuidesForPlace(place:Place) -> [Guide] {
        var guidesArr = [Guide]()
        let querySql = "SELECT g.id, g.title, g.category, g.subcategory, g.hidden, g.image_url, g.description, g.tags FROM Guide as g" +
            " INNER JOIN PlaceGuide AS pg ON pg.guide_id = g.id INNER JOIN Place AS p ON pg.place_id = p.id" +
            " WHERE p.id = ?;"
        guard let queryStatement = try? prepareStatement(querySql) else {
            return []
        }
        defer { sqlite3_finalize(queryStatement) }
        sqlite3_bind_double(queryStatement, 1, Double(place.id))
        
        var newGuide:Guide
        while(true) {
            guard sqlite3_step(queryStatement) == SQLITE_ROW else {
                break
            }
            newGuide = SQLiteDatabase.guideFromQuery(queryStatement)
            newGuide.pages = self.getPagesForGuide(newGuide)
            guidesArr.append(newGuide)
        }
        return guidesArr
    }
    
    /**
     Given a guide, returns all associated places as an array
    */
    func getPlacesForGuide(guide:Guide) -> [Place] {
        var placesArr = [Place]()
        let querySql = "SELECT p.id, p.longitude, p.latitude, p.category, p.subcategory, p.name, p.address, p.phone, p.open_hour, p.close_hour, p.image_url, p.tags" +
            " FROM Place as p INNER JOIN PlaceGuide AS pg ON pg.place_id = p.id INNER JOIN Guide AS g ON pg.guide_id = g.id WHERE g.id = ?;"
        guard let queryStatement = try? prepareStatement(querySql) else {
            return []
        }
        defer { sqlite3_finalize(queryStatement) }
        sqlite3_bind_double(queryStatement, 1, Double(guide.id))
        while(true) {
            guard sqlite3_step(queryStatement) == SQLITE_ROW else {
                break
            }
            placesArr.append(SQLiteDatabase.placeFromQuery(queryStatement))
        }
        return placesArr
    }
    
    /**
     Given a guide, returns all associated pages as an array
    */
    func getPagesForGuide(guide:Guide) -> [Page] {
        var pagesArr = [Page]()
        let querySql = "SELECT id, title, description, image_url FROM Page WHERE guide_id = ?;"
        guard let queryStatement = try? prepareStatement(querySql) else {
            return []
        }
        defer { sqlite3_finalize(queryStatement) }
        sqlite3_bind_double(queryStatement, 1, Double(guide.id))
        while(true) {
            guard sqlite3_step(queryStatement) == SQLITE_ROW else {
                break
            }
            pagesArr.append(SQLiteDatabase.pageFromQuery(queryStatement))
        }
        return pagesArr
    }
    
    /**
     Given the pointer, returns a place. Assumes that the columns follow this order:
     Id, longitude, latitude, category, subcategory, name, address, phone, open_hour, close_hour, image_url, tags
    */
    static private func placeFromQuery(queryStatement: COpaquePointer) -> Place {
        let row_id:Int = Int(sqlite3_column_int(queryStatement, 0))
        let row_longitude:Float = Float(sqlite3_column_double(queryStatement, 1))
        let row_latitude:Float = Float(sqlite3_column_double(queryStatement, 2))
        let row_category = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(queryStatement, 3)))
        let row_subcategory = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(queryStatement, 4)))
        let row_name = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(queryStatement, 5)))
        let row_address = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(queryStatement, 6)))
        let row_phone = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(queryStatement, 7)))
        let row_open_hour = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(queryStatement, 8)))
        let row_close_hour = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(queryStatement, 9)))
        let row_image_url = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(queryStatement, 10)))
        let row_tags = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(queryStatement, 11)))

        return Place(id: row_id, longitude: row_longitude, latitude: row_latitude, category: row_category, subcategory: row_subcategory, name: row_name!, address: row_address, phone: row_phone, open_hour: row_open_hour, close_hour: row_close_hour, image_url: row_image_url, tags: row_tags)!
    }
    
    /**
     Given the pointer, returns a guide. Assumes that the columns follow this order:
     id, title, category, subcategory, hidden, image_url
     */
    static private func guideFromQuery(queryStatement: COpaquePointer) -> Guide {
        let row_id:Int = Int(sqlite3_column_int(queryStatement, 0))
        let row_title = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(queryStatement, 1)))
        let row_category = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(queryStatement, 2)))
        let row_subcategory = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(queryStatement, 3)))
        let row_hidden = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(queryStatement, 4)))
        let row_image_url = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(queryStatement, 5)))
        let row_description = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(queryStatement, 6)))
        let row_tags = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(queryStatement, 7)))
        
        if row_hidden != nil && row_hidden! == "0" {
            return Guide(id: row_id, title: row_title!, category: row_category!, subcategory: row_subcategory, hidden: false, image_url: row_image_url, description: row_description, tags:row_tags)
        } else {
            return Guide(id: row_id, title: row_title!, category: row_category!, subcategory: row_subcategory, hidden: true, image_url: row_image_url, description: row_description, tags:row_tags)
        }
    }
    
    /**
     Given the pointer, returns a page. Assumes that the columns follow this order:
     id, title, description, image_url
     */
    static private func pageFromQuery(queryStatement: COpaquePointer) -> Page {
        let row_id:Int = Int(sqlite3_column_int(queryStatement, 0))
        let row_title = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(queryStatement, 1)))
        let row_description = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(queryStatement, 2)))
        let row_image_url = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(queryStatement, 3)))
        
        return Page(id: row_id, title: row_title!, description: row_description, image_url: row_image_url)
    }
    
    /**
     Does exactly as title says it'll do.
    */
    func dropMigratePopulate() {
        SQLiteDatabase.drop(dbPointer)
        SQLiteDatabase.migrateTables(dbPointer)
        SQLiteDatabase.populate(dbPointer)
    }
    
    

}
