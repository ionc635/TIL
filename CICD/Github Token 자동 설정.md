## Github Token 자동 설정

- Github가 토큰 기반 인증으로 변경하면서 패스워드가 아닌 Token을 발행 받아 사용한다.
- EC2에서 Git에 접근하려고 하면 이 Token을 입력해야 한다. 매번 복사해 입력하는 것은 번거롭기 때문에 자동 설정 하는 방법을 알아보았다.
- 자동 설정 하는 방법
    1. .git 내부에 있는 config 파일을 열면 아래와 같은 내용이 입력되어 있다.

```jsx
[ec2@ip-000-00-0-000 .git]$ cat config
[core]
	repositoryformatversion = 0
	filemode = true
	bare = false
	logallrefupdates = true
[remote "origin"]
	url = https://github.com/~/~.git
	fetch = +refs/heads/*:refs/remotes/origin/*
```

1. [remote “origin”] 부분의 url을 아래와 같이 수정한다.

```jsx
url = https://{username}:{token}@github.com/~/~.git
```
