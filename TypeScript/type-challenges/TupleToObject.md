# TupleToObject

Give an array, transform into an object type and the key/value must in the given array.

`For example`

```jsx
const tuple = ['tesla', 'model 3', 'model X', 'model Y'] as const

type result = TupleToObject<typeof tuple> // expected { tesla: 'tesla', 'model 3': 'model 3', 'model X': 'model X', 'model Y': 'model Y'}
```

`Solution`

```jsx
type TupleToObject<T extends readonly any[]> = any

1. tuple의 타입은 string이기 때문에 string[]으로 변경
tuple 뒤에 as const가 붙었기 때문에 readonly [아래 참고]

=> type TupleToObject<T extends readonly string[]> = any 

2. 배열 내의 값을 아래와 같이 mapping 해준다.

=> type TupleToObject<T extends readonly string[]> = {
     T[0]: T[0]
     T[1]: T[1]
     T[2]: T[2]
     T[3]: T[3]
   }

3. 이를 식으로 나타내면,

type TupleToObject<T extends readonly string[]> = {
  [K in T[number]: K
}
```

## as const

`as const`와 `enum`은 서로 연관된 상수들을 하나로 묶어 관리할 때 사용한다. 이때, 객체의 프로퍼티들이 모두 `readonly`로 다뤄진다.

```jsx
enum EDirection {
  Up,
  Down,
  Left,
  Right,
}
 
const ODirection = {
  Up: 0,
  Down: 1,
  Left: 2,
  Right: 3,
} as const;
```

`as const`는 type assertion의 한 종류로 리터럴 타입의 추론 범위를 줄이고 값의 재할당을 막기 위한 목적으로 만들어졌다.

```jsx
const a = 'hello'; // 'hello'로 추론
let b = 'hello'; // string으로 추론
let b = 'hello' as const; // 'hello'로 추론
```

```jsx
const a = {
  hello: 'steven', // string으로 추론
  bye: 'mickey', // string으로 추론
}
a.hello = 'jess'; // jess로 변경
a.bye = 'john'; // john으로 변경

const a = {
  hello: 'steven', // 'steven'으로 추론, readonly
  bye: 'mickey', // 'mickey'으로 추론, readonly
} as const;
a.hello = 'jess'; // 변경되지 않음
a.bye = 'john'; // 변경되지 않음
```

### 참고 사이트

[https://www.typescriptlang.org/docs/handbook/enums.html](https://www.typescriptlang.org/docs/handbook/enums.html)

[https://www.typescriptlang.org/docs/handbook/release-notes/typescript-3-4.html#const-assertions](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-3-4.html#const-assertions)

[https://velog.io/@logqwerty/Enum-vs-as-const](https://velog.io/@logqwerty/Enum-vs-as-const)