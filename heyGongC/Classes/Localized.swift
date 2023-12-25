//
//  Localized.swift
//  heyGongC
//
//  Created by 김은서 2023/12/25.
//

import Foundation
import SwiftyUserDefaults

// MARK: - Localized
///버튼 하나 팝업창
enum Localized {
    case DLG_CAPTURE
    
    //Login
    case DLG_LOGIN_FAIL
    
    //splash
    case DLG_SERVICE_FAILURE
    case DLG_DISCONNECT_NETWORK
    case DLG_BLOCK
    
    //Register
    case DLG_CANNOT_JOIN
    case DLG_PHONE_CONFIRM_FAILED
    case DLG_CURATOR_REGISTER
    
    //내자산
    case DLG_TOTAL_ASSET
    case DLG_INVESTMENT_AMOUNT_HELP
    case DLG_TOTAL_AMOUNTS
    case DLG_TARGET_REVENUE
    case DLG_STOCK_ACCOUNT_HELP
    case DLG_NO_OPERATION_REPORT
    case DLG_TERMINATION_ING
    case DLG_PENSION_COPY
    case DLG_PENSION_DEPOSIT_MORE
    case DLG_PENSION_CANNOT_CHANGE
    
    //Invest
    case DLG_QUIT_INVEST
    case DLG_INVEST_POSSIBLE_AMOUNT
    case DLG_NO_MORE_ADD_INVEST
    
    //전략몰
    case DLG_PROD_DUPLICATE
    case DLG_RATE_MARKING_HELP
    case DLG_YEARS_TARGET_REVENUE
    case DLG_PENSION_CHANGE_ING
    case DLG_RA_CHART_HELP
    
    //설정
    case DLG_WITHDRAWAL_SUCCESS
    case DLG_PENSION_RECEIVE
    case DLG_CURATOR_BLOCK
    
    //모의
    case DLG_INVESTMENT_AMOUNT_HELP_MOCK
    case DLG_TOTAL_AMOUNTS_MOCK
    
    //account
    case DLG_ARS_ERROR
    case DLG_NH_ACC_ADD_SERVICE
    case DLG_HN_ID_CHECK
    
