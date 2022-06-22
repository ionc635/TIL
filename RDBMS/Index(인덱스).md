# Index(인덱스)

## 인덱스란?

인덱스는 테이블의 동작 속도(조회)를 높여주는 자료구조다. 데이터의 위치를 빠르게 찾아주는 역할을 한다. 인덱스는 MYI(MySQL Index)파일에 저장되며, 인덱스가 설정되지 않았다면 Table Full Scan이 일어나 성능이 저하되거나 치명적인 장애가 발생한다. 조회속도는 빨라지지만 UPDATE, INSERT, DELETE 연산 속도는 저하된다는 단점이 있다. (Table의 index 색인 정보를 갱신하는 추가적인 비용 소요) 효율적인 인덱스 설계로 단점을 최대한 보완하는 방법을 생각해봐야 한다.

## 인덱스의 특징

인덱스는 하나 혹은 여러 개의 `column`에 설정할 수 있다. 단일 여러 개 또는 여러 `column`을 묶은 복합인덱스가 가능하다. `WHERE`절을 사용하지 않고 인덱스가 걸린 `column`을 조회하는 것은 성능에 아무런 영향이 없다.

## 다중 컬럼 인덱스

다중 컬럼 인덱스는 두 개 이상의 필드를 조합해 생성한 `INDEX`이다. 1번째 조건과 이를 만족하는 2번째 조건을 함께 `INDEX`해서 사용한다. `MySQL`은 `INDEX`를 최대 15개 `column`으로 구성 가능하다. 다중 컬럼 인덱스는 단일 컬럼 인덱스 보다 더 비 효율적으로 CREATE / UPDATE / DELETE 연산을 수행한다.

## 단일 인덱스와 다중 컬럼 인덱스의 차이

```sql
[단일 인덱스]

CREATE TABLE single(
    uid INT(11) NOT NULL auto_increment,
    id VARCHAR(20) NOT NULL,
    name VARCHAR(50) NOT NULL,
    address VARCHAR(100) NOT NULL,
    PRIMARY KEY('uid'),
    key idx_name(name),
    key idx_address(address)
)

[다중 컬럼 인덱스]

CREATE TABLE multiple(
    uid INT(11) NOT NULL auto_increment,
    id VARCHAR(20) NOT NULL,
    name VARCHAR(50) NOT NULL,
    address VARCHAR(100) NOT NULL,
    PRIMARY KEY('uid'),
    key idx_name(name, address)    
)
```

```sql
[query 1]

SELECT * FROM single WHERE name='김종서' AND address='상도동';

[query 2]

SELECT * FROM multiple WHERE address='상도동';
```

`single` 테이블에서 `query 1`을 실행한 경우 각각의 칼럼에 `INDEX`가 걸려있기 때문에 `MySQL`은 `name`과 `address` 중 어떤 `column`수가 더 빠르게 검색 되는지 판단해 빠른 쪽을 먼저 검색하고 그 다음 남은 `column` 을 검색한다.

`multiple` 테이블에서 `query 1`을 실행한 경우에는 바로 원하는 값을 찾을 수 있다. `INDEX`를 저장할 때 같이 저장하기 때문이다. `name`과 `address`의 값을 같이 색인하고 검색에서도 '김종서상도동'으로 검색을 시도한다. 이렇게 사용할 경우 `multiple`이 `single`의 경우 보다 더 빠른 검색을 할 수 있다.

하지만 `multiple` 테이블에서 `query 2`를 실행한 경우에는 `INDEX`를 타지 않는다. 하지만 조건값을 `name`='김종서'로 준다면 `B*Tree` 자료구조 탐색으로 인해 `name` `column` `INDEX`가 적용된다. 다중 컬럼 인덱스를 사용할 때는 `INDEX`로 설정한 가장 왼쪽 `column`이 `WHERE`절에 사용 되어야 한다.

## ORDER BY 와 GROUP BY에 대한 INDEX

INDEX는 ORDER BY와 GROUP BY을 사용하는 다음과 같은 경우에 INDEX를 타지 않는다.

```sql
ORDER BY 인덱스 컬럼1, 컬럼2 : 복수의 키에 대해서 ORDER BY를 사용한 경우
WHERE 컬럼1 = '값' ORDER BY 인덱스 컬럼 : 연속하지 않은 컬럼에 대해 ORDER BY를 실행한 경우
ORDER BY 인덱스 컬럼1 DESC, 인덱스 컬럼2 ASC : DESC와 ASC를 혼합해서 사용한 경우
GROUP BY 인덱스 컬럼1 ORDER BY 인덱스 컬럼2 : GROUP BY와 ORDER BY의 컬럼이 다른 경우
ORDER BY ABS(컬럼) : ORDER BY 절에 다른 표현을 사용한 경우
```

## 효율적인 설계 방법

- 무조건 설정하지 않는다. 목적에 따라 한 테이블당 3~5개가 적당하다.
- 조회 시 자주 사용하는 `column`에 설정한다.
- 고유한 값 위주로 설계한다.
- cardinality가 높을 수록 좋다. (= 한 컬럼이 가지고 있는 중복의 정도가 낮을 수록 좋다.)
- INDEX 키의 크기는 되도록 작게 설계한다.
- `PK`, `JOIN`의 연결고리가 되는 `column`에 설정한다.
- 단일 인덱스 여러 개 보다는 다중 컬럼 INDEX 생성을 고려해야 한다.
- `UPDATE`가 빈번하지 않은 `column`에 설정한다.
- `JOIN`시 자주 사용하는 `column`에 설정한다.
- `INDEX`를 생성할 때 가장 효율적인 자료형은 정수형 자료형이다. 가변적 데이터에는 비 효율적이다.

