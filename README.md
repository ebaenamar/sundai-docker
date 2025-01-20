# sundai-docker-arm

TO build the image 



docker buildx build --platform linux/arm64 -t sundai-docker --load -f Dockerfile .

docker run -it -p 3000:3000 --name sundai-docker sundai-docker