    case DLG_NOTARY_YET
    
    
    /**
     *  국문 (하드코딩)
     */
    var ko: String {
        switch self {
        case .DLG_CAPTURE: return "캡쳐가 감지되었습니다."
            // login
        case .DLG_LOGIN_FAIL: return "비밀번호 5회 오류로 로그인이 제한됩니다. 본인인증 후 비밀번호를 재설정하여 사용하시기 바랍니다."
            
            //splash
        case .DLG_SERVICE_FAILURE: return "현재, 서비스 장애가 발생하여 정상적인 서비스 이용이 불가능합니다.\n현재 원인 확인 중이며, 빠른 시간 내에 조치될 수 있도록 하겠습니다.\n\n다시 한번 서비스 이용에 불편을 드려 죄송합니다."
        case .DLG_DISCONNECT_NETWORK: return "인터넷 연결이 되어 있지 않아요.\n연결 상태를 다시 확인해 주세요."
        case .DLG_BLOCK: return "현재 고객님께서는 영구 정지 상태입니다.\n\n영구 정지 상태인 경우 서비스 이용이 불가합니다. 이용 계약 해지 및 신청은 고객센터를 통해 확인 부탁드립니다.\n\n고객센터 : 02-6339-2100\n\n감사합니다."
            
            //Register
        case .DLG_CANNOT_JOIN: return "만 19세 이상 고객님만\n회원 가입할 수 있어요."
        case .DLG_PHONE_CONFIRM_FAILED: return "발송된 인증 번호를\n정확하게 입력해주세요."
        case .DLG_CURATOR_REGISTER: return "회원 가입을 완료해야 정식으로 큐레이터\n관리 회원으로 등록돼요"
            
            
            //내자산
        case .DLG_TOTAL_ASSET: return "콴텍 전략(계약)에 투자한 금액 및 증권계좌의 잔여 잔고의 합계 금액이에요. 전략가입 및 중도 해지 과정에서 일시적인 금액 차이가 발생할 수 있고 매매 체결 마감 및 실시간 시세 반영 차이로 인하여 표시 금액 차이가 날 수 있어요."
        case .DLG_TARGET_REVENUE: return "콴텍이 제시하는 목표 수익률은 고객 관점의 중장기 목표 수익률이에요.\n목표 수익률은 고객이 위험 자산의 단기 파동에 흔들리지 않고 중장기 투자를 실천할 수 있도록 도움을 줘요.\n\n운용 전략의 목표 수익률은 개별 운용 알고리즘의 투자 비중을 고려하여 계산해요.\n개별 목표 수익률은 추정 성과의 안정성을 위해 예를 들어 10년 또는 20년 이상의 장기 성과를 기반으로 추산해요.\n\n구체적으로 과거 장기간의 추정치를 바탕으로 투자성향(위험등급)에 따라 채권 수익률 및 알고리즘의 연환산 실현 수익률 등을 반영한 후 보수적인 관점에서 목표 수익률의 달성 확률을 높이기 위해 목표 수익률의 최대값을 제한하고 있어요.\n\n목표 수익률은 장기 추정 평균에 근접하기 때문에 특정 시기에 실제 수익률은 목표 수익률보다 더 높거나 더 낮을 수 있어요.\n\n시장 전체가 하락하거나 침체기라는 이유로 목표 수익률이 동반 하락하지 않고 미래의 기대 수익률은 더 높아져요."
        case .DLG_INVESTMENT_AMOUNT_HELP: return "고객이 가입한 콴텍 전략(계약)의 총 합계 금액이에요."
        case .DLG_INVESTMENT_AMOUNT_HELP_MOCK: return "모의투자를 통해 고객이 가입한 전략(들)의 합계 금액이에요."
        case .DLG_TOTAL_AMOUNTS: return "- 전략 투자금액과 전략 손익금액의 합계 금액이에요.\n- 평가금액은 실시간 반영이 아닌, 익영업일 오전에 반영돼요.\n- 실시간 반영이 아니므로 증권사 평가금액과 차이가 날 수 있어요."
        case .DLG_TOTAL_AMOUNTS_MOCK: return "모의투자를 통해 고객이 투자한 전략(들)의 투자금액과 손익금액의 합계 금액이에요.\n\n평가금액은 실시간 반영이 아닌, 투자완료시 & 익일(영업일 기준)에 반영 돼요."
        case .DLG_STOCK_ACCOUNT_HELP: return "콴텍 전략(계약)에 투자한 금액 및 증권계좌의 잔여 잔고의 합계 금액입니다.\n전략 가입 및 중도 해지 과정에서 일시적인 금액 차이가 발생할 수 있고 매매 체결 마감 및 실시간 시세 반영 차이로 인하여 표시 금액 차이가 날 수 있습니다."
        case .DLG_TERMINATION_ING: return "매매 체결이 진행 중이에요.\n체결 완료 후, 해지해 주세요."
        case .DLG_NO_OPERATION_REPORT: return "작성된 보고서가 없어요"
        case .DLG_PENSION_COPY: return "타사 연금저축 계좌를 가지고 계신가요?\n기존 연금저축 계좌를 이어서 하실 수 있어요.\n\n이전 없이 입금을 하면 타사 연금저축 계좌를 가져올 수 없어요."
        case .DLG_PENSION_DEPOSIT_MORE: return "'추가 입금 가능 금액'은 연 입금 한도 금액에서 당해연도 투자 원금을 뺀 나머지 금액입니다.(타사 연금저축 이전 금액 제외)\n'연 입금 한도'를 변경하여 추가 투자 가능 금액을 조정할 수 있어요."
        case .DLG_PENSION_CANNOT_CHANGE: return "이전 가능한 타사 연금저축 계좌가 없어요\n\n개설한 연금계좌에 직접 입금 후, 바로 투자를 시작해 보아요."
            
            //Invest
        case .DLG_QUIT_INVEST: return "투자를 정말 그만두시겠어요?"
        case .DLG_INVEST_POSSIBLE_AMOUNT: return "투자가능금액은 고객이 입금한 증권계좌의 현금 잔고에서 콴텍 전략(계약)에 가입한 금액을 차감한 잔여 현금 잔고와 일치하지 않을 수 있어요.\n\n고객 편의를 위해 고객 계좌에서 하나 이상의 다전략을 운용할 수 있는 구조이기 때문에 투자가능금액은 증권사에서 제공하는 계좌의 출금가능금액에서 투자 중인 콴텍 전략 (계약)내 잔여 현금 등을 차감하여 산출해요. 하나의 계좌에서 전략 운용 및 국내외 주식, ETF 등의 매매와 입출금 등의 거래들로 인해 현금 잔고 기준의 투자가능금액과 다를 수 있어요."
            
            //전략몰
        case .DLG_PROD_DUPLICATE: return "이미 보유 중인 전략이에요.\n추가 투자 하시겠어요?"
        case .DLG_RATE_MARKING_HELP: return "전략이 가지고 있는 등급 중 고객님의 투자 성향과 일치하는 등급의 수익률을 우선 표기해요.\n고객님의 투자 성향과 일치하는 등급이 없는 경우 그보다 낮은 등급의 수익률을 표기해요.​"
        case .DLG_YEARS_TARGET_REVENUE: return "콴텍은 알고리즘의 실제 연 환산수익률, 장기간 운용 시뮬레이션 수익률 그리고 10년 국채 수익률 등을 고려하여 평균적인 가정을 바탕으로 합리적인 연 목표 수익률을 제시해 드려요.\n\n일반적으로 동일한 위험등급의 경우 상대적으로 낮은 연 목표 수익률이 제시되어 있다면 실현 수익률의 변동성이 낮거나 투자 위험이 상대적으로 낮다고 볼 수 있어요."
        case .DLG_PENSION_CHANGE_ING: return "타사 연금저축을 이전 중 이에요.\n이전완료 후, 투자해 주세요.\n(이체 완료 시, 알림 제공)"
        case .DLG_RA_CHART_HELP: return "로보어드바이저 테스트베드 심사를 통과한 콴텍 투자전략의 알고리즘에 대한 과거 데이터를 토대로 작성된 그래프로, 참고용도로만 활용해 주세요."
            
            //설정
        case .DLG_WITHDRAWAL_SUCCESS: return "회원 탈퇴가 완료되었어요.\n그동안 콴텍을 이용해주셔서 감사해요."
        case .DLG_PENSION_RECEIVE: return "계좌 가입 후 5년 경과 및 만 55세 이후 연금 수령이 가능해요.\n(ex, 만 30세 가입 시 만 55세, 만 51세 가입 시 만 56세 개시 가능)"
        case .DLG_CURATOR_BLOCK: return "정보를 확인할 수 없어요.\n고객센터로 문의해 주세요."
            
        case .DLG_ARS_ERROR: return "ARS 전화 수신 후, 바로 인증번호를 입력해주세요.\n\n해당 오류가 지속될 시 고객센터(1566-6349)로 문의해 주세요."
            
        case .DLG_NO_MORE_ADD_INVEST: return "기존 추가 투자 건에 대한 체결이 완료된 후 추가투자 할 수 있어요!"
            
        case .DLG_NH_ACC_ADD_SERVICE: return "해외 상품 가입을 위해 부가서비스 등록이 반드시 필요합니다.\n미등록 시 이후에는 NH증권의 나무앱에서만 등록이 가능하니 반드시 서비스 등록을 해주세요."
            
        case .DLG_HN_ID_CHECK: return "하나증권에서\n신분증 진위 확인 중이에요."
            
        case .DLG_NOTARY_YET: return "계약서 공증 대기중이에요"
        }
    }
    var subTitle: String {
        switch self {
        case .DLG_TOTAL_ASSET: return "계좌 총 자산이란?"
        case .DLG_TARGET_REVENUE: return "목표 수익률이란?"
        case .DLG_INVESTMENT_AMOUNT_HELP: return "투자 금액이란?"
        case .DLG_INVESTMENT_AMOUNT_HELP_MOCK: return "투자 금액이란?"
        case .DLG_TOTAL_AMOUNTS: return "평가 금액이란?"
        case .DLG_TOTAL_AMOUNTS_MOCK: return "평가 금액이란?"
        case .DLG_STOCK_ACCOUNT_HELP: return "증권 계좌 잔액이란?"
        case .DLG_PENSION_DEPOSIT_MORE: return "추가 입금 가능 금액이란?"
        case .DLG_INVEST_POSSIBLE_AMOUNT: return "투자 가능 금액 이란?"
        case .DLG_RATE_MARKING_HELP: return "수익률 표기 기준?"
        case .DLG_RA_CHART_HELP: return "RA테스트베드 기준가?"
        case .DLG_PENSION_RECEIVE: return "연금수령 개시 가능일이란?"
            
        default: return ""
        }
    }
    var title: String{
        switch self{
        case .DLG_LOGIN_FAIL: return "로그인 제한"
        case .DLG_BLOCK: return "영구 정지 안내"
        case .DLG_PENSION_COPY: return "직접 입금을 진행하시겠어요?"
        case .DLG_NO_OPERATION_REPORT, .DLG_QUIT_INVEST, .DLG_PROD_DUPLICATE, .DLG_WITHDRAWAL_SUCCESS, .DLG_PENSION_CHANGE_ING, .DLG_TERMINATION_ING, .DLG_CURATOR_REGISTER, .DLG_CURATOR_BLOCK, .DLG_PENSION_CANNOT_CHANGE, .DLG_NH_ACC_ADD_SERVICE, .DLG_NOTARY_YET, .DLG_CAPTURE: return ""
            
        case .DLG_DISCONNECT_NETWORK: return "연결실패"
            
        case .DLG_SERVICE_FAILURE: return "서비스 이용 불가"
            
        case .DLG_INVESTMENT_AMOUNT_HELP, .DLG_TOTAL_AMOUNTS, .DLG_TARGET_REVENUE, .DLG_STOCK_ACCOUNT_HELP, .DLG_INVEST_POSSIBLE_AMOUNT, .DLG_RATE_MARKING_HELP, .DLG_YEARS_TARGET_REVENUE, .DLG_PENSION_RECEIVE, .DLG_TOTAL_ASSET, .DLG_PENSION_DEPOSIT_MORE, .DLG_RA_CHART_HELP, .DLG_INVESTMENT_AMOUNT_HELP_MOCK, .DLG_TOTAL_AMOUNTS_MOCK:
            return "도움말"
            
        case .DLG_CANNOT_JOIN: return "회원가입 불가"
        case .DLG_PHONE_CONFIRM_FAILED: return "인증번호 오류"
        case .DLG_ARS_ERROR: return "인증 실패"
            
        case .DLG_NO_MORE_ADD_INVEST: return "추가 투자 안내"
            
        case .DLG_HN_ID_CHECK: return "알림"
        }
    }
    
