# 📱 UnsplashCloneApp -- iOS Clean Architecture Sample

이 프로젝트는 **UnsplashCloneApp**을 기반으로,**RxSwift + ReactorKit**을 중심으로 구성된 단방향 데이터 흐름과 **Clean Architecture** 구조로 설계하였습니다.

------------------------------------------------------------------------

##📌 주요 기능
- 검색어 기반 Unsplash 이미지 검색
- Infinite Scroll 이미지 리스트 페이징
- CoreData기반 즐겨찾기(Bookmark) 저장
- 이미지 상세 화면 및 원본 이미지 로딩

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
- Codextended
- ReusableKit
- RxKingfisher
- Then
- SnapKit

------------------------------------------------------------------------

## 🎯 주요 목표

### ✔ 단방향 상태 관리의 명확한 유지
ReactorKit을 활용하여 View → Action → Mutation → State 흐름을 유지하고, 비즈니스 로직이 ViewController에 혼재하지 않도록 분리했습니다.

### ✔ 클린아키텍처 적용
계층 간 의존성을 명확하게 정의하고자 노력했습니다.

------------------------------------------------------------------------

## 🔧 프로젝트 사용 의존성
- Alamofire
- Codextended
- ReactorKit
- ReusableKit
- RxDataSources
- RxKingfisher
- RxSwift
- SnapKit
- Then

------------------------------------------------------------------------

## 🛠 향후 개선하고 싶은 점
### 1️⃣ CoreData 레이어도 Clean Architecture로 분리
- 다른 부분들을 신경쓰다보니, Coredata 부분은 제가 예전에 사용하던 방식 그대로 사용한것이 아쉬웠습니다. 클린아키텍처로 조금 더 관심사 분리를 통해 작성했으면 더 좋겠다고 생각이 들었습니다.

### 2️⃣ UICollectionView를 인스타그램처럼 확장 가능한 형태로 개선
- Pinterest/Instagram 스타일의 레이아웃 지원하여 상세페이지에서 스크롤로 다음 아이템을 쉽게 볼 수 있다거나, 쉽게 북마크 할 수 있는 기능을 추가하면 더 좋을 것 같다고 생각 들었습니다.

### 3️⃣ 테스트 코드 작성
- 기술과제 일정 안에서 우선순위를 고려하여 핵심 기능 구현에 집중하느라 테스트 코드 작성은 포함하지 못했습니다.
- UseCase 단위 테스트, Repository Mock 테스트, Reactor State 테스트 등 다양한 테스트코드를 작성해 프로젝트의 완성도를 높이고 싶다는 생각이 들었습니다.

------------------------------------------------------------------------

## 📬 Contact
- **Email:** vkcldhkd@gmail.com
- **GitHub:** https://github.com/vkcldhkd
- **LinkedIn:** https://www.linkedin.com/in/sung9

