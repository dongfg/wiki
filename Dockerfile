FROM python:alpine AS builder
COPY . /usr/src/app
WORKDIR /usr/src/app
ENV TZ=Asia/Shanghai
RUN pip install simiki
RUN simiki g

FROM alpine
COPY --from=builder /usr/src/app/output /app
ENTRYPOINT ["printf", "copy files in /app to host:\ndocker cp <container-id/name>:/app your-dir\n"]