    var confirmTitle: String {
        switch self {
        case .DLG_LOGIN_FAIL: return "본인 인증하기"
        case .DLG_BLOCK: return "앱 종료하기"
        case .DLG_PENSION_COPY: return "계좌번호 복사"
        case .DLG_CURATOR_REGISTER, .DLG_CURATOR_BLOCK, .DLG_PENSION_CANNOT_CHANGE, .DLG_NO_MORE_ADD_INVEST, .DLG_NH_ACC_ADD_SERVICE, .DLG_HN_ID_CHECK, .DLG_NOTARY_YET, .DLG_CAPTURE: return "확인"
            
        default: return "닫기"
        }
    }
    
    /**
     *  다국어 처리
     */
    var txt: String {
        return ""
    }
}

// MARK: - AlertCancel
///버튼 두개 팝업창 string
enum AlertCancel{
    
    /* SplashView */
    case DLG_UPDATE
    
    /* LoginVC */
    case DLG_PWD_EXPIRED
    
    /* MainTBC */
    case alertNoPersonality
    case alertNoProduct
    
    /* Account */
    case DLG_ACC_OPEN_CONTINUE
    case DLG_SETTING_EG_ACC
    case DLG_QUIT_LINKED_ACC
    case DLG_KB_QUIT_ACC
    
