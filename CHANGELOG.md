# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-25

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

[1.0.0]: https://github.com/ksw8954/homepage-server/releases/tag/v1.0.0
