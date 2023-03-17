#FROM rustlang/rust:nightly-alpine
FROM ubuntu
#RUN apk add openssl-dev bash curl musl-dev
RUN bash -c 'apt update && apt -y  install curl  && export RUSTUP_HOME=/opt/.rustup &&  export CARGO_HOME=/opt/.cargo &&  curl https://sh.rustup.rs -sSf >/tmp/rustup &&  sh /tmp/rustup  -y' || true 
RUN echo 'export RUSTUP_HOME=/opt/.rustup && export CARGO_HOME=/opt/.cargo && export PATH="$CARGO_HOME/bin:$PATH"'  >> /etc/profile
RUN /bin/bash -c " source /etc/profile; which cargo"
RUN mkdir /cache /app
WORKDIR /cache
COPY . /cache
RUN /bin/bash -c " source /etc/profile;cd /cache ; mkdir .cargo ;cargo vendor > .cargo/config"

COPY . /app
WORKDIR /
RUN mv /cache/target /cache/.vendor /app
#RUN /bin/bash -c ' curl  --tlsv1.2 -sSf https://sh.rustup.rs > $HOME/.rust_up && bash $HOME/.rust_up -y'
#RUN bash -c 'find $HOME/.rust && ln -s $HOME/.rust/bin/* /usr/bin && ls -h1l $HOME/.rust/bin/'
RUN ls -lh1 /app
WORKDIR /app
RUN bash -c ' source /etc/profile; cargo install webmention --bin webmention --features="cli receive" --path .'