    /* productDetail */
    case DLG_PRODUCT_NO_ACCOUNT
    case DLG_PRODUCT_NO_AGREE
    case DLG_PRODUCT_TERMINATION
    case DLG_PRODUCT_HAVING
    case DLG_NO_MORE_VIEW
    case DLG_MORE_INVEST
    
    /* 투자 관련 */
    case DLG_INVEST_ADDITIONAL_CANCEL
    case DLG_INVEST_CANCEL
    case DLG_TERMINATE_CANCEL
    
    /* 모의 투자 */
    case DLG_MOCK_PRODUCT_HAVING
    case DLG_MOCK_INVEST_PUSH
    case DLG_MOCK_INVEST
    case DLG_MOCK_TERMINATE
    
    case DLG_OPEN_ACCOUNT
    
    /* Pension */
    case DLG_PENSION_CHANGE
    case DLG_ACC_TERMINATION
    case DLG_CANT_ACC_TERMINATION
    case DLG_PENSION_FAIL
    
    /* Setting */
    case DLG_TYPE_QUIT
    case DLG_CANNOT_WITHDRAWAL
    case DLG_LOGOUT
    case DLG_PRODUCT_TERMINATE
    
    /* Fido */
    case DLG_FIDO_FACEID
    case DLG_FIDO_FINGER
    
