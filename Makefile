# 변수 설정
VOLUME_PATH=${HOME}/data
VOLUME_DIR=wordpress mysql
VOLUME_PATHS=$(addprefix $(VOLUME_PATH)/, $(VOLUME_DIR))
DOCKER_COMPOSE_FILE=./srcs/docker-compose.yml

# 이미지 및 태그 이름 관리
IMAGE_NAMES=nginx wordpress mariadb
TAG_NAME=:inception
IMAGES=$(addsuffix $(TAG_NAME), $(IMAGE_NAMES))

# all: 프로젝트 빌드 및 실행
all: prep
	@docker compose -f $(DOCKER_COMPOSE_FILE) up -d --build

# down: 컨테이너 중지 및 삭제
down:
	@docker compose -f $(DOCKER_COMPOSE_FILE) down

# re: clean 후 재시작
re: clean prep
	@docker compose -f $(DOCKER_COMPOSE_FILE) up -d --build

# clean: 모든 컨테이너, 이미지, 볼륨 및 네트워크 제거
clean:
	@if [ -n "$$(docker ps -qa)" ]; then \
		docker stop $$(docker ps -qa); \
		docker rm $$(docker ps -qa); \
	fi
	@if [ -n "$$(docker images -qa)" ]; then \
		docker rmi -f $$(docker images -qa); \
	fi
	@if [ -n "$$(docker volume ls -q)" ]; then \
		docker volume rm $$(docker volume ls -q); \
	fi
	@docker network ls | tail -n +2 | awk '$$2 !~ /bridge|none|host/' | awk '{ print $$1 }' | xargs -r -I {} docker network rm {}
	sudo rm -rf $(VOLUME_PATHS)

# prep: 볼륨 경로 생성
prep:
	@mkdir -p $(VOLUME_PATHS)

# logs: 도커 로그 출력
logs:
	@docker compose -f $(DOCKER_COMPOSE_FILE) logs -f

# rmImage: 특정 이미지 삭제
rmImage:
	@docker rmi -f $(IMAGES)

# rmVolume: 특정 볼륨 삭제
rmVolume:
	@docker volume rm $(VOLUME_DIR)
	sudo rm -rf $(VOLUME_PATHS)

# .PHONY 설정: 가상 타겟 정의
.PHONY: all down re clean prep logs rmImage rmVolume
