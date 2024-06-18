# 1. 개요
## 1-1) 아키텍처와 기술 스택
- Deployment Target : iOS 15.0
- Swift Version : Swift 5
- Design Pattern : MVC
- Cocoa Touch 
    - UIKit : UINavigation, UITapBar, UITableView의 주요 기능을 사용하여 화면 구성
    - CoreData : 기사 저장 기능 구현
- Libary(Cocoapods)
    - Toast_Swift : 토스트 및 화면 로딩 효과 구현
- API : News API(https://newsapi.org/)


<br>

## 1-2) 기능
### [1] 기사 목록
NewsAPI를 통해 받아온 기사 데이터를 사용하여 테이블뷰 형식으로 보여준다.<br>
<img src="https://velog.velcdn.com/images/22_gaeul/post/2e7bd9ad-6ac3-4d5b-a04f-254a2aff6fcc/image.gif" width="300" height="620">
<br>

### [2] 기사 검색
SearchBar에 사용자가 입력한 키워드로 기사를 검색하고, 검색된 결과를 보여준다.<br>
<img src="https://velog.velcdn.com/images/22_gaeul/post/46e579d1-a244-411d-97dc-c11c03c32882/image.gif" width="300" height="620">
<br>

### [3] 기사 보기
보고자 하는 기사를 선택하여 해당 기사 사이트로 이동한다.<br>
<img src="https://velog.velcdn.com/images/22_gaeul/post/fc3803a0-d0a3-428e-93ee-f53c6a493b88/image.gif" width="300" height="620">
<br>

### [4] 기사 저장
기사 목록 중 저장하고 싶은 기사를 왼쪽으로 스크롤하여 저장한다.<br>
<img src="https://velog.velcdn.com/images/22_gaeul/post/e642810f-249e-48bd-9825-697bff73268b/image.gif" width="300" height="620">
<br>

### [5] 저장한 기사 삭제
탭 바의 두번째 메뉴를 탭하면 저장한 기사 목록이 뜨고,
기사 저장 방법과 동일하게 삭제하고자 하는 기사를 왼쪽으로 스크롤하여 저장된 기사 목록에서 삭제한다.<br>
<img src="https://velog.velcdn.com/images/22_gaeul/post/3513b37c-253b-44d7-ba2f-f1c82b79918e/image.gif" width="300" height="620">
<br>


### [6] 추가 기능 - 다크 모드 지원
![](https://velog.velcdn.com/images/22_gaeul/post/b23d05e7-fdbd-47ad-a1f4-d77b4c099864/image.png)

<br>


# 2. 설계 및 구현
## 2-1) ViewController 구성
![](https://velog.velcdn.com/images/22_gaeul/post/7ae82d5c-da16-4b06-a4f2-92387330e666/image.png)

- `HomeViewController` : **NewsAPI를 통해 받아온 기사 데이터를 사용하여 테이블뷰 형식으로 보여주며**, 테이블뷰의 항목을 왼쪽으로 슬라이드하여 해당 **데이터를 CoreData에 저장**하거나 보고자하는 **기사를 선택하여 해당 기사를 보여주는** ViewController
- `SavedArticlesViewController` : **CoreData를 사용해 저장한 기사 데이터를 테이블뷰 형식으로 보여주며**, 테이블뷰의 항목을 왼쪽으로 슬라이드하여 **저장된 기사 목록에서 해당 항목의 기사를 삭제**할 수 있는 ViewController

<br>

## 2-2) MVC Pattern 적용
### [1] 기사 목록
<img src="https://velog.velcdn.com/images/22_gaeul/post/ea4ebf71-0ef2-410c-919e-504685c38ec3/image.png" width="900" height="650">

- `ArticleData` :  API로부터 데이터를 받아올 수 있는 Codable을 채택한 Model
- `NetworkManager` : API로부터 데이터를 받아 가공하여 HomeViewController로 전달해주는 역할
- `ArticleTableViewCell` : 전달받은 가공데이터를 재사용가능한 UITableViewCell을 사용하여 HomeViewController의 tableView에 리스트 형태로 보여주는 역할
- `HomeViewController` : HomeViewController에 진입할 때 마다 기사 목록 리로드
<br>

### [2] 기사 검색
<img src="https://velog.velcdn.com/images/22_gaeul/post/5cd805d6-eee0-49e0-865d-7699bc8d84b5/image.png" width="900" height="650">

- `ArticleData` : API로부터 데이터를 받아올 수 있는 Codable을 채택한 Model
- `NetworkManager` : SearchBar에 사용자가 검색어를 입력하면, 해당 검색어를 포함한 API주소로부터 데이터를 받아 가공하여 HomeViewController로 전달해주는 역할
- `ArticleTableViewCell` : 전달받은 가공데이터를 재사용가능한 UITableViewCell을 사용하여 HomeViewController의 tableView에 리스트 형태로 보여주는 역할
- `HomeViewController` : NetworkManager를 통해 사용자가 입력한 검색어가 포함된 기사목록을 받으면, 업데이트된 기사 목록으로 tableView 리로드
<br>

### [3] 기사 저장
<img src="https://velog.velcdn.com/images/22_gaeul/post/e8d3db66-ecaa-4a45-8e1b-827728d737c7/image.png" width="900" height="650">

- `ArticleData` : API로부터 데이터를 받아올 수 있는 Codable을 채택한 Model
- `ArticleModel` : `ArticleData` 타입으로 이루어진 기사 데이터를 CoreData에서 사용하기 용이하도록 생성된 model, `ArticleModel`은 CoreData를 통해서만 읽기, 생성, 삭제가 가능
- `CoredataManager` : 사용자가 저장하고자 하는 기사 데이터를 ArticleModel 타입으로 CoreData에 저장
<br>

### [4] 저장한 기사 삭제
<img src="https://velog.velcdn.com/images/22_gaeul/post/8f5bc50f-afd4-4a58-850c-6501998e8971/image.png" width="900" height="650">

- `ArticleModel` : `ArticleData` 타입으로 이루어진 기사 데이터를 CoreData에서 사용하기 용이하도록 생성된 model, `ArticleModel`은 CoreData를 통해서만 읽기, 생성, 삭제가 가능
- `CoredataManager` : 사용자가 삭제하고자 하는 기사 데이터를 CoreData 저장소에서 찾고 해당 데이터 삭제
- `SavedArticlesViewController` : CoredataManager를 통해 사용자가 삭제하고자 하는 기사를 삭제하면, 업데이트된 CoreData 저장소의 기사 목록으로 tableView 리로드
<br>



# 3. 관련 학습 내용
## 3-1) MVC Pattern
## 3-2) CoreData
## 3-3) Cocoapods

<br>

# 4. 개발 시 참고한 사항
테이블뷰 항목 슬라이드 메뉴 https://gonslab.tistory.com/45<br>
항목 선택 시 외부 브라우저 https://hongssup.tistory.com/383
