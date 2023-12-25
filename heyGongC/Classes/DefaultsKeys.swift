//
//  DefaultsKeys.swift
//  heyGongC
//
//  Created by 김은서 2023/12/25.
//

import Foundation
import SwiftyUserDefaults

/**
 *  SharedPreferenceUtil.java
 */
                                                    
extension DefaultsKeys {
    //기본정보
    var AUTH_TOKEN: DefaultsKey<String> { .init("AUTH_TOKEN", defaultValue:"") }
    var USER_ID: DefaultsKey<String> { .init("USER_ID", defaultValue:"") }
    var USER_C_ID: DefaultsKey<String> { .init("USER_C_ID", defaultValue:"") }
    var AUTH_CODE: DefaultsKey<String> { .init("AUTH_CODE", defaultValue:"") }
    
    var FINGER_STATE: DefaultsKey<Bool> { .init("FINGER_STATE", defaultValue:false) }
    var FCM_TOKEN: DefaultsKey<String> { .init("FCM_TOKEN", defaultValue:"") }
    var INTRO_SKIP: DefaultsKey<String> { .init("INTRO_SKIP", defaultValue:"") }
    var NO_UPDATE_DATE: DefaultsKey<String> { .init("NO_UPDATE_DATE", defaultValue:"") }    // cjlee 221228 선택 업데이트 하루보지않기 날짜    
    
    //계좌 개설 직후 서버 저장 전 계좌번호 _ 계좌번호 서버 저장할 때 오류나는 것을 방지하기 위해 _ (kes 220722)
    var NOT_SAVED_ACC_INFO: DefaultsKey<TransferCore5016.DataBody.AccountList?> { .init("ACC_INFO")}
    var IS_SAVED_ACC: DefaultsKey<Bool?> { .init("IS_SAVED_ACC") } //default값 _ 이미 계좌 개설 완료된 사람을 위해
    
    var AUTO_LOGIN: DefaultsKey<Bool> { .init("AUTO_LOGIN", defaultValue: false) }
    
    //------------------------------------
    // HOMEVC 에서 받는 defaultsKey 값
    //------------------------------------
    
    /* 큐레이터 관련 */
    var CURATOR_INFO: DefaultsKey<CuratorInfo?> { .init("CURATOR_INFO") }              // 큐레이터 정보_ 공유해준 사람 uid
    var CURATOR_MEM_INFO: DefaultsKey<CuratorMemInfo?> { .init("CURATOR_MEM_INFO") }              // 큐레이터 관리회원 정보
    
    //------------------------------------
    
    var EG_PROPENSITY_LOG: DefaultsKey<String> { .init("EG_PROPENSITY_LOG", defaultValue: "") }
    
    var CORP_EVENT_LIST: DefaultsKey<[TransferCore5622.CorpEventList]?> { .init("CORP_EVENT_LIST")}  // 유진 이벤트 여부
    var DECIMAL_PLACE: DefaultsKey<Int> { .init("DECIMAL_PLACE", defaultValue: 2) }  // kes 230509 소수점 서버값 적용
    var COPN_EXIST_YN: DefaultsKey<String> { .init("COPN_EXIST_YN", defaultValue: "N")} // kes 230731 쿠폰 배너 추가

    var PWD_EXPIRED: DefaultsKey<Bool> { .init("PWD_EXPIRED", defaultValue: false) }                  // 비밀번호 90일 제한 유효 여부
    
    //설정화면
    
    var UPDATE_STATUS: DefaultsKey<Int> { .init("UPDATE_STATUS", defaultValue: 2) }             // 업데이트 상태 값 0:최신 1:선택 2:필수
    
    var IS_PUSH: DefaultsKey<Bool> { .init("IS_PUSH", defaultValue: false) }            // kes 230323 푸시 왔는지 체크 후 상단바 이미지 on/off
    var EVENT_POPUP_EXPIRED: DefaultsKey<String> { .init("EVENT_POPUP_EXPIRED", defaultValue: "") }  // kes 230726 이벤트 팝업 하루동안 보지않기
    
    
    /*
     벤치마크 차트 체크
     */
    var BENCHMARK1_OPT: DefaultsKey<Bool> {.init("BENCHMARK1_OPT", defaultValue: false) }       // kes 230607 default로 체크 해제 적용
    var BENCHMARK2_OPT: DefaultsKey<Bool> {.init("BENCHMARK2_OPT", defaultValue: false) }
}
