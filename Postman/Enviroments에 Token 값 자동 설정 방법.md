# Enviroments에 Token 값 자동 설정 방법

### 1. Eviroments의 VARIABLE에 변수명 설정

![image1](https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F389b131c-22c0-404d-87dd-2a8c2389d3dc%2FUntitled.png?table=block&id=f5dde576-c227-4369-8165-4e9230f20ebc&spaceId=16f39aaf-0317-4c98-9def-554c19109c98&width=2000&userId=d99aa862-99f3-418c-9da1-b86737bc5ec8&cache=v2)

app-token으로 변수명을 설정했다.

### 2. Signin 또는 Token 발급 로직의 Tests에 아래의 코드 작성

![image2](https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Ff58639da-635d-4f53-91eb-5b956101dc3e%2FUntitled.png?table=block&id=90ce90e4-ae84-42ed-92b4-4d97e29c465a&spaceId=16f39aaf-0317-4c98-9def-554c19109c98&width=2000&userId=d99aa862-99f3-418c-9da1-b86737bc5ec8&cache=v2)

1번째 줄 코드로 responseBody를 parsing해서 response에 선언해주고, 2번째 줄 코드로 1번에서 설정한 설정한 app-token 변수에 현재 출력된 token 값을 넣어준다.

![image3](https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Fbaed354c-85c9-4f9c-b172-c0c54fb82a49%2FUntitled.png?table=block&id=5710bd4c-da14-4b48-893a-14fb301f631a&spaceId=16f39aaf-0317-4c98-9def-554c19109c98&width=2000&userId=d99aa862-99f3-418c-9da1-b86737bc5ec8&cache=v2)

Send 버튼을 눌렀을 때, 위와 같이 결과값이 나오고

![image4](https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F965939ea-b09a-424f-a6d8-c956b7142b89%2FUntitled.png?table=block&id=186e1edc-9589-48d6-8d51-deac565e5059&spaceId=16f39aaf-0317-4c98-9def-554c19109c98&width=2000&userId=d99aa862-99f3-418c-9da1-b86737bc5ec8&cache=v2)

Enviroments에 들어가면 app-token 변수의 CURRENT VALUE로 Token 값이 삽입된 것을 확인할 수 있다.

### 3. Token이 필요한 API에 변수명 삽입

![image5](https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Ff0dc25f7-10d1-424a-83cd-578ab3219bbc%2FUntitled.png?table=block&id=5d3eaced-03be-4758-9a3d-1147a0a2e232&spaceId=16f39aaf-0317-4c98-9def-554c19109c98&width=2000&userId=d99aa862-99f3-418c-9da1-b86737bc5ec8&cache=v2)

Authorization의 Token에 해당 변수를 설정했다. {{app-token}} 형태로 삽입해 사용할 수 있다.

![image6](https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Fc867cb9d-3bee-4f80-9d7e-f2580db7df40%2FUntitled.png?table=block&id=f9467817-00a3-46d2-a839-bc7076d1a543&spaceId=16f39aaf-0317-4c98-9def-554c19109c98&width=2000&userId=d99aa862-99f3-418c-9da1-b86737bc5ec8&cache=v2)

성공적으로 동작하는 모습을 볼 수 있다.
