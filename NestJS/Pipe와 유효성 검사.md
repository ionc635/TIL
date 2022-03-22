# 파이프와 유효성 검사

### 파이프 Pipe

파이프는 요청이 라우터 핸들러로 전달되기 전에 요청 객체를 변환할 수 있는 기회를 제공한다. 미들웨어와 역할이 비슷하지만 애플리케이션의 모든 컨텍스트에서 사용할 수는 없다. 미들웨어는 현재 요청이 어떤 핸들러에서 수행되는지, 어떤 파라미터를 가지고 있는지에 대한 실행 컨텍스트를 알지 못하기 때문이다.

파이프는 보통 두 가지 목적을 가진다.

1. 변환(Transfomation): 입력 데이터를 원하는 형식으로 변환
2. 유효성 검사(Validation): 사용자가 정한 기준에 유효하지 않은 데이터를 예외 처리

@nest/common 패키지에는 내장 파이프가 존재한다. 이는 전달된 인자의 타입을 검사하는 용도이다.

- `ValidationPipe`
- `ParseIntPipe`
- `ParseBoolPipe`
- `ParseArrayPipe`
- `ParseUUIDPipe`
- `DefaultValuePipe`

`users/user/:id` 엔드포인트에 전달된 경로 파라미터 id는 문자열 타입입니다. 이를 내부에서는 정수로 사용하고 있다면, 컨트롤러에서 매번 id 값을 정수형으로 변환해야 하는데 이는 불필요한 작업입니다. 아래와 같이 `@Param` 데코레이터의 두번째 인자로 파이프를 넘겨 현재 실행 컨텍스트에 바인딩할 수 있다.

```jsx
@Get(':id')
findOne(@Param('id', ParseIntPipe) id: number) {
  return this.usersService.findOne(id);
}
```

```jsx
$ curl http://localhost:3000/users/WRONG
{
  "statusCode": 400,
  "message": "Validation failed (numeric string is expected)",
  "error": "Bad Request"
}
```

id에 정수로 파싱 가능하지 않은 문자를 전달한다면 유효성 검사 에러가 발생하면서 에러 응답이 반환된다. 또한 요청은 컨트롤러에 전달되지 않는다. 

클래스를 전달하지 않고 파이프 객체를 직접 생성해 전달할 수도 있다. 이 경우에는 생성할 파이프 객체의 동작을 원하는 대로 바꾸고자할 때 사용한다. 

```jsx
@Get(':id')
findOne(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.NOT_ACCEPTABLE })) id: number) {
  return this.usersService.findOne(id);
}

$ curl http://localhost:3000/users/WRONG
{
  "statusCode": 406,
  "message": "Validation failed (numeric string is expected)",
  "error": "Not Acceptable"
}
```

DefaultValuePipe는 인자의 값에 기본값을 설정할 때 사용한다. 쿼리 파라미터가 생략된 경우 유용하게 사용할 수 있다. 파라미터를 생략하지 않고 null이나 undefined를 전달하면 예외가 발생하기도 한다.

### 커스텀 파이프

커스텀 파이프는 `PipeTransform` 인터페이스를 상속받은 클래스에 `@Injectable` 데코레이터를 붙여주면 된다.

```jsx
import { PipeTransform, Injectable, ArgumentMetadata } from '@nestjs/common';

@Injectable()
export class ValidationPipe implements PipeTransform {
  transform(value: any, metadata: ArgumentMetadata) {
    console.log(metadata);
    return value;
  }
}
```

`PipeTransform`의 원형은 아래와 같이 정의되어 있다.

```jsx
export interface PipeTransform<T = any, R = any> {
    transform(value: T, metadata: ArgumentMetadata): R;
}
```

구현해야 하는 transform 함수는 2개의 매개변수를 가지고 있다.

- value: 현재 파이프에 전달된 인자
- metadata: 현재 파이프에 전달된 인자의 메타데이터

ArgumentMetadata의 정의는 아래와 같다.

```jsx
export interface ArgumentMetadata {
  readonly type: Paramtype;
  readonly metatype?: Type<any> | undefined;
  readonly data?: string | undefined;
}

export declare type Paramtype = 'body' | 'query' | 'param' | 'custom';
```

- type: 파이프에 전달된 인자가 본문(body)인지, 쿼리인지, 파라미터(경로 파라미터)인지 아니면 커스텀 파라미터인지 나타낸다.
- metatype: 라우트 핸들러에 정의된 인자의 타입을 알려준다. 핸들러에서 타입을 생략하거나 바닐라 자바스크립트를 사용하면 undefined가 된다.
- data: 데코레이터에 전달된 문자열. 즉, 파라미터의 이름이다.

예를 들어, 유저 정보를 가져오는 라우터 핸들러를 아래과 같이 구현하면

```jsx
@Get(':id')
findOne(@Param('id', ValidationPipe) id: number) {
  return this.usersService.findOne(id);
}
```

`GET /users/1` 요청에 대해 transform 함수에 전달되는 인자의 value는 1, metadata는 아래와 같은 객체가 된다. `{ metatype: [**Function**: **Number**], **type**: '**param**', **data**: '**id**' }`

### ****유효성 검사 파이프****

유효성 검사를 위해서는 아래의 라이브러리를 설치한다. 

`$ npm i --save class-validator class-transformer`

아래와 같이 사용할 수 있고, 이외의 다양한 데코레이터는 아래의 공식 문서를 통해 적용해 볼 수 있다.

```jsx
import { IsString, MinLength, MaxLength, IsEmail } from 'class-validator';

export class CreateUserDto {
  @IsString()
  @MinLength(1)
  @MaxLength(20)
  name: string;

  @IsEmail()
  email: string;
}
```

[https://github.com/typestack/class-validator](https://github.com/typestack/class-validator)

```jsx
import { PipeTransform, Injectable, ArgumentMetadata, BadRequestException } from '@nestjs/common';
import { validate } from 'class-validator';
import { plainToClass } from 'class-transformer';

@Injectable()
export class ValidationPipe implements PipeTransform<any> {
  async transform(value: any, { metatype }: ArgumentMetadata) {
    if (!metatype || !this.toValidate(metatype)) {
      return value;
    }
    const object = plainToClass(metatype, value);
    const errors = await validate(object);
    if (errors.length > 0) {
      throw new BadRequestException('Validation failed');
    }
    return value;
  }

  private toValidate(metatype: Function): boolean {
    const types: Function[] = [String, Boolean, Number, Array, Object];
    return !types.includes(metatype);
  }
}
```

class-transformer의 plainToClass 함수를 통해 순수(plain 또는 literal) 자바 스크립트 객체를 클래스의 객체로 바꿔주는 역할을 한다. 네트워크 요청을 통해 들어온 데이터는 역직렬화 과정에서 본문의 객체가 아무런 타입 정보도 가지고 있지 않기 때문에 타입을 지정하는 변환 과정을 plainToClass로 수행하는 것이다(?)

적용은 아래와 같이 할 수 있다.

```jsx
@Post()
create(@Body(ValidationPipe) createUserDto: CreateUserDto) {
  return this.usersService.create(createUserDto);
}
```

ValidationPipe를 모든 핸들러에 각각 지정하지 않고 전역으로 설정하려면 부트스트랩 과정에서 적용할 수 있다.

```jsx
import { ValidationPipe } from './validation.pipe';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.useGlobalPipes(new ValidationPipe())
  await app.listen(3000);
}
bootstrap();
```