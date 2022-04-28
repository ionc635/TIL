# Jenkins EC2 설정

### EC2 설정

- Jenkins를 올릴 EC2와 실제 프로젝트를 올릴 서버 총 2개가 필요하다. EC2 설정 방법은 여기에서 생략한다.

![image](https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Fda43cc5a-298e-42bf-9619-5bb8a917cd0f%2FUntitled.png?table=block&id=1a046304-f068-41dd-9c8f-704c8246171b&spaceId=16f39aaf-0317-4c98-9def-554c19109c98&width=2000&userId=d99aa862-99f3-418c-9da1-b86737bc5ec8&cache=v2)

### Jenkins 설치

```jsx
# Jenkins EC2 접속

1. 패키지 인덱스를 업데이트 해준다.
$ sudo apt update

2. 기본 Default JRE(Java Runtime Environment를 설치해주기 위해 아래과 같이 입력한다.
젠킨스는 자바 기반이기 때문이라고 한다.
$ sudo apt install default-jre

3. 아래 명령어로 잘 설치되었는지 확인한다. 아래 메시지가 나와야 한다.
$ java -version

// openjdk version "11.0.14.1" 2022-02-08
// OpenJDK Runtime Environment (build 11.0.14.1+1-Ubuntu-0ubuntu1.20.04)
// OpenJDK 64-Bit Server VM (build 11.0.14.1+1-Ubuntu-0ubuntu1.20.04, mixed mode, sharing)

4. 자바 기반의 소프트웨어(Jenkins)를 컴파일하고 실행하기 위해JDK(Java Development Kit)도 필요하다.
$ sudo apt install default-jdk

5. 아래 명령어로 잘 설치되었는지 확인한다. 아래 메시지가 나와야 한다.
$ javac -version

// javac 11.0.14.1 
```

```jsx
1. 레포지터리 키를 등록한다. 아래의 명령어를 입력한다.
$ cd /tmp && wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -

2. 레포지터리를 등록하기 위해 다음 명령어를 입력한다.
$ echo 'deb https://pkg.jenkins.io/debian-stable binary/' | sudo tee -a /etc/apt/sources.list.d/jenkins.list

3. Jenkins 설치를 위해 아래의 명령어를 차례로 입력한다.
$ cd ..
$ sudo apt update
$ sudo apt install jenkins

4. Jenkins를 설치한 후, Jenkins를 시작하거나 멈추거나, 
서버가 부팅될 때 Jenkins가 항상 시작하도록 하기 위해 아래의 명령을 입력한다.
$ sudo systemctl stop jenkins.service
$ sudo systemctl start jenkins.service
$ sudo systemctl enable jenkins.service

5. 아래 명령어를 입력했을 때, 아래의 이미지에 보이면 성공이다.
$ sudo systemctl status jenkins
```

![image1](https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F9b20b18f-ae01-44db-add8-59bd664ffb04%2FUntitled.png?table=block&id=dc30f572-6b4b-4f23-8d1f-9594a68cc1f4&spaceId=16f39aaf-0317-4c98-9def-554c19109c98&width=2000&userId=d99aa862-99f3-418c-9da1-b86737bc5ec8&cache=v2)

### 방화벽 설정

`Jenkins`는 기본적으로 8080 포트 위에서 실행된다. 8080 포트와 22번 포트의 ssh 액세스를 허용해야 한다.

```jsx
1. 8080 포트 ssh 액세스 허용
$ sudo ufw allow 8080
$ sudo ufw allow 22

2. 방화벽 상태 확인 
$ sudo ufw status // Status: inactive

3. inactive 상태를 active로 변경
$ sudo ufw enable
```

![image2](https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F122f8876-426d-4fee-ac89-75fc7d886366%2FUntitled.png?table=block&id=95bcbb69-9236-49e3-8eb6-745fc2d95053&spaceId=16f39aaf-0317-4c98-9def-554c19109c98&width=2000&userId=d99aa862-99f3-418c-9da1-b86737bc5ec8&cache=v2)

### Jenkins 접속

- `Jenkins EC2` 인바운드 보안 그룹에 8080을 추가한다.

![image3](https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Fddcff1ed-0a3d-4fe9-abc3-7247953e8fac%2FUntitled.png?table=block&id=c4840394-5ab1-4a5e-8c65-836228942d4e&spaceId=16f39aaf-0317-4c98-9def-554c19109c98&width=2000&userId=d99aa862-99f3-418c-9da1-b86737bc5ec8&cache=v2)

- `http://Jenkins_EC2_IP:8080`로 접속하면, 아래의 화면을 볼 수 있다.

![image4](https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F1541cf54-2d3e-44b3-a8fc-4efd8d512707%2FUntitled.png?table=block&id=9030a414-2794-4587-ad19-7dd04dfb88db&spaceId=16f39aaf-0317-4c98-9def-554c19109c98&width=2000&userId=d99aa862-99f3-418c-9da1-b86737bc5ec8&cache=v2)

- 아래의 명령어로 `Administrator password` 가져온 다음 입력한다.

```jsx
$ sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

- 좌측의 `install suggested plugin` 버튼을 누르면 설치가 된다.
- 이후에 유저 정보 입력 페이지, `Jenkins URL` 설정 페이지가 순서대로 나오는데 값을 입력해준다.
