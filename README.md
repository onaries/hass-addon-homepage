# Home Server Dashboard (Homepage)

이 프로젝트는 [gethomepage/homepage](https://github.com/gethomepage/homepage)를 기반으로 한 홈서버 전용 대시보드 설정입니다.

## 시작하기

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

| 카테고리 | 서비스 | 위젯 | 설명 |
|----------|--------|------|------|
| 인프라 관리 | Synology | - | 네트워크 저장소(NAS) |
| 인프라 관리 | Portainer | portainer | 컨테이너 관리 UI |
| 인프라 관리 | Komodo | komodo | 배포 및 패키지 관리 |
| 네트워크 & 보안 | Nginx Proxy Manager | npm | 리버스 프록시 및 SSL 관리 |
| 네트워크 & 보안 | AdGuard Home | adguard | DNS 기반 광고 차단 |
| 네트워크 & 보안 | Uptime Kuma | uptimekuma | 서비스 모니터링 |
| 미디어 & 다운로드 | qBittorrent | qbittorrent | 토렌트 다운로드 클라이언트 |
| 개발 및 스마트홈 | GitHub | customapi | GitHub 프로필 요약 |
| 개발 및 스마트홈 | Home Assistant | homeassistant | 가정용 자동화 플랫폼 |

### 3. 북마크

`config/bookmarks.yaml`에 등록된 바로가기:

| 카테고리 | 항목 |
|----------|------|
| Developer | GitHub |
| Social | Reddit |
| Entertainment | YouTube |
| 생활 | 2026 가계부 (Google Sheets) |

## 설정 가이드

### Home Assistant 애드온 설정

애드온 설정 탭에서 아래 항목들을 입력하면 자동으로 각 위젯에 연동됩니다.

| 설정 필드 | 대상 서비스 | 설명 |
|-----------|------------|------|
| `npm_username` | Nginx Proxy Manager | 로그인 아이디 |
| `npm_password` | Nginx Proxy Manager | 로그인 비밀번호 |
| `portainer_key` | Portainer | API Key |
| `homeassistant_token` | Home Assistant | 장기 보관 토큰 |
| `gitea_token` | Gitea | API 토큰 |
| `synology_username` | Synology | 로그인 아이디 |
| `synology_password` | Synology | 로그인 비밀번호 |
| `uptime_slug` | Uptime Kuma | 상태 페이지 slug |
| `adguard_username` | AdGuard Home | 로그인 아이디 |
| `adguard_password` | AdGuard Home | 로그인 비밀번호 |
| `komodo_url` | Komodo | 인스턴스 내부 URL |
| `komodo_key` | Komodo | API Key (`K-xxxxxx...`) |
| `komodo_secret` | Komodo | API Secret (`S-xxxxxx...`) |
| `qbittorrent_url` | qBittorrent | 웹 UI URL |
| `qbittorrent_username` | qBittorrent | 로그인 아이디 |
| `qbittorrent_password` | qBittorrent | 로그인 비밀번호 |
| `github_token` | GitHub (customapi) | Personal Access Token |

### Docker Compose 환경

`docker-compose.yml`에서 환경변수로 직접 설정합니다. 변수명은 `HOMEPAGE_VAR_` 접두사를 사용합니다.

예시:
```yaml
environment:
  HOMEPAGE_VAR_HA_TOKEN: "your-token-here"
  HOMEPAGE_VAR_KOMODO_URL: "http://192.168.x.x:port"
```

## 폴더 구조

```
.
├── docker-compose.yml          # 컨테이너 실행 설정
├── homepage/
│   ├── Dockerfile              # HA 애드온용 Docker 이미지
│   ├── config.yaml             # HA 애드온 설정 정의
│   ├── run.sh                  # 시작 스크립트 (옵션 → 환경변수 매핑)
│   └── config/                 # 대시보드 설정 파일 (YAML)
│       ├── services.yaml       # 서비스 및 위젯 설정
│       ├── bookmarks.yaml      # 바로가기 링크
│       ├── widgets.yaml        # 시스템 정보 위젯
│       ├── settings.yaml       # 테마 및 언어 설정
│       └── docker.yaml         # Docker 연동 설정 (미사용)
```

## 참고 링크

- [Homepage 공식 문서](https://gethomepage.dev/)
- [지원 아이콘 목록](https://dashboardicons.com/)
- [위젯 설정 가이드](https://gethomepage.dev/configs/services/)
