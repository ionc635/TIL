# IntelliJ IDE Debug Mode

## Debugging 세팅

1. IntelliJ 우측 상단의 `Add Configuration…`을 클릭한다.

![image](https://user-images.githubusercontent.com/80724255/176466933-f03bbd90-f953-4249-b106-e45c2d5d6814.png)

2. `+`를 클릭하고 본인이 `debugging`할 환경을 설정한다. `NestJS` `Framework`에서는 `Node.js`를 선택한다. 

![image](https://user-images.githubusercontent.com/80724255/176467048-0c755c3f-db39-49a5-bfe2-a2d0a248d9e1.png)

3. `Name`과 `Node parameters` 내용을 채워준다. `Node interpreter`과 `Working directory`는 자동으로 채워진다. `Node parameters` 내용에는 해당 서버를 실행하는 로직이 구현된 경로를 명시한다.

![image](https://user-images.githubusercontent.com/80724255/176467113-0e462ab7-a364-476e-8200-5acde89ebbcb.png)

4. `Apply`를 눌러 적용한다. 

## Debugging 방법

1. 위에서 설정한 환경을 적용한다.

![image](https://user-images.githubusercontent.com/80724255/176467182-b1f212c1-b8c1-4d05-a3e4-22014e0abde3.png) 

2. 환경 설정이 완료되면 `Debugging`할 로직을 확인해 `Break Point`를 표시해야 한다. `Break Point`는 코드 창 좌측의 숫자와 로직 사이의 공간을 클릭하면 되는데, 빨간색 동그라미가 표시된 것으로 확인할 수 있다.

![image](https://user-images.githubusercontent.com/80724255/176467211-5aff4016-4772-497b-9b64-c45a59c51ec3.png)

3. `Break Point`를 표시했다면  우측 상단의 벌레 모양 버튼을 클릭하거나 `^D` 단축키를 눌러 `Debug`를 실행한다.

![image](https://user-images.githubusercontent.com/80724255/176467245-eb1eb7e4-68fb-4bf2-8925-433134bbb6ce.png)

4. 아래의 `Debug` 창을 통해 연결된 것을 확인하고, `Debugging`할 코드가 구현된 `API`를`Postman` 또는 `Client`을 통해 실행한다.

![image](https://user-images.githubusercontent.com/80724255/176467287-4f671351-3a1b-433d-942b-b1d13e8be549.png)

5. 코드 창에서는 `Break Point`부터 차례대로 코드를 확인할 수 있고, 아래 `Debug` 창에서 `req`, `res` 등의 값을 확인할 수 있다.

![image](https://user-images.githubusercontent.com/80724255/176467352-f4420a62-2e7a-4516-95d1-490203a87e10.png)

6. 아래 `Debug` 창을 확인해보면 `Step Over(F8)`, `Step Into(F7)`, `Force Step Into(option + shfit + F7)`, `Step Out(shift + F8)` 등의 기능이 존재하는데, 이 기능을 통해 구현된 코드를 자유롭게 확인할 수 있다. 

![image](https://user-images.githubusercontent.com/80724255/176467379-d6db2600-cd16-461b-80ba-093acb48c750.png)

- `Step Over`은 현재 `break`된 파일에서 다음 라인으로 이동
- `Step Into`는 `break`된 라인에서 실행되고 있는 내부 함수로 이동
- `Force Step Into`는 라이브러리 함수로 이동
- `Step Out`은 `break` 라인에서 호출한 곳으로 이동

7. `command + F2` 단축키 또는  `Debug` 모드를 종료할 수 있다.

![image](https://user-images.githubusercontent.com/80724255/176467467-ebd57e17-e3c0-441e-ae2a-8f1e6bfa8bdf.png)

## 유용한단축키

- `shift + command + F8`: View BreakPoints
