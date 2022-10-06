## EC2 git 및 docker 설치

- Git install

```jsx
// yum 업데이트
sudo yum update -y

// git 설치
sudo yum install git -y

// 설치 확인
git version
```

- Docker install

```jsx
// 도커 설치
sudo amazon-linux-extras install docker

// 도커 시작
sudo service docker start

// 권한 부여
sudo usermod -a -G docker ec2-user

// auto-start에 docker 등록
sudo chkconfig docker on

// 인스턴스 재시작
sudo reboot
```

- Docker compose install

```jsx
// 최신 docker compose 설치
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

// 권한 부여
sudo chmod +x usr/local/bin/docker-compose
```
