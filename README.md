# 📱 ImageSearchApp -- iOS Clean Architecture Sample

**ImageSearchApp**은 **Kakao 이미지 검색 API**를 기반으로 이미지를 검색하고, 즐겨찾기(Bookmark)할 수 있는 iOS 애플리케이션입니다.

**RxSwift + ReactorKit**을 중심으로 단방향 상태 흐름을 구성하였으며,  **Clean Architecture** 구조를 적용해 화면 로직과 비즈니스 로직의 책임을 명확히 분리하는 것을 목표로 개발했습니다.

------------------------------------------------------------------------

## 📌 주요 기능
- 검색어 기반 Kakao 이미지 검색
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

## 🛠 향후 개선하고 싶은 점
### 1. CoreData 레이어도 Clean Architecture로 분리
- 다른 부분들을 신경쓰다보니, Coredata 부분은 제가 예전에 사용하던 방식 그대로 사용한것이 아쉬웠습니다. 클린아키텍처로 조금 더 관심사 분리를 통해 작성했으면 구조적으로 더 완성도가 높아졌을 것이라 생각합니다.

### 2. UICollectionView 개선
- iPhone 기반 시뮬레이터에서 개발을 진행할 때는 문제가 전혀 없었으나, iPad 시뮬레이터를 통해 테스트를 진행해보니, 레이아웃이 어색하게 보이는 문제가 발생했습니다. iPad 환경에서는 Pinterest 스타일의 WaterfallLayout을 적용해 이미지 비율을 유지하면서도 시각적으로 더 균형 잡힌 레이아웃을 제공할 수 있을 것이라 판단했습니다.

### 3. UX/UI 개선
- 검색 결과 화면과 북마크 화면을 하나의 CollectionView에서 전환하다 보니, 타입 전환 시 이전 스크롤 위치가 초기화되는 UX 이슈가 있습니다.
- 향후에는 CollectionView를 분리해서 관리하거나, 상태별 scroll position을 저장/복원하는 방식으로 사용자 경험을 개선할 수 있을 것이라 생각했습니다.

### 4. 테스트 코드 작성
- 기술과제 일정 안에서 우선순위를 고려하여 핵심 기능 구현에 집중하느라 테스트 코드 작성은 포함하지 못했습니다.
- UseCase 단위 테스트, Repository Mock 테스트, Reactor State 테스트 등 다양한 테스트코드를 작성해 프로젝트의 완성도를 높이고 싶다는 생각이 들었습니다.



------------------------------------------------------------------------

## 📬 Contact
- **Email:** vkcldhkd@gmail.com
- **GitHub:** https://github.com/vkcldhkd
- **LinkedIn:** https://www.linkedin.com/in/sung9

