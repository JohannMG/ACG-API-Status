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
        
        switch endpointName.lowercased() {
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
    fileprivate let dataEndPoint = "https://ccm-web-tests.herokuapp.com/data"
    fileprivate let mandatoryRefreshEndpoint = "https://ccm-web-tests.herokuapp.com/refresh"
    
    static let sharedInstance = StatusDataService()
    fileprivate let session: URLSession
    
    fileprivate init(){
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
        
    }
    
    func refreshData( _ completion: @escaping (_ endpoints: [EndpointsCategory]?, _ error: Error?) -> Void ){
        
        let updateTask = session.dataTask( with: URL(string: dataEndPoint)!, completionHandler: {( data: Data?, response: URLResponse?, error: Error? ) in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, nil )
                return
            }
            
            do {
                if let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] {
                    completion(self.jsonResponseToObjects(jsonData), nil)
                }
                
            } catch {
                completion(nil, nil)
                return
            }
            
        })
        
        updateTask.resume()
        
    }
    
    fileprivate func jsonResponseToObjects( _ jsonData: [String: AnyObject] ) -> [EndpointsCategory] {
        
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

 
 
