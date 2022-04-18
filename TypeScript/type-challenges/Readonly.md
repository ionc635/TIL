# Readonly

Implement the built-in `Readonly<T>` generic without using it.

Constructs a type with all properties of T set to readonly, meaning the properties of the constructed type cannot be reassigned.

`For example`

```jsx
interface Todo {
  title: string
  description: string
}

const todo: MyReadonly<Todo> = {
  title: "Hey",
  description: "foobar"
}

todo.title = "Hello" // Error: cannot reassign a readonly property
todo.description = "barFoo" // Error: cannot reassign a readonly property
```



`Solution`

```jsx
type MyReadonly<T> = any

1. in keyof T로 매핑한다.

type MyReadonly<T> = {
  [key in keyof T]
  // title
  // description
}

2. key의 타입을 명시한다.

type MyReadonly<T> = {
  [key in keyof T]: T[key]
  // title: T[title] = string;
  // description: T[description] = string;
}

3. readonly를 붙여준다.

type MyReadonly<T> = {
  readonly [key in keyof T]: T[key]
}

```



### Readonly

생성자의 외부에서 할당되는 것을 막는다.

```jsx
class Greeter {
  readonly name: string = "world";
 
  constructor(otherName?: string) {
    if (otherName !== undefined) {
      this.name = otherName;
    }
  }
 
  err() {
    this.name = "not ok";
// Cannot assign to 'name' because it is a read-only property.
  }
}
const g = new Greeter();
g.name = "also not ok";
// Cannot assign to 'name' because it is a read-only property.
```