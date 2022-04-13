# TypeORM 연결

NestJS에서 TypeORM을 연결하는 방법을 정리해보려 한다.

먼저 의존성을 추가해야 한다. 아래의 커맨드를 입력한다. 아래에서는 mariadb와 연결을 시도할 것이다.

`$ npm install --save @nestjs/typeorm typeorm mysql2`

의존성을 추가하면 아래와 같이 `TypeOrmModule`을 `import` 할 수 있다. `TypeOrmModule` 내에는 `forRoot`와 `forRootAsync`(비동기) 내장 매서드가 존재하는데, 이를 `AppModule`에서 `import`해 적용한다.

```jsx
// app.module.ts

import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { TypeOrmModule } from '@nestjs/typeorm';

@Module({
  imports: [
    TypeOrmModule.forRootAsync(TypeOrmConfig),
  ],
  controllers: [AppController],
}
```

매서드 안에는 `option`을 받게 되는데, 자세한 내용은 [https://typeorm.io/#/connection-options](https://typeorm.io/#/connection-options) 공식 문서 링크를 참고하면 된다. 아래와 같이 `config` 내용을 구현했다.

```jsx
// typeorm.config.ts

import { TypeOrmModuleOptions } from '@nestjs/typeorm';
import { ConfigService } from '@nestjs/config';

export const TypeOrmConfig = {
  useFactory: async (
    configService: ConfigService,
  ): Promise<TypeOrmModuleOptions> => ({
    type: 'mysql',
    host: configService.get('DATABASE_HOST'),
    port: +configService.get('DATABASE_PORT'),
    username: configService.get('DATABASE_USERNAME'),
    password: configService.get('DATABASE_PASSWORD'),
    database: configService.get('DATABASE_NAME'),
    synchronize: process.env.NODE_ENV !== 'prod',
    autoLoadEntities: process.env.NODE_ENV !== 'prod',
    logging: process.env.NODE_ENV !== 'prod',
    keepConnectionAlive: true,
    entities: [],
  }),
  inject: [ConfigService],
};
```

위 코드를 보게 되면  `config` 동적 모듈을 사용해 변수를 설정한 것을 볼 수 있다. 해당 모듈을 사용하려면 아래의 의존성을 추가해야 한다. 다음의 커맨드로 설치 가능하다. `$ npm i --save @nestjs/config`

```jsx
// app.module.ts

import { ConfigModule } from '@nestjs/config';

@Module({
  imports: [
    TypeOrmModule.forRootAsync(TypeOrmConfig),
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: process.env.NODE_ENV === 'prod' ? '.env.prod' : '.env.dev',
    }),
  ],
})
```

내장 매서드 `ConfigModule`을 `app.module.ts`에서 생성하고 `forRoot` 내부에 `option`을 설정한다. `isGlobal` 옵션은 환경 변수를 전역에서 사용할 수 있게 해주고, `envFilePath`는 개발 환경에 따라 `.env` 파일 경로를 변경해준다. 이를 `package.json`에서 `"start:dev": "NODE_ENV=dev nest start --watch"` 다음과 같이 설정해 사용할 수 있다.

환경 변수를 사용하려면 아까 위에서 본 것과 같이 `ConfigService`를 `import`하고 `configService.get('변수명')`으로 사용할 수 있다. 



`.env` 파일에는 아래와 같이 작성한다.

```jsx
// .env.dev

DATABASE_HOST=localhost
DATABASE_USERNAME=root
DATABASE_PASSWORD=
DATABASE_NAME=
DATABASE_PORT=3306
```

`DATABASE_TYPE`은 환경 변수로 설정하지 못한다. 환경 변수로 설정하니, `password` 부분에 오류가 발생한다.