for /f "eol=- delims=" %%a in (container.conf) do set "%%a"
docker pull ubuntu:latest
docker rmi %container%
docker build -t %container% .