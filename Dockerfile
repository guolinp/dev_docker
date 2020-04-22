FROM golang

MAINTAINER "Guolin"

USER root
RUN apt-get -y update --fix-missing
RUN apt-get -y install gdb vim tree htop astyle graphviz perf

# Tools for code-server to /go/bin
# see https://github.com/microsoft/vscode-go/blob/master/src/goTools.ts
RUN go get -u -v github.com/stamblerre/gocode && ln -sf $GOPATH/bin/gocode $GOPATH/bin/gocode-gomod
RUN go get -u -v github.com/uudashr/gopkgs/cmd/gopkgs
RUN go get -u -v github.com/ramya-rao-a/go-outline
RUN go get -u -v github.com/acroca/go-symbols
RUN go get -u -v golang.org/x/tools/cmd/guru
RUN go get -u -v golang.org/x/tools/cmd/gorename
RUN go get -u -v github.com/fatih/gomodifytags
RUN go get -u -v github.com/haya14busa/goplay
RUN go get -u -v github.com/josharian/impl
RUN go get -u -v github.com/tylerb/gotype-live
RUN go get -u -v github.com/rogpeppe/godef
RUN go get -u -v github.com/zmb3/gogetdoc
RUN go get -u -v golang.org/x/tools/cmd/goimports
RUN go get -u -v github.com/sqs/goreturns
RUN go get -u -v golang.org/x/lint/golint
RUN go get -u -v github.com/cweill/gotests
RUN go get -u -v github.com/golangci/golangci-lint/cmd/golangci-lint
RUN go get -u -v github.com/mgechev/revive
RUN go get -u -v github.com/go-delve/delve/cmd/dlv
RUN go get -u -v github.com/davidrjenni/reftools/cmd/fillstruct
RUN go get -u -v github.com/godoctor/godoctor
RUN go get -u -v github.com/uber/go-torch

# open source
RUN go get -d -v github.com/bitly/go-simplejson
RUN go get -d -v github.com/golang/protobuf/protoc-gen-go

# flame graph
RUN cd / && \
    git clone https://github.com/brendangregg/FlameGraph.git

# vscode
RUN cd / && \
    wget https://github.com/cdr/code-server/releases/download/3.1.1/code-server-3.1.1-linux-x86_64.tar.gz && \
    tar zxvf code-server-3.1.1-linux-x86_64.tar.gz && \
    mv code-server-3.1.1-linux-x86_64 vscode && \
    rm -rf code-server-3.1.1-linux-x86_64.tar.gz

RUN mkdir -p /vscode/data
RUN /vscode/code-server                                      \
        --user-data-dir /vscode/data                         \
        --install-extension ms-vscode.Go                     \
        --install-extension ms-python.python                 \
        --install-extension ms-vscode.cpptools               \
        --install-extension formulahendry.code-runner        \
        --install-extension eamodio.gitlens                  \
        --install-extension coenraads.bracket-pair-colorizer \
        --install-extension windmilleng.vscode-go-autotest   \
        --install-extension defaltd.go-coverage-viewer       \
        --install-extension vscode-icons-team.vscode-icons   \
        --install-extension esbenp.prettier-vscode           \
        --install-extension chiehyu.vscode-astyle


WORKDIR /go

EXPOSE 8080

CMD ["/bin/bash"]
