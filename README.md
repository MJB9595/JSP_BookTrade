# UniBookTrade (전공책거래)

대학생을 위한 **중고 전공서적 거래 플랫폼**입니다.  
서적 등록, 검색, 찜하기, 실시간 미니톡(채팅), 알림, 공지사항 등 거래에 필요한 기능을 제공합니다.

## 주요 기능

- **도서 등록 및 관리**  
  이미지 업로드(Cropper.js로 960×1386 비율 자르기), 제목/저자/학과/과목/가격 등 상세 정보 입력, 수정 및 삭제
- **도서 목록 / 검색**  
  키워드 검색, 학과·교수명·학년·과목명을 이용한 상세 검색
- **찜하기(Likes)**  
  관심 도서를 찜 목록에 저장하고 마이페이지에서 확인
- **1:1 채팅 (미니톡)**  
  판매자와 구매자 간 실시간 메시지 교환 (판매완료 시 버튼 비활성화)
- **댓글 / 답글**  
  도서 상세 페이지에서 댓글과 대댓글 작성 및 삭제
- **알림 센터**  
  댓글, 찜, 채팅 등 이벤트 발생 시 사용자에게 알림 전송
- **공지사항 / 이벤트 배너**  
  관리자 등록 공지와 이벤트를 메인 페이지 슬라이더로 표시
- **회원 관리**  
  회원가입(아이디 중복확인 AJAX), 로그인, 프로필 이미지 변경, 마이페이지 대시보드
- **다크 모드 / 라이트 모드**  
  브라우저 설정 또는 수동 전환 지원 (theme.css)
- **반응형 웹**  
  모바일, 태블릿, 데스크톱에 최적화된 UI

## 기술 스택

| 구분          | 사용 기술                                 |
|---------------|------------------------------------------|
| **언어**      | Java (JSP & Servlet), JavaScript         |
| **프레임워크**| 순수 JSP/Servlet (Spring 미사용)          |
| **서버**      | Apache Tomcat 9.0 + JDK 21              |
| **데이터베이스**| MariaDB 10.11                           |
| **컨테이너**  | Docker, Docker Compose                   |
| **프론트엔드**| HTML5, CSS3 (CSS Grid, Custom Properties), Google Material Symbols, Cropper.js |
| **도구**      | phpMyAdmin (DB 관리)                     |

## 프로젝트 구조

```
.
├── compose.yaml              # Docker Compose 설정 (MariaDB + Tomcat + phpMyAdmin)
├── db_data/                  # MariaDB 데이터 디렉토리 (볼륨 마운트)
├── webapps/
│   └── ROOT/                 # Tomcat에 배포되는 웹 애플리케이션 루트
│       ├── assets/           # CSS, 이미지
│       ├── auth/             # 로그인, 회원가입
│       ├── bookviews/        # 도서 등록/수정/상세/목록
│       ├── chat/             # 채팅방
│       ├── includes/         # 공통 header, footer
│       ├── notice/           # 공지사항/이벤트
│       ├── user/             # 마이페이지, 알림
│       └── WEB-INF/
│           ├── classes/      # 컴파일된 서블릿, 필터, 모델, 레포지토리
│           ├── lib/          # mariadb-java-client
│           └── web.xml       # 배포 설정
└── README.md
```

## 빠른 시작 (Docker)

### 사전 요구사항
- [Docker](https://www.docker.com/products/docker-desktop/)
- [Docker Compose](https://docs.docker.com/compose/install/)

### 실행
```bash
# 1. 레포지토리 클론
git clone <repository-url>
cd <repository-folder>

# 2. 컨테이너 실행 (백그라운드)
docker-compose up -d
```

### 접속 정보
- **웹 애플리케이션** → http://localhost:8080/  
- **DB 관리 도구 (phpMyAdmin)** → http://localhost:8081/  
  (서버: `db`, 사용자: `root` / `root1234` 또는 `ubt_user` / `ubt_pass`)
- **테스트 계정** → ID: `student1` , PW: `1234` (로그인 페이지 참고)

### 종료
```bash
docker-compose down
```

## 로컬 개발 (Docker 없이)

1. **MariaDB 설치** 및 `ubt_library` 데이터베이스 생성  
   `compose.yaml` 파일의 환경 변수를 참고하여 계정/비밀번호 설정
2. **Tomcat 9** 설치 (JDK 21 필요)
3. `webapps/ROOT` 디렉토리를 Tomcat의 `webapps/ROOT`로 복사 (또는 WAR로 패키징)
4. `mariadb-java-client-3.5.6.jar`를 `$TOMCAT_HOME/lib` 또는 애플리케이션 `WEB-INF/lib`에 복사
5. Tomcat 실행 후 http://localhost:8080 접속

## 주요 라이선스 / 출처

- **Google Material Symbols** ([Apache 2.0](https://github.com/google/material-design-icons))
- **Cropper.js** ([MIT](https://github.com/fengyuanchen/cropperjs))
- **MariaDB Java Client** ([LGPL 2.1](https://mariadb.com/kb/en/about-the-mariadb-java-client/))
- 기타 CSS/JS는 자체 제작

---

> 이 프로젝트는 대학 커뮤니티 내 **중고 전공서적 거래**를 위해 제작된 교육·실습용 예제입니다.  
> 추가 문의나 개선 제안은 Issue를 통해 남겨주세요.
