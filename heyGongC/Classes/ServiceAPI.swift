//
//  ServiceAPI.swift
//  heyGongC
//
//  Created by 김은서 on 1/26/24.
//

import Foundation
import Moya

class ServiceAPI {
    static let shared = ServiceAPI()
    
    let baseUrl = "http://13.125.159.97/v1/users"
    
    struct RequestData {
        var itype: String = "1"
        var portGrpCd: String
        var comdKind: String
    }
    
    public func getData(params: RequestData) -> AnyObject {
        var data = [String : String]()
        
        data["itype"] = params.itype
        data["port_grp_cd"] = params.portGrpCd
        data["comd_kind"] = params.comdKind
        
        return data as AnyObject
    }
    
    public func judgeStatus<T: Codable>(response: Response, type: T.Type) -> NetworkResult2<GenericResponse<T>> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<T>.self, from: response.data) else { return .pathErr }
        
        switch response.statusCode {
        case 200..<300:
            if decodedData.status >= 400 {
                // 서버 통신은 정상적이지만, 원치 않는 결과로 인한 에러 대응 시 사용.
                return .success(decodedData)
            } else {
                return .success(decodedData)
            }
        case 400..<500:
            return .requestErr
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}

struct GenericResponse<T: Codable>: Codable {
    let code: String?
    let message: String?
    let status: Int
    let data: T?
}


// NetworkResult2.swift
public enum NetworkResult2<T> {
    case success(T)
    case requestErr
    case pathErr
    case serverErr
    case networkFail
}
