//
import Foundation

public struct EndpointsCategory {
    let categoryName: String?
    var endpoints: [Endpoint]?
    
    init(jsonEndpoints: [String: AnyObject], name: String){
        categoryName = name
        endpoints = [Endpoint]()
        
        for (key, value) in jsonEndpoints {
            
            let singleEndpoint = Endpoint(endpointName: key, statusCode: value["status"] as? Int, responseTime: value["responseTime"] as? Int, lastUpdated: value["time"] as? String)
            endpoints?.append(singleEndpoint)
        }
    }
    
}

public struct Endpoint {
    let endpointName: String?
    let statusCode: Int?
    let responseTime: Int?
    let lastUpdated: String?
    
    func getEndpointName() -> String{
        guard let endpointName = endpointName else { return "" }
        
        switch endpointName.lowercaseString {
        case "zipgate":
            return "ZipGate"
        case "login":
            return "Login"
        case "myaaa":
            return "My AAA"
        case "getmessages":
            return "Messages"
        case "customerinformation":
            return "Customer"
        default:
            return endpointName
        }
    }
    
}

class StatusDataService {
    private let dataEndPoint = "https://ccm-web-tests.herokuapp.com/data"
    private let mandatoryRefreshEndpoint = "https://ccm-web-tests.herokuapp.com/refresh"
    
    static let sharedInstance = StatusDataService()
    private let session: NSURLSession
    
    private init(){
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: config)
        
    }
    
    func refreshData( completion: (endpoints: [EndpointsCategory]?, error: NSError?) -> Void ){
        let updateTask = session.dataTaskWithURL( NSURL(string: dataEndPoint)! ) {( data: NSData?, response: NSURLResponse?, error: NSError? ) in
            
            if let error = error {
                completion(endpoints: nil, error: error)
                return
            }
            
            guard let data = data else {
                completion(endpoints: nil, error: nil )
                return
            }
            
            do {
                if let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject] {
                    completion(endpoints: self.jsonResponseToObjects(jsonData), error:  nil)
                }
                
            } catch {
                completion(endpoints: nil, error: nil)
                return
            }
            
        }
        
        updateTask.resume()
        
    }
    
    private func jsonResponseToObjects( jsonData: [String: AnyObject] ) -> [EndpointsCategory] {
        
        var allResults = [EndpointsCategory]()
        
        if let aaa = jsonData["aaaEndpoints"] as? [String:AnyObject]{
            allResults.append(EndpointsCategory(jsonEndpoints: aaa, name: "AAA"))
        }
        
        if let acg = jsonData["acgEndPoints"] as? [String: AnyObject] {

            if let acgPROD = acg["PROD"] as? [String: AnyObject] {
                allResults.append(EndpointsCategory(jsonEndpoints: acgPROD, name: "PROD"))
            }
            
            if let acgQA = acg["QA"] as? [String:AnyObject] {
                allResults.append(EndpointsCategory(jsonEndpoints: acgQA, name: "QA"))
            }
        }
        
        return allResults
    }
    
}

/**
{
    "acgEndPoints": {
        "QA": {
            "login": {
                "status": 201,
                "time": "2016-12-11T19:16:50.437Z",
                "responseTime": 46999
            },
            "customerInformation": {
                "status": -1,
                "time": null,
                "responseTime": null
            },
            "myAAA": {
                "status": -1,
                "time": null,
                "responseTime": null
            },
            "getMessages": {
                "status": 204,
                "time": "2016-12-11T19:16:41.737Z",
                "responseTime": 38295
            }
        },
        "PROD": {
            "login": {
                "status": 201,
                "time": "2016-12-11T19:16:03.696Z",
                "responseTime": 268
            },
            "customerInformation": {
                "status": 200,
                "time": "2016-12-11T19:16:05.186Z",
                "responseTime": 1755
            },
            "myAAA": {
                "status": 200,
                "time": "2016-12-11T19:16:03.989Z",
                "responseTime": 554
            },
            "getMessages": {
                "status": 204,
                "time": "2016-12-11T19:16:03.646Z",
                "responseTime": 210
            }
        }
    },
    "aaaEndpoints": {
        "zipGate": {
            "status": 200,
            "time": "2016-12-11T19:16:04.226Z",
            "responseTime": 815
        }
    }
}
 */

 
 