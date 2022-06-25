# any 다루기

## 아이템 38 any 타입은 가능한 한 좁은 범위에서만 사용하기

```jsx
function processBar(b: Bar) { /* ... */ }

function f() {
  const x = expressionReturningFoo();
  processBar(x);
             ~ 'Foo' 형식의 인수는 'Bar' 형식의 매개변수에 할당될 수 없다.
}
```

x라는 변수가 동시에 Foo 타입과 Bar 타입에 할당 가능하다면, 오류를 제거하는 방법은 두 가지이다.

```jsx
function f1() {
  const x: any = expressionReturningFoo();
  processBar(x);
}

function f2() {
  const x = expressionReturningFoo();
  processBar(x as any);
}
```

아래에서 사용된 x as any 형태가 권장된다. 그 이유는 any 타입이 processBar 함수의 매개변수에서만 사용된 표현식이므로 다른 코드에는 영향을 미치지 않기 때문이다. 

```jsx
function f1() {
  const x: any = expressionReturningFoo();
  processBar(x);
  return x;
}

function g() {
  const foo = f1(); // 타입이 any
  foo.fooMethod(); // 이 함수 호출은 체크되지 않는다.
}
```

@ts-ignore를 사용하면 any를 사용하지 않고 오류를 제거할 수 있다.

```jsx
function f1() {
  const x: any = expressionReturningFoo();
  // @ts-ignore
  processBar(x);
  return x;
}
```

@ts-ignore를 사용하면 다음 줄의 오류가 무시된다. 하지만 근본적인 원인을 해결하는 것이 아니기 때문에 다른 곳에서 더 큰 문제가 발생할 수 있다.

```jsx
const config: Config = {
  a: 1,
  b: 2,
  c: {
    key: value
  }
} as any;

const config: Config = {
  a: 1,
  b: 2,
  c: {
    key: value as any
  }
};  
```

객체 전체를 any로 단언하면 다른 속성들 역시 타입 체크가 되지 않을 수 있기 때문에 아래와 같이 최소한의 범위에만 any를 사용하는 것이 좋다.

## 아이템 39 any를 구체적으로 변형해서 사용하기

any는 모든 값을 아우르는 매우 큰 범위의 타입임으로 일반적인 상황에서는 any 보다 더 구체적으로 표현할 수 있는 타입을 찾아 타입 안정성을 높여야 한다.

any 타입의 값을 그대로 정규식이나 함수에 넣는 것은 권장되지 않는다.

```jsx
function getLengthBad(array: any) {
  return array.length;
}

function getLength(array: any[]) {
  return array.length;
}
```

아래와 같이 사용해야 하는 이유는 아래와 같습니다.

- array.length 타입이 체크된다.
- 반환 타입이 any가 아닌 number로 추론된다.
- 함수가 호출될 때 매개변수가 배열인지 체크된다.
- 배열이 아닌 값을 넣었을 때 오류를 잡아낼 수 있다.

함수의 매개변수가 객체이지만 값을 알 수 없다면 `{ [key: string]: any }`으로 선언하면 된다. object로도 사용할 수 있지만 속성에 접근할 수 없다.

```jsx
function hasTwelveLetterKey (o: {[ key: string]: any}) {
  for (const key in o ) {
    if (key.length === 12) {
      console.log(key, o[key])
    }
  }
}
```

함수 타입에도 단순히 any를 사용해서는 안된다. 아래와 같이 any 보다는 구체적으로 선언해야 한다.

```jsx
type Fn0 = () => any;
type Fn1 = (arg: any) => any;
type FnN = (...args: any[]) => any;
```

## 아이템 40 함수 안으로 타입 단언문 감추기

외부로 드러난 타입 정의는 간단하지만 내부 로직이 복잡해 안전한 타입으로 구현하기 어려운 경우가 있다. 불필요한 예외 상황까지 고려해가며 힘들게 타입 정보를 구성할 필요는 없다. 함수 내부에는 타입 단언을 사용하고 함수 외부로 드러나는 타입 정의를 정확히 명시하면 된다.

타입스크립트는 반환문에 있는 함수와 원본 함수 T타입이 어떤 관련이 있는지 알지 못해 오류가 발생한다. 결과적으로 원본 함수 T타입과 동일한 매개변수로 호출되고 반환값 역시 예상한 결과가 되기 때문에, 타입 단언문을 추가해 오류를 제거하는 것이 문제되지 않는다.

```jsx
declare function shallowEqual(a: any, b: any): boolean;

function cachLast<T extends Function>(fn: T): T {
  let lastArgs: any[] | null = null;
  let lastResult: any;
  return function(...args: any[]) {
    if (!lastArgs || !shallowEqual(lastArgs, args)) {
      lastResult = fn(...args)
      lastArgs = args;
    }
    return lastResult;
  } // as unknown as T;
}
```

if 구문의 `k in b`체크로 b 객체에 k 속성이 있다는 것을 확인했지만 b[k] 오류가 발생하는 것이 이상하다. 타입스크립트의 문맥 활용 능력이 부족한 것으로 보인다. `k in b` 체크를 했으므로 `b as any` 타입 단언문은 안전하다. 

```jsx
function shallowObjectEqual<T extends object>(a: T, b: T): boolean {
  for (const [k, aVal] of Object.entries(a)) {
    if (!(k in b) || aVal !== (b // as any)[k]) {
      return false;
    }
  }
  return Object.keys(a).length === Object.keys(b).length
}
```

타입 단언문은 일반적으로 타입을 위험하게 만들지만 상황에 따라 필요하기도 하고 현실적인 해결책이 되기도 한다. 불가피하게 사용해야 한다면 정확한 정의를가지는 함수 안으로 숨겨야 한다.

## 아이템 41 any의 진화를 이해하기

```jsx
function range(start: number, limit: number) {
  const out = []; // any[]
  for (let i = start; i < limit; i++) {
    out.push(i); // any[]
  }
  return out; // number[]
}
```

배열에 타입의 요소를 넣으면 배열의 타입이 확장되며 진화한다.

```jsx
let val; // any
if (Math.random() < 0.5) {
  val = /hello/;
  val // RegExp
} else {
  val = 12;
  val // number
}
val // number || RegExp
```

조건문에서는 분기에 따라 타입이 변할 수 있다.

any 타입의 진화는 noImplicitAny가 설정된 상태에서 변수의 타입이 암시적 any인 경우에만 일어난다. 아래와 같이 명시적으로 any를 선언하면 타입이 그대로 유지된다.

```jsx
let val: any; // any
if (Math.random() < 0.5) {
  val = /hello/;
  val // any
} else {
  val = 12;
  val // any
}
val // any
```

암시적 any 상태인 변수에 어떠한 할당도 하지 않고 출력되면 암시적 any 오류가 발생한다.

```jsx
function range(start: number, limit: number) {
  const out = []; // any[]
  if (start === limit) {
    return out;
    //     ~~~
}
```

any 타입의 진화는 암시적 any 타입에 어떤 값을 할당할 때만 발생한다. 그리고 어떤 변수가 암시적 any 상태일 때 값을 읽으려고 하면 오류가 발생한다.

타입을 안전하게 지키기 위해서는 암시적 any를 진화시키는 방식보다 명시적 타입 구문을 사용하는 것이 더 좋은 설계이다.
