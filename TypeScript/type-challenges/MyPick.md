# MyPick

Implement the built-in `Pick<T, K>` generic without using it.

Constructs a type by picking the set of properties `K` from `T`

`For example`

```jsx
interface Todo {
  title: string
  description: string
  completed: boolean
}

type TodoPreview = MyPick<Todo, 'title' | 'completed'>

const todo: TodoPreview = {
    title: 'Clean room',
    completed: false,
}
```

`Solution`

```jsx
type MyPick<T, K> = any

1. K는 T의 제너릭 타입의 부분이고, K는 literal union 형태이다. => extends keyof 사용

type MyPick<T, K extends keyof T> = any

2. K의 값이 객체의 key이고, 뒤에 그 key의 타입이 나온다.

type MyPick<T, K keyof T> = {
  [key in K]: T[key]
	// title: T[title] = string;
	// completed: T[completed] = boolean;
} 
```

## 참고

### Keyof

: keyof 키워드는 타입 값에 존재하는 모든 프로퍼티의 키값을 union 형태로 받는다.

```jsx
type Arrayish = { [n: number]: unknown };
type A = keyof Arrayish;
    
// type A = number
 
type Mapish = { [k: string]: boolean };
type M = keyof Mapish;
    
// type M = string | number
// JavaScript 객체 키가 항상 문자열로 강제 변환되기 때문이다. keyof 유형은 매핑된 유형과 결합될 때 유용하다.

interface Todo {
  name: number;
  gender: string;
  age: Date;
}

// keyof Todo = "name" | "gender" | "age"
```

### extends keyof

`extends`, in this case, is used to [constrain the type of a generic parameter](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints). Example:

`<T, K extends keyof T>`

`K` can therefor only be a public property name of `T`. It has nothing to do with extending a type or inheritance, contrary to [extending interfaces](https://www.typescriptlang.org/docs/handbook/2/objects.html#extending-types).

A usage of `extends keyof` could be the following:

```jsx
function getProperty<T, K extends keyof T>(obj: T, key: K): T[K] {
  return obj[key];
}

const person: Person = {
  age: 22,
  name: "Tobias",
};

// name is a property of person
// --> no error
const name = getProperty(person, "name");

// gender is not a property of person
// --> error
const gender = getProperty(person, "gender");
```

### in keyof

`in` is used when we're defining an [index signature](https://basarat.gitbook.io/typescript/type-system/index-signatures#declaring-an-index-signature) that we want to type with a union of string, number or symbol literals. In combination with `keyof` we can use it to create a so called *mapped type*, which re-maps all properties of the original type.

A usage of `in keyof` could be the following:

```jsx
type Optional<T> = { 
  [K in keyof T]?: T[K] 
};

const person: Optional<Person> = {
  name: "Tobias"
  // notice how I do not have to specify an age, 
  // since age's type is now mapped from 'number' to 'number?' 
  // and therefore becomes optional
};
```

Aside from the [documentation on mapped types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#mapped-types), I once again found [this helpful article](https://mariusschulz.com/blog/mapped-types-in-typescript#modeling-object-freeze-with-mapped-types).

[https://www.typescriptlang.org/docs/handbook/2/keyof-types.html](https://www.typescriptlang.org/docs/handbook/2/keyof-types.html)

[https://tousu.in/qa/?qa=949082/](https://tousu.in/qa/?qa=949082/)