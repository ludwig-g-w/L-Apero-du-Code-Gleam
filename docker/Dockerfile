FROM erlang:27-alpine

RUN sed -i 's/v[0-9]\+\.[0-9]\+/edge/g' /etc/apk/repositories && \
    apk update && \
    apk upgrade --available

RUN apk add git wget vim gleam

RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
    -t eastwood

EXPOSE 8000

WORKDIR /apero-gleam

CMD [ "tail -f /dev/nul" ]
