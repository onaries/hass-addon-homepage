# Home Server Dashboard (Homepage)

이 프로젝트는 [gethomepage/homepage](https://github.com/gethomepage/homepage)를 기반으로 한 홈서버 전용 대시보드 설정입니다.

## 🚀 시작하기

### 1. 구동 방법

#### Docker Compose (일반 환경)
Docker와 Docker Compose가 설치되어 있어야 합니다. 터미널에서 아래 명령어를 실행하세요:

```bash
docker compose up -d
```

#### Home Assistant Add-on (HASS 환경)
이 프로젝트를 Home Assistant 애드온으로 직접 추가할 수 있습니다:

1.  Home Assistant 서버의 `/addons` 디렉토리에 이 프로젝트 폴더를 복사합니다. (예: `/config/addons/homepage-server`)
2.  **설정 > 애드온 > 애드온 스토어**로 이동합니다.
3.  우측 상단 메뉴(점 세 개)에서 **애드온 재검색(Check for updates)**을 클릭합니다.
4.  하단에 "Local add-ons" 섹션의 **Homepage Dashboard**를 선택하고 **설치**를 누릅니다.
5.  **설정 파일 관리**: 애드온을 실행하면 Home Assistant의 `/config/homepage` 디렉토리에 모든 설정 파일이 생성됩니다. 이 파일을 수정하여 대시보드를 관리하세요.

*   **접속 주소**: `http://localhost:3000` (또는 서버 IP:3000)

### 2. 현재 설정된 서비스
`config/services.yaml` 파일에 다음 서비스들이 등록되어 있습니다:

-   **Home Assistant**: 스마트 홈 자동화 상태 확인
-   **AdGuard Home**: 네트워크 광고 차단 현황 실시간 모니터링

## ⚙️ 주요 설정 가이드

### API 연동 및 주소 수정
`config/services.yaml` 파일을 열어 다음 항목을 본인의 환경에 맞게 수정해야 정상적으로 데이터가 표시됩니다.

#### Home Assistant
- `url` & `href`: Home Assistant 접속 주소
- `key`: HA 프로필에서 생성한 '장기 보관 토큰'

#### AdGuard Home
- `url` & `href`: AdGuard Home 접속 주소
- `username`: 로그인 아이디
- `password`: 로그인 비밀번호

## 📂 폴더 구조
- `docker-compose.yml`: 컨테이너 실행 설정
- `config/`: 대시보드 설정 파일 (YAML)
  - `services.yaml`: 앱 및 API 연동 설정
  - `widgets.yaml`: 시스템 정보 및 위젯 설정
  - `settings.yaml`: 대시보드 테마 및 언어 설정

## 🔗 참고 링크
- [공식 문서](https://gethomepage.dev/)
- [지원 아이콘 목록](https://dashboardicons.com/)
