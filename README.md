# WeatherApp-Clone
# Project Guidelines &middot; [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com) [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/your/your-project/blob/master/LICENSE)
> 애플의 기본 날씨앱을 클론코딩 하였습니다. 100% 똑같지는 않지만 처음으로 대단위(?) 작업을 한것으로 한달여에 걸쳐 작업하였습니다. 

![ezgif com-gif-maker (3)](https://user-images.githubusercontent.com/64323969/104320363-92cd2180-5525-11eb-8062-716790f6b8fb.gif)
![ezgif com-gif-maker (4)](https://user-images.githubusercontent.com/64323969/104320379-995b9900-5525-11eb-8d11-c1e76d4225f7.gif)
![ezgif com-gif-maker (5)](https://user-images.githubusercontent.com/64323969/104320382-99f42f80-5525-11eb-915b-c42e4b7672a1.gif)

## 기능설명
1. 사용자의 현재위치의 기상정보를 보여줍니다. 
2. 사용자가 원하는 지역을 검색하고 추가하여 저장할수 있습니다.
3. 섭씨 / 화씨를 선택할수 있습니다.
4. 사용자가 설정한 온도, 지역을 앱이 꺼지더라도 저장합니다.

## 설계 및 구현
### ViewController 구성
![스크린샷 2021-01-12 오후 11 10 04](https://user-images.githubusercontent.com/64323969/104324867-50a6de80-552b-11eb-8fd2-604832eda407.png)

## 날씨 모델과 View - MVVM
### WeatherViewController - WeatherViewModel
![스크린샷 2021-01-12 오후 11 37 42](https://user-images.githubusercontent.com/64323969/104328458-2ce59780-552f-11eb-93b0-e04dc1c71b67.png)
- ViewModel의 view관련 type에 Binder를 등록할 수 있도록 구현하였습니다
 - ㅁㄴㅇㄹ

## Installing / Getting started

A quick introduction of the minimal setup you need to get a hello world up &
running.

```shell
commands here
```

Here you should say what actually happens when you execute the code above.

## Developing

### Built With
List main libraries, frameworks used including versions (React, Angular etc...)

### Prerequisites
What is needed to set up the dev environment. For instance, global dependencies or any other tools. include download links.


### Setting up Dev

Here's a brief intro about what a developer must do in order to start developing
the project further:

```shell
git clone https://github.com/your/your-project.git
cd your-project/
packagemanager install
```

And state what happens step-by-step. If there is any virtual environment, local server or database feeder needed, explain here.

### Building

If your project needs some additional steps for the developer to build the
project after some code changes, state them here. for example:

```shell
./configure
make
make install
```

Here again you should state what actually happens when the code above gets
executed.

### Deploying / Publishing
give instructions on how to build and release a new version
In case there's some step you have to take that publishes this project to a
server, this is the right time to state it.

```shell
packagemanager deploy your-project -s server.com -u username -p password
```

And again you'd need to tell what the previous code actually does.

## Versioning

We can maybe use [SemVer](http://semver.org/) for versioning. For the versions available, see the [link to tags on this repository](/tags).


## Configuration

Here you should write what are all of the configurations a user can enter when using the project.

## Tests

Describe and show how to run the tests with code examples.
Explain what these tests test and why.

```shell
Give an example
```

## Style guide

Explain your code style and show how to check it.

## Api Reference

If the api is external, link to api documentation. If not describe your api including authentication methods as well as explaining all the endpoints with their required parameters.


## Database

Explaining what database (and version) has been used. Provide download links.
Documents your database design and schemas, relations etc... 

## Licensing

State what the license is and how to find the text version of the license.



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
