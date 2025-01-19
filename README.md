# sundai-docker-arm

TO build the image 
docker buildx build --platform linux/arm64 -t sundai-docker --load -f Dockerfile .

docker run -it sundai-docker
