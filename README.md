# 🌞 WeatherApp-Clone
# Project Guidelines &middot; [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com) [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/your/your-project/blob/master/LICENSE)
> 애플의 기본 날씨앱을 클론코딩 하였습니다. 100% 똑같지는 않지만 처음으로 대단위(?) 작업을 한것으로 한달여에 걸쳐 작업하였습니다. 

![ezgif com-gif-maker (3)](https://user-images.githubusercontent.com/64323969/104320363-92cd2180-5525-11eb-8062-716790f6b8fb.gif)
![ezgif com-gif-maker (4)](https://user-images.githubusercontent.com/64323969/104320379-995b9900-5525-11eb-8d11-c1e76d4225f7.gif)
![ezgif com-gif-maker (5)](https://user-images.githubusercontent.com/64323969/104320382-99f42f80-5525-11eb-915b-c42e4b7672a1.gif)

## 1️⃣기능설명
1. 사용자의 현재위치의 기상정보를 보여줍니다. 
2. 사용자가 원하는 지역을 검색하고 추가하여 저장할수 있습니다.
3. 섭씨 / 화씨를 선택할수 있습니다.
4. 사용자가 설정한 온도, 지역을 앱이 꺼지더라도 저장합니다.<br/>
<br/>

## 2️⃣설계 및 구현
### ViewController 구성
<img src="https://user-images.githubusercontent.com/64323969/104324867-50a6de80-552b-11eb-8fd2-604832eda407.png" width="60%" height="60%">
<img src="https://user-images.githubusercontent.com/64323969/104421233-6e715380-55be-11eb-8521-d6c45b2881fa.png" width="60%" height="60%">
- 설계정리한 블로그입니다 : https://memohg.tistory.com/117
<br/>

## 3️⃣날씨 모델과 View - MVVM
### WeatherViewController - WeatherViewModel
![스크린샷 2021-01-12 오후 11 37 42](https://user-images.githubusercontent.com/64323969/104328458-2ce59780-552f-11eb-93b0-e04dc1c71b67.png)
- ViewModel의 view관련 Type에 Binder를 등록할수 있도록 작성하였습니다.
    - 바인더를 준것은 각각의 개별 타입에 준것이 아니라 기상정보가 한번 변하면 모든 값이 변하기 때문에 가장 마지막에 데이터가 담기는 인스턴스에 바인더를 걸고 값이 변하면 reload합니다
    - 뷰모델은 만들어지는 ViewController의 Location에 의해 데이터값이 전달되어 API요청을 통해 데이터를 각 셀에 맞는 데이터를 가지고 있습니다.
    - 페이지뷰에 들어가는 뷰컨트롤러의 뷰는 TableView를 기반으로 작업했기때문에 데이터가 바뀌는 경우는 TableView.reload을 한번만 호출합니다.
<br/>

### 4️⃣View 관련 역할
|Class / Struct|역할|
|---|---|
|MainPageViewController| LocationGeocoder를 이용해서 현재위치를 MainTableViewController에 전달하여 첫페이지에 보여줍니다.|
|MainTableViewController| MainPageViewController에서 받은 Location을 뷰모델에 넘겨서 데이터를 받아오고 UI를 구성합니다.|
|LocationListViewController| 시간, 온도, 지역이름을 나타내며, 온도단위 변경, 웹으로 이동이 가능합니다.|
|SearchViewController| Google Place Autocompletion을 이용하여 지역을 검색하고 location형태로 Coredata에 저장합니다.|
|WeatherViewModel| WeatherAPI서비스를 이용하여 현재 날씨정보를 JSON형태로 받아옵니다. |
|WeatherListViewModel| PageView와 SearchView를 통해 CoreData에 저장된 location 정보를 Api에 요청해서 ListViewCell 타입에 맞게 가공합니다|
|Binder| 데이터 변화를 감지하고 업데이트 처리|
<br/>

### 5️⃣Utilities
|Class / Struct|역할|
|---|---|
|LocationGeocoder|사용자의 현재위치를 가져오는 역할입니다. 앱 시작시 가장먼저 실행됩니다. |
|ImageFileManager|API요청시 받아오는 아이콘의 이름과 매치되는 데이터가 없을시 아이콘의 이름을 이용해 Alamofire download를 이용해  받아 FileManager에 저장합니다|
|WeatherCellDataMaker| ViewModel이 API를 통해 요청한 JSON데이터를 각 셀에 맞게 데이터를 가공하는 역할입니다. |
|DateConverter|UTC, Unix타입 Time데이터를 변환해주는 역할입니다. |
|WeatherAPI| Alamofire를 이용해 location정보를 가지고 API서버에 데이터를 요청합니다.|
<br/>

### 6️⃣Weather Model Hierarchy
![스크린샷 2021-01-13 오후 3 34 03](https://user-images.githubusercontent.com/64323969/104415357-3a456500-55b5-11eb-976b-4622e5089594.png)
### Location

- `CLLocationManager` 의 데이터를 받기위한 구조체입니다
- 페이지 컨트롤러의 인스턴스에 바로 저장되며 페이지 Index를 카운트하고 뷰컨트롤러의 뷰모델을 생성할때 이용됩니다.
<br/>

### CoreData
- 내용정리 블로그 : https://memohg.tistory.com/118
- DataLocation
    - User가 저장한 위치정보를 담고있으며 앱이 구동될때 페이지 컨트롤러에 정보를 넘겨줍니다.
- WeatherListCell
    - WeatherListView를 나타내기위한 정보를 가지고있습니다.
<br/>

## 7️⃣클래스별 구성특징

### Persistense Data 사용자 설정저장 - CoreData
- 사용자가 원하는 데이터를 앱을 종료하고도 보존하기 위해 사용자의 Interaction에 맞추어 저장, 불러오기, 삭제, 조회를 사용합니다. 
- 중복되는 데이터의 저장을 피하기 위해서 먼저 값이 똑같은 데이터가 있는지 여부를 판단후 업데이트 하거나 저장합니다.
- 사실 CoreData말고 UserDefault가 좀더 적합한것을 알았지만 CoreData를 한번 써보고 싶어서 사용하게 되었습니다. 
<br/>

### ViewController Data Passing By Delegate
- 뷰들간의 데이터이동은 Prepare를 사용해 봤었는데 이번에는 Delegate라는 방법이 있다는 것을 알게되서 사용해보게 되었습니다. 사실 이방법이 좀더 간단하고 좋았던것 같습니다.
- Delegate패턴은 Protocol을 사용해서 원하는 데이터를 메서드 형식으로 때에 맞추어 발동시키는 좋은 방법입니다. 그동안 프로토콜은 마냥 유저의 입력을 받을때 호출되도록 애플이 구상한 좋은 타입!<br/>
  이라고만 생각했는데 이번기회에 제대로 배웠습니다.
- 사실 이 클론앱에는 프로토콜이 5개가 있었는데 오류를 해결하는 과정에서 하나는 불필요하게 되어 삭제하게 되었습니다<br/>

|Protocol|역할|
|---|---|
|LocationListViewDelegate| - 리스트 뷰에서 유저가 선택하는 셀의 인덱스와 동적인 배경화면을 위해 클릭된 셀의 배경화면을 전달합니다<br/> - 유저가 저장한 새로운 위치를 코어데이터와 페이지컨트롤러에 넘겨줍니다. <br/> - 유저가 셀을 삭제하면 삭제한 인덱스를 전달합니다|
|WeatherListCellDelegate|메인뷰의 뷰모델이 업데이트되면 업데이트한 리스트셀정보를 코어데이터와 리스트뷰모델에 넘겨주는 역할을 합니다 |
|LocationManagerDelegate|현재위치를 성공적으로 가져오면 현재위치정보를 업데이트 합니다|
|SearchViewDelegate|유저가 선택한 위치정보를 저장합니다|
<br/>

### CurrentLocation with CLLocationManager

1. `CLLocationManager` 객체 생성
2. location 데이터의 정확도 설정 : `desiredAccuracy` property 설정
3. 사용자에게 위치정보 사용 허가 받기 : `requestWhenInUseAuthorization()` method
4. 위치 요청이 가능한 허가 상태 `CLAuthorizationStatus` : `.authorizedWhenInUse` / `.authorizedAlways`
5. 위치 요청: `requestLocation()`
    - 해당 method는 즉각 return 한다
    - 위치 값을 얻은 후, delegate 의 `didUpdateLocation` method 를 호출한다
6. Delegate method - `didUpdateLocation`
<br/>

### 날씨 정보 API로 받기 & 파싱하기
- 사용한 API 주소 입니다 [One Call API](https://openweathermap.org/api/one-call-api)<br/>

|<img src="https://user-images.githubusercontent.com/64323969/104342340-1266ea80-553e-11eb-88ad-c83715cd9461.png" width="60%" height="60%">|<img src="https://user-images.githubusercontent.com/64323969/104342377-1c88e900-553e-11eb-8773-1c7c7ca5e449.png" width="60%" height="60%">|<img src="https://user-images.githubusercontent.com/64323969/104342405-23aff700-553e-11eb-8757-34a5444d1133.png" width="60%" height="60%">|
|--|--|--|

- 데이터는 위와같은 형식으로 크게 3가지로 나뉘어 들어오게 됩니다 현재날씨, 시간별날씨, 요일별날씨
- Alamofire request, Codable, Codingkey를 이용해서 데이터를 파싱해서 사용하였습니다.
<br/>

### 장소검색 Google Place AutoCompletion
<img src="https://user-images.githubusercontent.com/64323969/104423784-e2f9c180-55c1-11eb-9206-61c38665b03b.png" width="30%" height="30%">
- 내용정리 블로그 : https://memohg.tistory.com/120
<br/>

### Unix data time UTC -> 각 나라별 시간으로 변환
- 내용정리 블로그 : https://memohg.tistory.com/115
<br/>

### 온도 단위 설정대로 바꾸어서 보여주기 - Singleton
- 모든 온도가 버튼의 클릭에 의해 변하기 때문에 싱글톤을 활용하면 쉽게 변화 시킬수 있었습니다.
- true & false 값을 저장해 true이면 celcius , false일경우 fahrenheit 표시하도록 했습니다. 
<br/>

### Extension
|Extension|역할|
|--|--|
|StringInterpolation|- 디테일셀에 표시되는 단위명을 보간을 이용해서 자동으로 뒤에 단위가 붙도록 하였습니다|
|Date|- UTC타임을 TimeIntervalsince1970을 통해서 Date값을 얻고 Timezone_Offset을 이용해서 각 지역에 맞는 시간을 구할수 있었습니다. |
|UIImageView|처음 이미지를 다운로드하게되면 이미지가 나오지 않아 Delegate를 이용해서 처리했었는데 MVVM아키텍처에 맞지 않는 방법이라고 생각해 방법을 찾아보다가 UIImageView에 익스텐션을 이용해서 파일매니저에 저장된 이미지가 있으면 가져오는 방식으로 코드를 수정했습니다. 보통 직접적으로 url을 연결해서 사용하는 방식을 보았는데 저는 FileManager를 이용해서 다운받아 두어서 이렇게 해결하였습니다.|
<br/>

### 사용한 OpenSource
- Alamofire
- Google Place SDK
<br/>

### 참고 블로그
- Alamofire: https://duwjdtn11.tistory.com/557
- CoreData: https://ios-development.tistory.com/93
- UI구성: https://www.youtube.com/watch?v=o2PG_x4-mjI 
- API관련: https://hcn1519.github.io/articles/2017-09/swift_escaping_closure
<br/>
---
## 날씨앱 클론코딩을 시작하게된 계기😎

## Standard iOS WeatherApp Clone Coding 시작일 ( 2020.12.03 )
<img src="https://user-images.githubusercontent.com/64323969/102778627-471bd200-43d6-11eb-8da4-1e136a1b7073.png" width="40%" height="40%">

### 이 사이드 프로젝트를 시작하게 된계기는 모각코 스터디 그룹에서 각자가 만들어보고 서로서로 비교하며 배우는 것이 목적이였습니다. 
- 일단 기본적인 화면구성과 유저인터랙션을 보고 어떻게 구성할지를 생각하였으며, 메인화면 구성이 너무 어려워 서브뷰를 먼저 구성하는걸로 시작하였습니다. 
- 앱의 데이터는 코어데이터에 보관하여 유저가 원하는 지점을 검색 ( google AutoCompletion ) 하고 데이터를 담는 것으로 하였습니다. 
- API는 openWeather에서 제공하는 oneCallAPI를 사용하였습니다. 데이터 요청은 위도와 경도를 제공하여 받았습니다. 

### 앱의 데이터 흐름
- 앱 실행 -> 첫 실행시 저장된 현재위치가 있는지 검사 → 없으면 현재위치를 코어데이터에 추가, 있으면 현재위치로 덮어쓰기
  → 코어데이터에 저장된 위치정보 로드 → API 호출 → 받아온 데이터 셀에 맞게 가공 → 뿌려주기 
  → LocationList View 로 진입시 각 위치 업데이트 → 1시간 마다 UI업데이트