## 인덱스 조회, 생성, 삭제 방법

```sql
[조회]

**SHOW INDEX FROM 테이블명;

[생성]

CREATE INDEX 인덱스명 ON 테이블명 (컬럼명)

ALTER TABLE 테이블명 ADD INDEX 인덱스명 (컬럼명)

[삭제]

ALTER TABLE 테이블명 DROP INDEX 인덱스명;**
```

## 인덱스를 타는지 확인하는 방법

쿼리 입력 후 상단에 EXPLAIN을 입력해준 후 조회하면 어떤 방식으로 쿼리를 조회하는지 보여준다.

## 옵티마이저 구조

![Untitled](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/f1b8340a-6d78-4e9f-a4e1-5724265768b3/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20220622%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20220622T115249Z&X-Amz-Expires=86400&X-Amz-Signature=6ea7739342ca1ce22ab1d2caf69e5aab3a8cfe2b924fcb1ab3fbca5c2f40b759&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22&x-id=GetObject)

MySQL 옵티마이저는 비용 기반으로 어떤 실행 계획으로 쿼리를 실행 했을 때 비용이 얼마나 발생하는지를 계산해 비용이 가장 적은 것을 택한다. 어디까지나 추정 값으로 정확한 비용은 실행 전까지 정확히 알 수 없다.

## ****EXPLAIN 결과****

`EXPLAIN`은 MySQL 서버가 어떠한 쿼리를 실행할 것인가, 즉 실행 계획이 무엇인지 알고 싶을 때 사용하는 기본명령어이다.

```sql
EXPLAIN SELECT * FROM user
```

```sql
********************** 1. row **********************
           id: 1
  select_type: SIMPLE
        table: user
         type: ALL
possible_keys: NULL
          key: NULL
      key_len: NULL
          ref: NULL
         rows: 4
        Extra: 
1 row in set (0.00 sec)
```

### id

쿼리 안에 있는 각 `select` 문에 대한 순차 식별자이다. 이 순서대로 `select` 문이 실행된다고 생각하면 된다.

### select_type

`select` 문의 유형을 말한다. 각 유형은 아래와 같다.

`SIMPLE` : 서브쿼리나 'union'이 없는 가장 단순한 select 문

`PRIMARY` : 가장 바깥에 있는 select 문

`DERIVED` : from 문 안에있는 서브쿼리의 select 문

`SUBQUERY` : 가장 바깥의 select 문에 있는 서브쿼리

`DEPENDENT SUBQUERY` : 기본적으로 SUBQUERY와 같은 유형이며, 가장 바깥의 select문에 '의존성'을 가진 서브쿼리의 select 문

`UNCACHEABLE SUBQUERYUNION` : union 문의 두번째 select 문

`DEPENDENT UNION` : 바깥 쿼리에 의존성을 가진 union문의 두번째 select 문

### table

참조되는 테이블을 말한다.

### type

`MySQL`이 어떤식으로 `Table`들을 `join`하는지를 나타내는 항목이다. 어떤 인덱스가 사용되는지 알 수 있다. 각 유형은 아래와 같다.

`system` : 0개 또는 하나의 `row`를 가진 테이블

`const` : 테이블에 조건을 만족하는 레코드가 하나일 때, 상수 취급

`eq_ref` : primary key나 unique not null column으로 생성된 인덱스를 사용해 조인을 하는 경우이다. const 방식 다음으로 빠른 방법이다.

`ref` : 인덱스로 지정된 `column`끼리의 '=' , '<=>' 와 같은 연산자를 통한 비교로 수행되는 조인이다.

`index_mergeunique_subquery` : 오직 하나의 결과만을 반환하는 'IN'이 포함된 서브쿼리의 경우이다.

`index_subquery` : unique_subquery와 비슷하지만 여러개의 결과를 반환한다.

`range` : 특정한 범위의 `rows`들을 매칭하는데 인덱스가 사용된 경우이다. `BETWEEN`이나 IN, '>', '>=' 등이 사용될 때이다.

`all` : 조인시에 모든 테이블의 모든 `row`를 스캔하는 경우이다. 물론 성능이 가장 좋지 않다.

### possible_keys

테이블에서 `row`를 `mappingg` 하기 위해 사용 가능한 (사용하지 않더라도) 키를 보여 준다.

### key

실제 `query` 실행에 사용된 `key`의 목록이다. 이 항목 내에는 `possible_keys` 목록에 나타지 않은 인덱스도 포함 될 수 있다.

### ref

`key column`에 지정된 인덱스와 비교되는 `column` 또는 `constants`를 보여준다.

### rows

결과 산출에 있어서 접근되는 `record`의 숫자이다. 조인문이나 `sub query` 최적화에 있어서 중요한 항목이다.

### Extra

실행계획에 있어서 부가적인 정보를 보여 준다.

`distinct` : 조건을 만족하는 레코드를 찾았을 때 같은 조건을 만족하는 또 다른 레코드가 있는지 검사하지 않는다.

`not exist` : left join 조건을 만족하는 하나의 레코드를 찾았을 때 다른 레코드의 조합은 더 이상 검사하지 않는다.

`range checked for each record` : 최적의 인덱스가 없는 차선의 인덱스를 사용한다는 의미.

`using filesort` : mysql이 정렬을 빠르게 하기 위해 부가적인 일을 한다.

`using index` : select 할때 인덱스 파일만 사용

`using temporary` : 임시 테이블을 사용한다. order by 나 group by 할때 주로 사용

`using where` : 조건을 사용한다는 의미.
