# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1-a3] - 2025-01-25

### Added
- Uptime Kuma 서비스 위젯 추가

### Fixed
- 환경변수 플레이스홀더에 따옴표 추가 (IDE 포매터 호환성)

## [1.0.1-a2] - 2025-01-25

### Added
- `allowed_hosts` 옵션: HOMEPAGE_ALLOWED_HOSTS 환경변수 설정 가능
- `reset_config` 옵션: `true` 설정 시 config 초기화 후 기본값으로 재설정

### Fixed
- 애드온 config 경로 수정 (`addon_config:rw` 사용)
- config 파일이 기본값 대신 커스텀 설정 적용되지 않던 문제 해결

## [1.0.1-a1] - 2025-01-25

### Changed
- 프로젝트 구조 변경: 애드온 파일을 `homepage/` 하위 디렉터리로 이동
- HA 애드온 저장소 형식 준수 (`repository.yaml` 추가)

### Fixed
- `jq` 패키지 누락 문제 해결
- 독립 실행 모드 지원 (HA 외부에서 docker-compose로 테스트 가능)

### CI
- Pre-release 태그 빌드 지원 (`v1.0.1-a1` 형식)
- Pre-release 시 `latest` 태그 업데이트 방지

## [1.0.0] - 2025-01-25

### Added
- Home Assistant Add-on 지원
- Docker Hub 이미지 빌드 및 배포 (GitHub Actions)
- 환경변수 기반 시크릿 관리 (HOMEPAGE_VAR_*)
  - Nginx Proxy Manager (username, password)
  - Portainer (API key)
  - Home Assistant (token)
  - Gitea (token)
  - Synology (username, password)
- Open-Meteo 날씨 위젯
- Pretendard 폰트 적용
- Makefile (up, down, logs, build, push, tag, clean, sync)
- 멀티 아키텍처 지원 (amd64, arm64)

### Services
- Synology NAS
- Portainer
- Komodo
- Nginx Proxy Manager
- AdGuard Home
- Gitea
- Home Assistant

[1.0.1-a3]: https://github.com/onaries/hass-addon-homepage/releases/tag/v1.0.1-a3
[1.0.1-a2]: https://github.com/onaries/hass-addon-homepage/releases/tag/v1.0.1-a2
[1.0.1-a1]: https://github.com/onaries/hass-addon-homepage/releases/tag/v1.0.1-a1
[1.0.0]: https://github.com/onaries/hass-addon-homepage/releases/tag/v1.0.0