    /* Qrator */
    case DLG_QRATOR_REGISTER
    case DLG_QRATOR_NO_BIO_LOGIN
    
    case DLG_COUPON_NO_ACC
    
    var title: String{
        switch self{
            
        case .DLG_PWD_EXPIRED: return "비밀번호 변경 안내"
        case .DLG_PENSION_FAIL: return "연금이전 신청이 취소되었어요"
        case .DLG_UPDATE: return "업데이트"
        case .DLG_INVEST_ADDITIONAL_CANCEL: return "추가 투자 취소"
        case .DLG_INVEST_CANCEL: return "전략 가입 취소"
        case .DLG_TERMINATE_CANCEL: return "해지 취소 안내"
            
        case .DLG_PRODUCT_TERMINATE: return "해지 안내"
            
        case .DLG_FIDO_FACEID: return "FACE ID 등록"
        case .DLG_FIDO_FINGER: return "지문 등록"
            
        case .DLG_COUPON_NO_ACC: return "계좌개설"
            
        default:
            return ""
        }
    }
    
    var msg: String{
        switch self{
            
        case .DLG_UPDATE: return "업데이트 하시겠습니까?"
            
        case .DLG_PWD_EXPIRED: return "비밀번호를 설정한지\n90일이 지났어요."
            
        case .alertNoPersonality: return "적합한 투자 전략 선택을 위해\n내 투자 성향을 알아보세요."
        case .alertNoProduct: return "고객님의 투자성향으로는\n본 전략을 가입할 수 없어요."
            
        case .DLG_PRODUCT_NO_ACCOUNT: return "투자가능 계좌 정보가 없어요.\n계좌를 개설해 주세요."
        case .DLG_PRODUCT_NO_AGREE: return "계좌 연동 단계가 남았어요.\n계좌를 확인해주세요."
        case .DLG_PRODUCT_TERMINATION: return "해지 진행 중인 전략이에요.\n내자산에서 해당 전략의 해지 진행 내역을\n확인해 주세요."
        case .DLG_INVEST_ADDITIONAL_CANCEL: return "다음 영업일 오전 8시까지 취소가 가능해요.\n지금 취소 할까요?"
        case .DLG_PRODUCT_HAVING: return "이미 가입하신 전략이에요.\n\n자세한 운용정보는 [내자산>연금계좌] 에서 확인해 주세요."
        case .DLG_NO_MORE_VIEW: return "더 자세한 전략 내용은 준비중 이에요.\n\n다양하고 재미있는 콘텐츠가 많은 블로그에 방문하시겠어요?"
            
        case .DLG_MOCK_PRODUCT_HAVING: return "이미 가입하신 전략이에요.\n\n자세한 투자정보는 [내자산(모의투자)]에서 확인해 주세요."
        case .DLG_MOCK_INVEST_PUSH: return "추천 드린 전략의 수익률을 계속 확인하실 수 있도록 모의투자 해두었어요!\nPUSH를 설정해 두시면 해당 전략의 수익률을 안내드릴게요!"
        case .DLG_MOCK_INVEST: return "추천 드린 전략의 수익률을 계속 확인하실 수 있도록 모의투자 해두었어요!"
            
        case .DLG_PENSION_CHANGE: return "계좌 이전을 신청하시겠어요?\n계좌 이전은 최초 1회만 가능하며, 신청 후, 취소는 해당 금융사를 통해서만 처리 가능 해요.\n‘연 입금 한도’는 이전 완료 후, 연한도 금액(잔여 한도 금액 포함) 내에서 언제든지 변경 가능합니다."
        case .DLG_PENSION_FAIL: return "이전 취소에 대한 자세한 내용은\n해당 금융기관을 통해 확인해 주세요.\n\n*연금이전을 재신청 하거나, 이전을 원치 않을 경우, 개설한 계좌에 직접 입금하시면 후, 바로 투자하실 수 있어요."
        case .DLG_ACC_TERMINATION: return "계좌 해지 시, 해당 계좌는 더 이상 콴텍에서 이용할 수 없으며, 재이용을 위해서는 계좌를 개설해야 해요.\n(연동 해지 계좌는 증권사에서만 이용 가능)"
        case .DLG_CANT_ACC_TERMINATION: return "해당 계좌로 투자중인 전략이 있어요.\n전략 해지 후, 계좌 연동을 해지해 주세요."
            
        case .DLG_CANNOT_WITHDRAWAL: return "일임계약 중인 계좌가 있어요\n회원 탈퇴를 위해\n계좌를 먼저 해지해 주세요"
            
        case .DLG_PRODUCT_TERMINATE: return "정말 투자를 해지하시겠어요?"
            
        case .DLG_LOGOUT: return "로그아웃 하시겠어요?"
            
        case .DLG_TYPE_QUIT: return "성향분석을 그만두시겠어요?\n그만두면 처음부터 다시 해야해요."
            
        case .DLG_FIDO_FACEID: return "FACE ID를 등록하면 서비스를\n더욱 간편하게 사용할 수 있어요."
        case .DLG_FIDO_FINGER: return "지문을 등록하면 서비스를\n더욱 간편하게 사용할 수 있어요."
            
        case .DLG_ACC_OPEN_CONTINUE: return "이전에 진행하던 계좌 개설 정보가 있어요.\n이어서 진행하시겠어요?"
            
        case .DLG_SETTING_EG_ACC: return "해당 계좌(%@)를\n연동계좌로 설정하시겠어요?"
            
        case .DLG_QUIT_LINKED_ACC: return "계좌 연동을 멈추시겠어요?"
            
        case .DLG_MORE_INVEST: return "이미 선택한 계좌와 위험등급으로\n가입하여 운용 중인 전략이에요.\n추가투자 하시겠어요?"
            
        case .DLG_OPEN_ACCOUNT: return "계좌개설 후 확인할 수 있어요!"
            
        case .DLG_MOCK_TERMINATE: return "모의투자를 해지하시겠어요?\n\n재가입시 수익률이 초기화돼요! 🥺"
            
        case .DLG_QRATOR_REGISTER: return "%@님을 큐레이터로 등록하시겠어요?\n등록 이후 변경이 불가해요!"
        case .DLG_QRATOR_NO_BIO_LOGIN: return "생체로그인 설정 후, 이용가능해요."
        case .DLG_KB_QUIT_ACC: return "계좌개설을 나중에 할까요?\n4일 이내에 다시 진행하시면\n계좌개설을 이어할 수 있어요!"
        case .DLG_COUPON_NO_ACC: return "투자지원금을 받기 위해서는 콴텍전용계좌가 필요해요!  계좌개설하시겠어요?"
        case .DLG_INVEST_CANCEL: return "다음 영업일 오전 8시까지 가입 취소가 가능해요.\n지금 취소 할까요?"
        case .DLG_TERMINATE_CANCEL: return "정말 해지 취소하시겠어요?"
        }
    }
    
