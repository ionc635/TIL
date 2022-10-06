## Github Action Deploy

- Github Action Deploy Script

```jsx
name: deploy

on:
  push:
    branches: [dev]

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Run scripts in server
        uses: appleboy/ssh-action@master
        with:
          key: ${{ secrets.SSH_KEY }}
          host: ${{ secrets.HOST }}
          username: ${{ secrets.USER }}
          script: |
            cd sihlla-dfs-api
            git pull origin dev
            docker-compose up -d
```

- .github/workflows/~.yml 파일 내부에 작성한다.
- 가장 상단의 name은 현재 workflow의 이름이다.
- on에서는 event를 설정한다. 위 script에서는 dev branch에 push할 때 action한다.
- action을 하게되면 jobs 안의 내용이 실행된다.
- runs-on에서는 어떤 VM machine을 사용할 것인지 선택한다.
- steps에서 어떤 순서대로 실행할지 입력한다.
- 여기에서는 github에서 제공해주는 applyboy/ssh-action@master action을 사용한다. 이 action은 ssh로 접속하고 script를 실행하게 한다.
- with 내의 key, host, username은 github repo settings의 Actions secrets 내부에 생성한 내용을 가져온다.
    - SSH_KEY는 .pem 키 페어 내용
    - HOST는 EC2 인스턴스 IP
    - USER는 사용자 이름
- 마지막으로 script 순서대로 실행된다.
