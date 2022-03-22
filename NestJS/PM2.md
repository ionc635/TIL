# PM2

## `Node.js`의 프로세스 매니저 PM2

`Node.js`는 기본적으로 싱글 스레드를 지원한다. `Node.js` 애플리케이션은 단일 CPU 코어에서 실행된다. 즉, `CPU`의 멀티코어 시스템은 사용할 수 없다. 모든 코어를 사용해 최대 성능을 내지 못하고 오직 한 개의 `Core`만을 사용한다면 주어진 자원을 제대로 활용하지 못하는 것이다. `Node.js`는 이런 문제를 해결하기 위해 클러스터(`Cluster`) 모듈을 통해 단일 프로세스를 멀티 프로세스로 늘릴 수 있는 방법을 제공한다.

애플리케이션을 실행하면 처음에는 마스터 프로세스만 생성된다. 이때 `CPU` 개수만큼 워커 프로세스를 생성하고 마스터 프로세스와 워커 프로세스가 각각 수행해야 할 일들을 정리해서 구현할 수 있다. 예를 들어 워커 프로세스가 생성 됐을 때 이벤트가 마스터 프로세스로 전달되면 어떻게 처리할지, 워커 프로세스가 메모리 제한에 도달하거나 예상치 못한 오류로 종료되면 어떻게 처리할지, 애플리케이션의 변경을 반영하기 위해 어떤 식으로 재시작할지 등을 고민해야 한다. 이 문제를 간편히 해결할 수 있는 것이 바로 [PM2](https://pm2.io/)라는 `Node.js`의 프로세스 매니저이다.

## PM2 설치

PM2는 아래와 같이 `Node.js`의 패키지 매니저(Package Manager)인 [NPM](https://www.npmjs.com/)으로 쉽게 설치할 수 있다.

```
npm install -g pm2@latest
```

## PM2 명령어

`NestJS`에서 `PM2` 에서는 아래와 같은 명령어를 사용한다.

```
pm2 start {app_name} // 실행
pm2 reload {app_name} // 
pm2 stop {app_name} // 중지
pm2 delete {app_name} // 삭제
pm2 restart {app_name} // 재시작
pm2 logs // 로그 확인
pm2 list // 서버 상태 확인
pm2 kill // 종료
pm2 monit // 메모리/cpu 사용량 확인

파일 이름 대신 all을 넣어도 정상 작동한다.
nest.js에서는 ./dist/main.js를 넣어야 한다.
```

## PM2 사용 방법

기본적으로는 위에서 확인한 `pm2 start {파일명}` 명령어로 PM2를 실행할 수 있다. 아무런 옵션 없이 실행하면 `PM2`의 기본 모드인 포크(`fork`) 모드로 실행된다.

하지만 위에서 본 것처럼 모든 `CPU`를 사용하기 위해서는 클러스터 모드(`Cluster`)로 실행해야 하는데, 가장 먼저 설정 파일을 생성해야 한다. 자료를 찾아보면 보통 `ecosystem.config.js` 이름으로 생성한다고 하는데, 기본 틀은 아래의 코드와 같다.

```jsx
// ecosystem.config.js

module.exports = {
  apps: [{
  name: 'app',
  script: './dist/main.js',
  instances: 0, // 0은 CPU 코어 수 만큼 프로세스 생성
  exec_mode: ‘cluster’ // 클러스터 모드로 실행하겠다는 의미
  }]
}
```

`pm2 start ecosystem.config.js` 명령어로 클러스터 모드를 실행할 수 있다. `CPU` 코어 수 만큼 프로세스가 생성되어 최대 코어 수 만큼 요청을 처리할 수 있게 된다. 이를 통해 `Node.js`가 하나의 `CPU`만 사용해 주어진 자원을 최대한 활용하지 못하는 문제를 해결할 수있다.

무조건 `ecosystem.config.js`로 생성할 필요는 없다. 아래와 같이 `json` 파일로 생성할 수 있으며, 내부 구성은 약간 달라진다. `json` 파일 내에 있는 여타 `option`은 아래에서 추가적으로 설명하고자 한다.

```json
// pm2.json

{
  "apps": [
    {
      "script": "./dist/main.js",
      "instances": "1",
      "exec_mode": "cluster",
      "name": "primary",
      "env_production": {
        "name": "prod-primary",
        "PORT": 3000,
        "NODE_ENV": "production"
      },
      "wait_ready": true,
      "kill_timeout": 10000,
      "listen_timeout": 50000
    },
    {
      "script": "./dist/main.js",
      "instances": "-1",
      "exec_mode": "cluster",
      "name": "replica",
      "env_production": {
        "name": "prod-replica",
        "PORT": 3000,
        "NODE_ENV": "production"
      },
      "wait_ready": true,
      "kill_timeout": 10000,
      "listen_timeout": 50000
    }
  ]
}
```

`pm2 start pm2.json` 으로 실행하게 되면 아래와 같은 화면을 볼 수 있다.

![PM2 list]](https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F713dd8b8-265c-4dc0-ae56-0d15dc356358%2FUntitled.png?table=block&id=07557881-b61a-4582-a11e-7499bb7f2eb8&spaceId=16f39aaf-0317-4c98-9def-554c19109c98&width=2000&userId=d99aa862-99f3-418c-9da1-b86737bc5ec8&cache=v2)

## PM2 log 확인

```
cd ~
cd .pm2
cd logs
tail -f *
```

터미널에서 위 명령어를 순서대로 입력하면 `PM2` `log`를 확인할 수 있다.

![PM2 log](https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F1ae60733-5509-4754-aea6-7e95850dd34b%2FUntitled.png?table=block&id=ecf188fd-b9bc-459d-b774-ba454c224944&spaceId=16f39aaf-0317-4c98-9def-554c19109c98&width=2000&userId=d99aa862-99f3-418c-9da1-b86737bc5ec8&cache=v2)

## PM2 무중단 서비스 운영

서비스는 오픈 이후에도 여러 상황에 따라 지속적으로 변경된다. 새로운 기능 추가와 버그 수정 등 서비스에 반영하기 위해서는 재배포해야 한다. 배포가 완료된 후에는 변경 사항을 반영하기 위해 기존 프로세스를 재시작해야 한다. 이때, `reload` 명령어를 활용하면 프로세스를 재시작할 수 있다. 하지만 무중단 서비스를 유지하려면 몇 가지 주의해야 할 사항이 있다.

**프로세스 재시작 과정**

![프로세스 재시작 과정](https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Fce994dd7-9741-49b2-97ad-200be464ede9%2FUntitled.png?table=block&id=e4d6921c-87aa-4d33-a6c9-d9dc24950e6d&spaceId=16f39aaf-0317-4c98-9def-554c19109c98&width=2000&userId=d99aa862-99f3-418c-9da1-b86737bc5ec8&cache=v2)

현재 프로세스 8개가 실행되고 있다고 가정해보자. 이 상태에서 `pm2 reload` 명령어를 실행하면 PM2는 기존 0번 프로세스를 Old_0 프로세스로 옮겨두고 새로운 0번 프로세스를 만든다. 새 0번 프로세스가 처리할 준비가 되면 마스터 프로세스에게 `ready` 이벤트를 보내고, 마스터 프로세스는 더 이상 필요없어진 Old_0 프로세스(기존 0번 프로세스)에게 `SIGINT` 시그널을 보내고 프로세스가 종료되기를 기다린다. 만약 SIGINT 시그널을 보내고 난 후 일정 시간(`1600ms`)이 지났는데도 종료되지 않는다면, `SIGKILL` 시그널을 보내 프로세스를 강제로 종료한다. 이 과정을 총 프로세스 개수만큼 반복하면 모든 프로세스의 재시작이 완료된다.

이 과정에서 서비스가 중단되는 상황이 있는데, 크게 2가지 경우로 살펴볼 수 있다.

1. **새로 만들어진 프로세스가 준비되지 않았는데 `ready` 이벤트를 보내는 경우**

아래 그림과 같이 과정 `(2) Spawn new app` 과정에서 프로세스를 생성한 뒤 과정(3)에서 앱 구동이 완료되기도 전에 마스터 프로세스에게 `ready` 이벤트를 보낸다면, 마스터 프로세스는 새로운 프로세스가 요청받을 준비가 완료됐다고 판단한다. 이에 기존 프로세스는 더 이상 필요 없다고 판단하고 `SIGINT` 시그널을 보내 프로세스에게 곧 종료될 것을 알린다. 여기서 만약 `SIGINT` 시그널을 보내고 일정시간(`1600ms`)이 지났는데도 프로세스가 살아있다면 이번엔 `SIGKILL` 시그널을 보내 프로세스를 강제 종료한다. 

`App`을 실행했을 때, 매우 짧은 시간에 초기화 작업이 진행되고 요청을 받을 수 있는 준비가 된다면 크게 문제되지 않을 수 있다. 하지만 (2)번 과정에서 새로운 프로세스를 생성하고 요청받을 준비를 하는데까지 일정시간(`1600ms`) 이상 걸리게 된다면 기존 프로세스는 이미 종료된 상태에서 새로운 프로세스는 사용자 요청이 유입돼도 처리할 수 없는 상황이 되어 버린다. 즉 서비스 중단이 발생하게 되는 것이다.

![무중단 서비스 과정1](https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F5e37347a-5b7c-4534-950c-366351d14442%2FUntitled.png?table=block&id=15a11de4-05f9-4648-b5e6-990bbab89c8b&spaceId=16f39aaf-0317-4c98-9def-554c19109c98&width=2000&userId=d99aa862-99f3-418c-9da1-b86737bc5ec8&cache=v2)

이 문제를 해결하기 위해서는 프로세스가 수행되는 즉시 `ready` 이벤트를 보내지 않고, 요청 받을 준비가 완료된 시점에 `ready` 이벤트를 보내도록 처리해야 한다. 또한 마스터 프로세스가 `ready` 이벤트를 언제까지 기다리게 할 것인지 설정 파일에 명시해야 한다. 

`wait_ready`옵션을 `true`로 설정하면 마스터 프로세스는 `ready` 이벤트를 기다린다. `listen_timeout` 옵션은 `ready` 이벤트를 기다릴 시간값(ms)을 의미한다. `app.listen`이 완료되면 실행되는 콜백(`Callback`) 함수에 마스터 프로세스로 `ready` 이벤트를 보내도록 할 수 있다.

```jsx
module.exports = {
  apps: [{
  name: 'app',
  script: './dist/main.js',
  instances: 0,
  exec_mode: ‘cluster’,
  wait_ready: true,
  listen_timeout: 50000
  }]
}
```

```jsx
// main.ts

app.listen(port, () => {
  if (process.send) {
    console.log('send');
    process.send('ready');
  }
});
```

아래는 `ready` 이벤트 설정 변경 후의 모습이다.

![무중단 서비스 과정2](https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F0e9d5a28-0e24-4b13-bc1c-93d292ffa8ee%2FUntitled.png?table=block&id=69145292-5912-4817-a792-e808745f170f&spaceId=16f39aaf-0317-4c98-9def-554c19109c98&width=2000&userId=d99aa862-99f3-418c-9da1-b86737bc5ec8&cache=v2)

1. **클라이언트 요청을 처리하는 도중에 프로세스가 죽어버리는 경우**

`reload` 명령어를 실행할 때, 기존 0번 프로세스인 Old_0 프로세스는 종료되기 전까지 계속해서 사용자 요청을 받는다. 그런데 만약 `SIGINT` 시그널이 전달된 상태에서 사용자 요청을 받았고, 그 요청을 처리하는 데 `5000ms`가 걸린다고 가정해보자. SIGINT 시그널을 받은 뒤 `1600ms` 이후에도 종료되지 않는다면 `SIGKILL` 시그널을 받고 강제 종료된다. 따라서 `5000ms`가 걸리는 사용자 요청을 처리하는 도중 `SIGKILL` 시그널을 받고 사용자에게 응답을 보내주지 못한 채 종료될 것이고, 프로세스가 강제 종료되었기 때문에 클라이언트와의 연결은 끊어지게 된다. 이 경우에 서비스는 중단된다.

![무중단 서비스 과정3](https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F8c06dbec-408e-4936-a78a-6858609c8e61%2FUntitled.png?table=block&id=a1d76ba5-d8c2-40f1-bb20-3e3869254b24&spaceId=16f39aaf-0317-4c98-9def-554c19109c98&width=2000&userId=d99aa862-99f3-418c-9da1-b86737bc5ec8&cache=v2)

이 문제를 해결하기 위해 `SIGINT` 시그널을 리스닝(`listening`)한다. 해당 시그널이 전달되면 `app.close` 명령어로 프로세스가 새로운 요청을 받는 것을 거절하고 기존 연결은 유지한다. 사용자 요청을 처리하기에 충분한 시간을 `kill_timeout`에 설정하고, 기존에 유지되고 있던 연결이 종료되면 프로세스가 종료되도록 처리한다. `kill_timeout` 옵션을 `10000`으로 설정하면 `SIGINT` 시그널을 보낸 후 프로세스가 종료되지 않았을 때 `SIGKILL` 시그널을 보내기까지 대기 시간을 1.6초에서 10초로 변경할 수 있다. 새로 추가된 코드는 해당 프로세스에 `SIGINT` 시그널이 전달되면, 새로운 요청을 더 이상 받지 않고 연결되어 있는 요청이 완료된 후 해당 프로세스를 강제로 종료하도록 처리할 수 있다.

```jsx
module.exports = {
  apps: [{
  name: 'app',
  script: './dist.main.js',
  instances: 0,
  exec_mode: ‘cluster’,
  wait_ready: true,
  listen_timeout: 50000,
  kill_timeout: 10000
  }]
}
```

```jsx
// main.ts

app.listen(port, () => {
  if (process.send) {
    process.send('ready');
  }
});

process.on('SIGINT', () => {
  app.close();
  process.exit(0);
});
```

## 참고

[PM2 공식 홈페이지](https://pm2.keymetrics.io/docs/usage/quick-start/)

[PM2를 이용하기 전 학습(클러스터, 모니터링)](https://itmore.tistory.com/entry/PM2%EB%A5%BC-%EC%9D%B4%EC%9A%A9%ED%95%98%EA%B8%B0-%EC%A0%84-%ED%95%99%EC%8A%B5%ED%81%B4%EB%9F%AC%EC%8A%A4%ED%84%B0-%EB%AA%A8%EB%8B%88%ED%84%B0%EB%A7%81)

[PM2를 활용한 Node.js 무중단 서비스하기](https://engineering.linecorp.com/ko/blog/pm2-nodejs/)