# Docker redis-cluster 연결

## redis.conf 설정

`redis-cluster` 모드는 `redis` 설정 파일 `redis.conf`에서 설정할 수 있다. `redis.conf` 파일은 다운 받은 `redis` 폴더에서 확인할 수 있다. `cluster` 환경을 구성하기 위해서는 아래와 같이 `redis.conf` 내부의 값을 수정한다. 이때, 연결할 `redis` 당 하나의 `redis.conf` 파일이 필요하다.

```
# redis.conf

*port 7001 // 연결할 port
cluster-enabled yes
cluster-config-file node.conf 
// cluster의 node 구성이 기록되는 파일. 컨테이너 내부에 node.conf 생성
cluster-node-timeout 3000
// node를 failover 상태로 인식하는 최대 시간
appendonly yes 
// 장애 발생 시 복구 가능하도록 데이터를 appendonly 파일에 저장 
// 컨테이너 내부에 appendonly.aof 파일 생성*
```

## docker-compose.yml 작성

```jsx
version: "3"
services:
  redis-cluster:
    image: redis:6.2.6
    container_name: redis-1
    volumes:
		// 위에서 만든 redis.conf 파일을 볼륨을 통해 컨테이너에 공유
      - ./redis7001.conf:/usr/local/etc/redis/redis.conf
    command: redis-server /usr/local/etc/redis/redis.conf
    restart: always
    ports:
      - 7001:7001
      - 7002:7002
      - 7003:7003

  redis-node-1:
    network_mode: "service:redis-cluster"
    image: redis:6.2.6
    container_name: redis-2
    volumes:
      - ./redis7002.conf:/usr/local/etc/redis/redis.conf
    command: redis-server /usr/local/etc/redis/redis.conf
    restart: always

  redis-node-2:
    network_mode: "service:redis-cluster"
    image: redis:6.2.6
    container_name: redis-3
    volumes:
      - ./redis7003.conf:/usr/local/etc/redis/redis.conf
    command: redis-server /usr/local/etc/redis/redis.conf
    restart: always

  redis-cluster-entry:
    network_mode: "service:redis-cluster"
    image: redis:6.2.6
    container_name: redis-cluster-entry
    command: redis-cli --cluster create 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 --cluster-yes
    restart: always
    depends_on:
      - redis-cluster
      - redis-node-1
      - redis-node-2
```

각 `redis` 노드 컨테이너는 `volumns`을 통해 구성한 `redis.conf` 파일을 각 컨테이너로 공유한다. `command`에는 컨테이너 내부에서 실행할 `redis-server <설정파일위치>` 와 같이 실행 스크립트를 구성한다.

`docker-compose.yml` 파일에서는 각 `redis` 노드들이 하나의 네트워크 `service:redis-cluster`를 공유하고 있다. `redis-cluster`는 네트워크 주소가 변환(Network Address Transport, NAT)된 환경 또는 IP주소 / TCP 포트를 재맵핑하는 환경을 지원하지 않는다. `docker`의 경우에는 컨테이너 내부에서 실행되는 프로그램을 특정 외부 포트로 노출할 수 있는 ‘`포트 매핑`’ 기술을 사용하고 있으며, 이는 여러 컨테이너가 동일한 포트를 가지는 상황을 해결하는 데에 유용하게 사용된다.

`docker` 상에서 실행하는 `redis` 컨테이너가 `redis-cluster`에 호환되도록 하기 위해서는 `host` `network_mode`를 사용해야 한다. `host` `network_mode`는 `포트 매핑`을 통해 주소를 변환하지 않고, 컨테이너가 호스트 네트워크를 곧바로 사용하도록 한다. 하지만 리눅스 환경이 아닌 경우에는 `host` `network_mode` 가 지원되지 않는다. 즉, `Docker Desktop for Mac`, `Docker Desktop for Windows` 의 경우 올바르게 동작할 수 없다.

`host` `network_mode`를 사용하지 않고, 각 `redis`에 `mapping`된 하나의 동일한 네트워크를 각 노드가 공유하는 위 방법으로 `Docker Desktop for Mac`, `Docker Desktop for Windows` 를 사용하는 경우에도 `redis-cluster`를 동작할 수 있는 것이다.

`redis-cluster-entry`는 `cluster` 모드를 활성화하는 작업을 진행한다. 다른 `redis` 노드와 동일하게 `service:redis-cluster` 네트워크상에서 동작하며, `redis-cli —cluster create` 명령으로 `cluster` 모드를 시작한다. 이 명령어는 세 개의 `redis` 노드 컨테이너가 모두 실행된 이후에 작업이 진행되어야 하므로, `depends_on` 필드에 각 의존 컨테이너를 명시하도록 한다.

## docker 명령어

- `docker ps`: 현재 동작하는 컨테이너를 확인
- `docker-compose up`: `docker-compose`에 정의되어 있는 모든 컨테이너를 한 번에 생성하고 실행
    - `-d` `option`: 백그라운드에서 실행
- `docker-compose down`: `docker-compose`에 정의되어 있는 모든 컨테이너를 한 번에 정지하고 삭제
- `docker exec -it <container_name> bash`: 컨테이너 내부 접속
    - 나올 때는 `exit`
