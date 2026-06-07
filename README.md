# 📱 ImageSearchApp -- iOS Clean Architecture Sample

**ImageSearchApp**은 **Unsplash 이미지 검색 API**를 기반으로 이미지를 검색하고, 즐겨찾기(Bookmark)할 수 있는 iOS 애플리케이션입니다.

**RxSwift + ReactorKit**을 중심으로 단방향 상태 흐름을 구성하였으며,  **Clean Architecture** 구조를 적용해 화면 로직과 비즈니스 로직의 책임을 명확히 분리하는 것을 목표로 개발했습니다.

------------------------------------------------------------------------

## 📌 주요 기능
- 검색어 기반 unsplash 이미지 검색
- Infinite Scroll 이미지 리스트 페이징
- CoreData기반 즐겨찾기(Bookmark) 저장
- iPhone, iPad 대응

## 🚀 기술 스택 
### **Architecture**
- Clean Architecture (Presentation / Domain / Data)
- ReactorKit 기반 단방향 상태 흐름

### **Reactive**
- RxSwift
- RxDataSources
- ReactorKit

### **Networking / Utilities**
- Alamofire
- ReusableKit
- RxKingfisher
- Then
- SnapKit

------------------------------------------------------------------------

## 🎯 개발 목표 및 의도

### ✔ 단방향 상태 흐름 유지
- 검색, 페이징, 북마크 토글 등 화면 상태가 복잡해질 수 있는 상황에서, 상태 변화를 예측 가능하게 관리하기 위해 ReactorKit을 선택으며, View → Action → Mutation → State 흐름을 일관되게 유지하여 비즈니스 로직이 ViewController에 혼재되지 않도록 구성했습니다.

------------------------------------------------------------------------

## 🔧 프로젝트 사용 의존성
- Alamofire
- ReactorKit
- ReusableKit
- RxDataSources
- RxKingfisher
- RxSwift
- SnapKit
- Then

------------------------------------------------------------------------

## 📬 Contact
- **Email:** vkcldhkd@gmail.com
- **GitHub:** https://github.com/vkcldhkd
- **LinkedIn:** https://www.linkedin.com/in/sung9

