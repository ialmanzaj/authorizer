FROM elixir:1.11
# install build dependencies
#RUN apk add --update git

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force 
RUN mix local.rebar --force

# set build ENV

ENV MIX_ENV=prod

# install mix dependencies

COPY mix.* /app/
RUN mix deps.get --only prod

COPY . /app

RUN mix escript.build

ENTRYPOINT ["./authorizer"]
