# git-submodule

## **메인 프로젝트에 서브모듈 추가하기**

1. 다음의 명령어를 통해 `submodule`을 추가할 수 있다.

```jsx
# main-project에서

git submodule add [Github Repository 주소] [원하는 디렉토리명]

// 마지막 인자를 주지 않으면 실제 레포지토리 이름으로 디렉토리가 생성된다.
```

2. 위 명령어의 결과로 `.gitmodules`라는 파일과 자신의 `Github Repository` 또는 지정한 이름의 `디렉토리`가 생성된다.

```jsx
# main-project/.gitmodules

[submodule [submodule]
	path = [submodule]
	url = https://github.com/blockodyssey-jskim/[submodule].git

# main-project/[submodule]

|-- src
|-- test
|-- package.json
...
```

3. `submodule`을 추가한 내용을 `커밋`해야 한다.

`git status` 명령어로 확인하면 다음과 같이 파일이 추적 가능한 상태`(tracked)`임을 확인할 수 있다.

```jsx
# main-project

git status # 상태 확인
git commit # 커밋
```

`커밋`할 때 `create mode 160000 [서브모듈 디렉토리]` `메세지`가 나온다. 160000은 이 `submodule`을 다른 `디렉토리`와 다르게 취급한다는 의미이다.

4. 원격 `레포지토리`로 푸쉬한다.

## 동료에게 `submodule` 적용시키기

1. 최초 적용 시: 메인 프로젝트에서 다음 명령어를 입력한다.

```jsx
# main-project

# submodule 시작
git submodule init

# clone submodules
git submodule update

# submodule의 main(master)으로 checkout 한다.
git submodule foreach git checkout main(master)

// foreach는 모든 서브 모듈에게 적용한다는 뜻이다.
```

```bash
~/dev/auth main ❯ git submodule init                                                  
Submodule 'submodule' (https://github.com/blockodyssey-jskim/submodule.git) registered for path 'submodule'
```

```bash
~/dev/auth main ❯ git submodule update
Cloning into '/Users/hyogu/dev/auth/submodule'...
Submodule path 'submodule': checked out '298a0e7f835d8a4b66ca284af0ef1f7208ea08af'
```

```bash
~/dev/auth main ❯ git submodule foreach git checkout main
Entering 'submodule'
Switched to branch 'main'
Your branch is up to date with 'origin/main'.
```

2. 업데이트 시: 이미 `submodule`을 불러 온 이후, 서브 모듈이 `커밋`된 상황이라면 다음 명령어를 입력한다.

```jsx
# main-project

git submodule update --remote --merge

// --remote 뒤에 특정 레포지토리 이름을 인자로 주면 특정 submodule에만 적용할 수 있다.
// --remote는 서브 모듈 레포지토리의 최신 커밋을 가져온다.
```

## Main-Project에서 `submodule` 내용을 수정 했을 때

1. Commit

만약 `main project`에서 작업을 하던 중 서브 모듈을 수정을 해야한다면 서브 `커밋`을 먼저하고, 메인 `커밋` 을 진행해야 한다. 만약 메인 프로젝트를 먼저 `커밋`하고 서브모듈을 `커밋`하면, 메인 프로젝트가 나중에 `커밋`된 서브모듈의 변경 사항을 추적하지 못하므로 의도하지 않은 오류가 생길 수 있다.

2. Push

`푸쉬`도 `커밋`과 마찬가지로 서브를 먼저하고, 메인을 진행해야 한다. 서브 모듈을 먼저 `커밋`하고, 메인을 `커밋`했다고 해도 메인부터 `푸쉬`를 한다면 `submodule` 의 원격 `레포지토리`에 서브 모듈이 반영되지 않을 것이다. 이를 방지하기 위해 `Git`에서는 두 가지 기능을 제공한다.

```jsx
# main project를 push하기 전에,

1) submodule이 모두 push된 상태인지 확인하고, 확인이 되면 main project를 push

git push --recurse-submodules=check

2) submodule을 모두 push하고, 성공하면 main project를 push

git push --recurse-submodules=on-demand
```

```jsx
# default 설정 잡기

# push 시에 항상 check
git config push.recurseSubmodules check

# push 시에 항상 on-demand
git config push.recurseSubmodules on-demand
```
