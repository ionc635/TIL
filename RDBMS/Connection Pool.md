# Connection Pool

## Connection Pool이란?

사용자의 요청에 따라 Connection을 생성하면 많은 수의 연결이 발생해 서버에 과부하가 걸릴 수 있다. 이 상황을 방지하기 위해 미리 일정 수의 Connection을 만들어 Pool에 담아둔 다음 사용자의 요청이 발생하면 연결해주고 연결 종료 시 Pool에 다시 반환해 보관한다.

## Connection Pool을 사용하는 이유?

DB Connection Pool 매니저는 일정의 Connection을 연결한 뒤에 요청이 들어오면 Connection을 할당해주고, 요청이 들어오지 않으면 기다리도록 한다. 클라이언트가 Connection을 다쓰게 되면 다시 반납하는 구조로 이루어진다. 따라서 통신 속도 성능이 향상된다. 보통의 경우에는 DB에 연결하고 결과를 가져온 후에 close 시킨다. DB에 연결하는 과정은 Cost가 비싼 연산으로 performance가 많이 떨어지는 작업이다. 이러한 문제점을 해결하기 위해 DB Connection pool을 사용하는 것이다. 한번 연결된 DB Connection을 바로 close 시키지 않고 pool에 저장한 뒤에 다음 번에 동일한 Connection을 요청하면 바로 pool에서 꺼내 제공을 함으로써 빠른 DB Connection Time을 보장해 준다.