    var confirmTitle: String{
        switch self{
        case .DLG_UPDATE: return "업데이트 하기"
            
        case .DLG_PWD_EXPIRED: return "변경하기"
            
            //MainTBC
        case .alertNoPersonality: return "투자 성향 알아보기"
        case .alertNoProduct: return "투자성향 보기"
            
        case .DLG_PRODUCT_NO_ACCOUNT, .DLG_OPEN_ACCOUNT: return "계좌 개설하기"
        case .DLG_PRODUCT_NO_AGREE: return "계좌 확인하기"
        case .DLG_PRODUCT_HAVING, .DLG_PRODUCT_TERMINATION, .DLG_MOCK_PRODUCT_HAVING: return "확인하러 가기"
            
        case .DLG_PENSION_CHANGE: return "신청하기"
        case .DLG_PRODUCT_TERMINATE, .DLG_MOCK_TERMINATE: return "해지하기"
        case .DLG_PENSION_FAIL: return "이전 재신청"
            
        case .DLG_ACC_TERMINATION: return "연동 해지하기"
        case .DLG_CANT_ACC_TERMINATION: return "내 자산으로 이동"
            
        case .DLG_CANNOT_WITHDRAWAL: return "계좌 관리"
        case .DLG_LOGOUT: return "네"
        case .DLG_TYPE_QUIT, .DLG_QUIT_LINKED_ACC: return "계속하기"
            
        case .DLG_FIDO_FACEID, .DLG_FIDO_FINGER, .DLG_QRATOR_REGISTER: return "등록하기"
        case .DLG_ACC_OPEN_CONTINUE: return "이어서 하기"
        case .DLG_SETTING_EG_ACC: return "예"
        case .DLG_NO_MORE_VIEW: return "방문할게요"
            
        case .DLG_MORE_INVEST: return "추가 투자하기"
            
        case .DLG_MOCK_INVEST_PUSH: return "PUSH설정"
        case .DLG_MOCK_INVEST: return "확인"
            
        case .DLG_QRATOR_NO_BIO_LOGIN: return "설정하기"
        case .DLG_KB_QUIT_ACC: return "그만하기"
        case .DLG_COUPON_NO_ACC: return "지금하기"
            
        case .DLG_INVEST_ADDITIONAL_CANCEL: return "추가 투자 취소"
        case .DLG_INVEST_CANCEL: return "가입 취소"
        case .DLG_TERMINATE_CANCEL: return "해지 취소"
        }
    }
    
