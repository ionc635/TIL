# fcm-node

FCM(Google's Firebase Cloud Messaging) Push 알람 기능을 위해 fcm-node 모듈을 사용했다. 먼저, 아래의 명령어로 패키지를 설치한다.

```
npm install fcm-node
yarn add fcm-node
```

[Npm](https://www.npmjs.com/package/fcm-node) 사이트에 기본적인 사용법이 정리되어 있다.

**사용법**

1. 앱의 Firebase 콘솔에서 서버 키를 생성하고, FCM 생성자에 전달한다.
2. 보낼 메시지를 만들고 send 함수를 호출한다.

```jsx
var FCM = require('fcm-node');
var serverKey = 'YOURSERVERKEYHERE'; //put your server key here
var fcm = new FCM(serverKey);

var message = { //this may vary according to the message type (single recipient, multicast, topic, et cetera)
  to: 'registration_token', 
  collapse_key: 'your_collapse_key',
        
  notification: {
    title: 'Title of your push notification', 
    body: 'Body of your push notification' 
  },
        
  data: {  //you can send only notification or only data(or include both)
    my_key: 'my value',
    my_another_key: 'my another value'
  }
};
    
fcm.send(message, function(err, response){
  if (err) {
    console.log("Something has gone wrong!");
  } else {
    console.log("Successfully sent with response: ", response);
  }
});
```

서버 키는 아래와 같이 불러올 수 있다.

```jsx
var serverKey = process.env.serverKey;
var serverKey = require('path/to/privatekey.json');
```

멀티 클라이언트를 구성하려면 아래와 같이 작성한다.

```jsx
const FCM = require('fcm-node')

let fcm1 = new FCM(KEY_1)
let fcm2 = new FCM(KEY_2)
```

NestJS에서는 어떻게 적용할 수 있는지 알아보자. 먼저 모듈을 작성한다.

```jsx
// fcm/fcm.module.ts

import { Module } from "@nestjs/common";
import { FcmService } from "./fcm.service";

@Module({
  providers: [FcmService],
  exports: [FcmService],
})
export class FcmModule {}
```

비즈니스 로직은 아래와 같이 작성한다.

```jsx
// fcm/fcm.service.ts

import { Injectable } from "@nestjs/common";
import * as FCM from "fcm-node";
import { Data } from "./fcm.interfaces";

@Injectable()
export class FcmService {
  private readonly serverKey;
  private readonly fcm;
  constructor() {
    this.serverKey = 'YOURSERVERKEYHERE';
    this.fcm = new FCM(this.serverKey);
  }

  private message(to: string, data: Data, collapse_key: string) {
    return {
      to,
      collapse_key,
      notification: {
        title: data.title,
        body: data.body,
      },
      data,
    };
  }

  public sendMessage(to: string, data: Data) {
    this.fcm.send(
      this.message(to, data, "collapse_key"),
      (err, res) => {
         if (err) {
           console.log("Something has gone wrong!");
         } else {
           console.log("Successfully sent with response: ", response);
         }
      },
    );
  }
```

```jsx
// fcm/fcm.interfaces.ts

export interface Data {
  title: string;
  body: string;
}
```
