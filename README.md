# WeatherApp-Clone
SideProject

## Standard iOS WeatherApp Clone Coding 시작일 ( 2020.12.03 )
<img src="https://user-images.githubusercontent.com/64323969/102778627-471bd200-43d6-11eb-8da4-1e136a1b7073.png" width="40%" height="40%">

### 이 사이드 프로젝트를 시작하게 된계기는 모각코 스터디 그룹에서 각자가 만들어보고 서로서로 비교하며 배우는 것이 목적이였습니다. 
- 일단 기본적인 화면구성과 유저인터랙션을 보고 어떻게 구성할지를 생각하였으며, 메인화면 구성이 너무 어려워 서브뷰를 먼저 구성하는걸로 시작하였습니다. 
- 앱의 데이터는 코어데이터에 보관하여 유저가 원하는 지점을 검색 ( google AutoCompletion ) 하고 데이터를 담는 것으로 하였습니다. 
- API는 openWeather에서 제공하는 oneCallAPI를 사용하였습니다. 데이터 요청은 위도와 경도를 제공하여 받았습니다. 


### 사용한 라이브러리
- GooglePlace
- Alamofire

### 앱의 데이터 흐름
- 앱 실행 -> 첫 실행시 저장된 현재위치가 있는지 검사 → 없으면 현재위치를 코어데이터에 추가, 있으면 현재위치로 덮어쓰기
  → 코어데이터에 저장된 위치정보 로드 → API 호출 → 받아온 데이터 셀에 맞게 가공 → 뿌려주기 
  → LocationList View 로 진입시 각 위치 업데이트 → 1시간 마다 UI업데이트
