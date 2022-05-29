# Exclude

Implement the built-in Exclude<T, U>

> Exclude from T those types that are assignable to U
> 

## `Exclude<UnionType, ExcludedMembers>`

> Released:2.8
> 

Constructs a type by excluding from `UnionType` all union members that are assignable to `ExcludedMembers`.

### Example

```tsx
type T0 = Exclude<"a" | "b" | "c", "a">;
     type T0 = "b" | "c"

type T1 = Exclude<"a" | "b" | "c", "a" | "b">;
     type T1 = "c"

type T2 = Exclude<string | number | (() => void), Function>;
     type T2 = string | number
```

**Answer**

```tsx
type MyExclude<T, U> = T extends U ? never : T;
```

**Solution**

```tsx
1. we have to construct a type by excluding from T to U.

2. if T have U, it invokes 'never'. and don't have, it invokes 'T'.

3. Note that T enters one by one there. In the first situation, for example, T values are entered in the order of a, b, and c.
```

**Test Cases**

```tsx
import type { Equal, Expect } from '@type-challenges/utils'

type cases = [
  Expect<Equal<MyExclude<'a' | 'b' | 'c', 'a'>, Exclude<'a' | 'b' | 'c', 'a'>>>,
  Expect<Equal<MyExclude<'a' | 'b' | 'c', 'a' | 'b'>, Exclude<'a' | 'b' | 'c', 'a' | 'b'>>>,
  Expect<Equal<MyExclude<string | number | (() => void), Function>, Exclude<string | number | (() => void), Function>>>,
]
```