    var cancelTitle: String{
        switch self{
            
        case .DLG_COUPON_NO_ACC, .DLG_INVEST_ADDITIONAL_CANCEL, .DLG_INVEST_CANCEL, .DLG_TERMINATE_CANCEL: return "안할래요"
        case .DLG_UPDATE: return "하루동안 보지 않기"
            
        case .DLG_PWD_EXPIRED, .DLG_MOCK_INVEST_PUSH: return "괜찮아요"
        case .DLG_PRODUCT_TERMINATE: return "유지하기"
            
        case .alertNoPersonality, .DLG_MORE_INVEST, .DLG_PRODUCT_NO_ACCOUNT, .alertNoProduct, .DLG_PENSION_FAIL, .DLG_PRODUCT_HAVING, .DLG_MOCK_PRODUCT_HAVING, .DLG_OPEN_ACCOUNT: return "닫기"
        case .DLG_PENSION_CHANGE, .DLG_ACC_TERMINATION, .DLG_CANT_ACC_TERMINATION, .DLG_CANNOT_WITHDRAWAL: return "취소"
        case .DLG_LOGOUT, .DLG_ACC_OPEN_CONTINUE, .DLG_SETTING_EG_ACC, .DLG_PRODUCT_NO_AGREE, .DLG_PRODUCT_TERMINATION, .DLG_QRATOR_REGISTER, .DLG_KB_QUIT_ACC: return "아니요"
        case .DLG_TYPE_QUIT: return "그만두기"
            
        case .DLG_FIDO_FACEID, .DLG_FIDO_FINGER: return "사용안함"
        case .DLG_NO_MORE_VIEW: return "나중에요"
        case .DLG_QUIT_LINKED_ACC, .DLG_MOCK_TERMINATE: return "다음에 하기"
        case .DLG_QRATOR_NO_BIO_LOGIN: return "확인"
            // kes 230308 취소버튼 없는 애들 TODO: Localized와 통합 필요
        case .DLG_MOCK_INVEST: return ""
        }
    }
}

struct Strings {
    static let investNoMatch = "\(Keychains.shared.USER_NM) 님의 성향에 맞는\n전략이 존재하지 않아요."
    static let investNoProduct = "전략이 존재하지 않아요."
    static let TOAST_COPY = "계좌번호가 복사되었어요"
    static let TOAST_FAIL_AUTHENTICATION = "인증에 실패하였습니다"
    static let ERROR_MSG = "잠시 후 다시 시도해주세요"
    static let TOAST_INVEST_COMPLETED_STOCK = "다음 영업일 부터 투자가 시작돼요"
    static let TOAST_INVEST_COMPLETED_PENSION = "투자금이 확인되면 영업일 기준 다음날부터 자동으로 투자가 진행돼요"
    static let COMING_SOON = "곧 제공될 예정입니다"
    static let CANNOT_INVEST = "선택한 위험등급으로는 투자할 수 없어요"
    static let ERROR_MSG_LOGIN = "다른 곳에서 로그인되어서 로그아웃되었습니다."
    static let TOAST_MOCK_INVEST_COMPLETED = "모의투자를 시작합니다"
    static let TOAST_REGISTER_COUPON = "쿠폰을 정상적으로 등록했어요!"
    static let TOAST_CACNEL_CONTRACT = "가입이 취소되었어요."
    static let TOAST_CACNEL_ADDITIONAL = "추가 투자가 취소되었어요."
    static let TOAST_CACNEL_TERMINATE = "해지가 취소되었어요."
    static let TOAST_MODIFY_SAME_AMOUNT = "변경할 금액을 확인해 주세요!"
}
