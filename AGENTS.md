# AGENTS.md — hass-addon-homepage

## Project Overview

Home Assistant 애드온으로 동작하는 [gethomepage/homepage](https://github.com/gethomepage/homepage) 대시보드 설정 프로젝트.
코드 없음 — YAML 설정 + Shell 스크립트 + Dockerfile로 구성. 자체 빌드 산출물은 Docker 이미지(`ksw8954/homepage-dashboard`).

## Architecture

```
.
├── docker-compose.yml              # 로컬 개발용 (standalone)
├── Makefile                        # build/push/up/down 명령
├── repository.yaml                 # HA 애드온 저장소 메타데이터
├── homepage/
│   ├── Dockerfile                  # ghcr.io/gethomepage/homepage:latest 기반
│   ├── config.yaml                 # HA 애드온 옵션 정의 (options + schema)
│   ├── run.sh                      # 엔트리포인트: HA 옵션 → 환경변수 매핑
│   └── config/                     # Homepage YAML 설정 (이미지 빌드 시 config_defaults로 복사)
│       ├── services.yaml           # 서비스 위젯 정의
│       ├── bookmarks.yaml          # 바로가기 링크
│       ├── widgets.yaml            # 정보 위젯 (날씨, 시스템 등)
│       ├── settings.yaml           # 테마, 언어, 프로바이더
│       ├── docker.yaml             # Docker 소켓 연동 (미사용)
│       ├── kubernetes.yaml         # 미사용
│       └── proxmox.yaml            # 미사용
└── .github/workflows/
    └── docker-build.yaml           # v* 태그 push 시 multi-arch 빌드 + Docker Hub push
```

## Build / Run Commands

```bash
# 로컬 개발 (standalone Docker)
make up                  # docker compose up -d
make down                # docker compose down
make logs                # docker compose logs -f

# Docker 이미지 빌드
make build               # config.yaml의 version으로 태그 생성

# Docker Hub 배포
make push                # version + latest 태그 push

# 정리
make clean               # 컨테이너, 볼륨, 로컬 이미지 제거

# 원격 동기화
make sync                # rsync to oracle2 서버
```

### CI/CD

- `.github/workflows/docker-build.yaml`: `v*` 태그 push 시 자동 빌드
- Multi-arch: `linux/amd64`, `linux/arm64`
- Docker Hub: `ksw8954/homepage-dashboard`
- Pre-release 태그(`-`포함)는 `latest` 태그 생략

### 테스트

이 프로젝트에는 자동화된 테스트가 없음. 검증은 다음으로 수행:
1. `make build` — Docker 이미지 빌드 성공 여부
2. `make up` → `http://localhost:3002` 접속하여 대시보드 확인
3. YAML 문법 검증: `yamllint homepage/config/` (선택적)

## 새 서비스 추가 체크리스트

서비스/위젯을 추가할 때 반드시 **3곳을 동시에 수정**:

### 1. `homepage/config/services.yaml` — 위젯 정의
```yaml
- 카테고리이름:
    - 서비스이름:
        icon: 서비스.png
        href: https://외부접속주소
        description: 한글 설명
        widget:
          type: 위젯타입
          url: "{{HOMEPAGE_VAR_서비스_URL}}"
          key: "{{HOMEPAGE_VAR_서비스_KEY}}"
```

### 2. `homepage/config.yaml` — HA 애드온 옵션 등록
```yaml
# options 섹션에 기본값 추가
options:
  서비스_key: ""

# schema 섹션에 타입 추가
schema:
  서비스_key: str?          # str? = optional string
```

### 3. `homepage/run.sh` — 환경변수 매핑
```bash
# jq로 옵션 읽기 (다른 변수들과 같은 블록에)
SERVICE_KEY=$(jq -r '.서비스_key // empty' "$OPTIONS_FILE")

# 환경변수 export (다른 export들과 같은 블록에)
[ -n "$SERVICE_KEY" ] && export HOMEPAGE_VAR_SERVICE_KEY="$SERVICE_KEY"
```

> **주의**: 세 파일 중 하나라도 빠지면 HA 애드온에서 위젯이 동작하지 않음.

## Code Style & Conventions

### YAML

- 들여쓰기: **스페이스 2칸** (탭 사용 금지)
- 문서 시작: `---` 필수
- 주석: 파일 상단에 공식 문서 링크, 인라인 주석은 `#` 뒤 한 칸 공백
- 문자열 따옴표: 환경변수 참조(`{{...}}`)는 반드시 쌍따옴표, 일반 문자열은 따옴표 없이
- 한글 사용: description, label 등 사용자에게 보이는 값은 한글

```yaml
# Good
description: 컨테이너 관리 UI
url: "{{HOMEPAGE_VAR_PORTAINER_KEY}}"

# Bad
description: "컨테이너 관리 UI"    # 불필요한 따옴표
url: {{HOMEPAGE_VAR_PORTAINER_KEY}}  # 따옴표 누락
```

### Shell (run.sh)

- Shebang: `#!/bin/sh` (POSIX sh, bash 아님)
- 변수 읽기: `jq -r '.key // empty'` 패턴 일관 사용
- 환경변수 export: `[ -n "$VAR" ] && export HOMEPAGE_VAR_NAME="$VAR"` 패턴
- 순서: jq 변수 읽기 블록 → export 블록 → config 초기화 → exec

### config.yaml (HA 애드온)

- `options` 섹션: 기본값은 빈 문자열 `""`
- `schema` 섹션: 선택 항목은 `str?` (물음표 = optional)
- 네이밍: `snake_case` (예: `komodo_url`, `qbittorrent_username`)

### 환경변수 네이밍

| 레이어 | 패턴 | 예시 |
|--------|------|------|
| HA 옵션 (config.yaml) | `snake_case` | `komodo_key` |
| run.sh 로컬 변수 | `UPPER_SNAKE` | `KOMODO_KEY` |
| Homepage 환경변수 | `HOMEPAGE_VAR_UPPER_SNAKE` | `HOMEPAGE_VAR_KOMODO_KEY` |
| services.yaml 참조 | `{{HOMEPAGE_VAR_UPPER_SNAKE}}` | `"{{HOMEPAGE_VAR_KOMODO_KEY}}"` |

### Dockerfile

- 베이스 이미지: `ghcr.io/gethomepage/homepage:latest`
- 추가 패키지는 `apk add --no-cache`로 설치
- config/ → `/app/config_defaults/`로 복사 (런타임에 symlink)

## Versioning

- 버전은 `homepage/config.yaml`의 `version` 필드에서 관리
- 형식: semver (`1.0.2-a1` 등, pre-release suffix 허용)
- CI는 `v*` git 태그로 트리거 — `make tag`로 생성
- Pre-release(`-` 포함) 태그는 Docker Hub에서 `latest` 태그 생략

## Common Pitfalls

1. **YAML 따옴표 누락**: `{{...}}` 변수 참조에 따옴표 빠뜨리면 YAML 파싱 에러
2. **run.sh 순서**: jq 읽기와 export를 각각의 블록에 추가 (섞지 않기)
3. **config.yaml schema 누락**: options에만 추가하고 schema에 안 넣으면 HA에서 검증 에러
4. **이미지 리빌드 필요**: config/ 파일 수정 후 `make build` 필요 (이미 배포된 HA 애드온은 `reset_config: true`로 초기화)
