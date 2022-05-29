# Length of Tuple

For given a tuple, you need create a generic `Length`, pick the length of the tuple

**For example**

```jsx
type tesla = ['tesla', 'model 3', 'model X', 'model Y']
type spaceX = ['FALCON 9', 'FALCON HEAVY', 'DRAGON', 'STARSHIP', 'HUMAN SPACEFLIGHT']

type teslaLength = Length<tesla>  // expected 4
type spaceXLength = Length<spaceX> // expected 5
```

**Answer**

```jsx
type Length<T extends readonly string[]> = T['length']
```

**Solution**

```jsx
1. They had tuple of string, so I wrote <T extends string[]>. but, we can also write <T extends any[]>.

2. we can write T['length'] for picking the length of the tuple in typescrpit.

3. and then they used the <as const> grammer for asserting the tuple. so, we have to attach the readonly.
```

**Test Cases**

```jsx
import type { Equal, Expect } from '@type-challenges/utils'

const tesla = ['tesla', 'model 3', 'model X', 'model Y'] as const
const spaceX = ['FALCON 9', 'FALCON HEAVY', 'DRAGON', 'STARSHIP', 'HUMAN SPACEFLIGHT'] as const

type cases = [
  Expect<Equal<Length<typeof tesla>, 4>>,
  Expect<Equal<Length<typeof spaceX>, 5>>,
  // @ts-expect-error
  Length<5>,
  // @ts-expect-error
  Length<'hello world'>,
]
```
