# TypeScript Unknown 타입

![image](https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F1af14eab-4ffa-4868-b0dd-ede4e3b6f879%2FUntitled.png?table=block&id=b8ea7265-0df6-4501-8ebb-adb51d4beed9&spaceId=16f39aaf-0317-4c98-9def-554c19109c98&width=2000&userId=d99aa862-99f3-418c-9da1-b86737bc5ec8&cache=v2)

TypeScript에는 any, unknown, never이라는 JavaScript에 없는 타입이 존재한다. Unknown 타입이 잘 이해되지 않아 any, never과 비교해 정리해보고자 한다. 먼저 any와 never 타입을 알아보고, 마지막에 Unknown 타입을 알아볼 것이다.

### Any

타입 검사를 항상 만족하여 어떤 값이든 바로 대입하고 사용할 수 있는 타입이다. 타입 검사를 항상 만족하기 때문에 코드 작성은 편리하지만 의도치 않은 형 변환이나 의도되지 않은 타입 값이 대입되는 등의 `Side Effect`가 발생될 가능성이 높기 때문에 주의해야 한다.

```jsx
let value: any = 29;
// 현재 number 타입이 할당되어 있다.

value.concat();
// number 타입은 위 메소드를 가지고 있지 않지만 컴파일러가 확인하지 않아 에러가 발생되지 않는다. 
// 물론 실행할 경우에는 에러가 발생한다.

value.toFixed();
// number 타입은 toFixed() 메소드를 가지고 있다. 하지만 별도로 확인하지 않는다.
```

### Never

`never`은 모든 타입의 하위 타입이다. 그 어떤 다른 값도 `never` 타입에 할당할 수 없다. 

```jsx
const value: never = 29;
// 위 코드는 컴파일 오류가 발생한다.
```

일반적으로 `never`은 함수가 어떠한 값도 반환하지 않을 때와 타입 추론 예외를 제거할 때 사용한다. 어떠한 값도 반환하지 않는 함수라면 `never`로 명시해 알려줄 수 있다.

```jsx
const fetchUser = (username: string): never => {
  throw new Error('Not Implemented');
}
```

또한 특정 타입 값을 할당 받지 않도록 `never`를 사용하기도 한다. 아래의 `NonString` 타입은 어떤 타입이든 될 수 있지만 `string` 타입일 경우에는 `never`로 추론해 `string` 타입 값이 할당되지 않는다.

```jsx
type NonString<T> = T extends string ? never : T;
```

## Unknown

`unknown`은 `TypeScript`의 탑 타입(`Top Type`)이다. 존재하는 모든 타입을 가질 수 있지만, 모든 타입이 공통적으로 할 수 있는 연산 외에는 할 수 있는 것이 없다. 어떤 타입인지 알 수 없는 타입이기 때문에 `unknown` 타입 변수를 사용할 때는 어떤 타입인지 다시 한번 명시해줘야 한다.

```jsx
let value: unknown = 'haha';

value = 29;
// 타입이 unknown이므로 어떤 타입의 값이든 재할당 가능하다.

let age: number = value;
// 변수의 타입이 명확하지 않으므로 값 할당이 불가능하다.

let age: number = (value as number);
// 위와 같이 명시해주어야 사용 가능하다.

if (value === 29) {
  const age: number = value;
}

if (typeof value === 'number') {
  const age: number = value;
}
// 하지만 타입 검사가 된 이후에는 타입을 명시해주지 않아도 사용 가능하다.
```

