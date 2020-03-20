# ---[ build image ]---
FROM elixir:1.9.4-alpine AS build

WORKDIR /app
ADD . .

ARG TARGET_ENV=prod
ENV MIX_ENV=${TARGET_ENV:+-$TARGET_ENV} \
    LANG=C.UTF-8

RUN apk update \
  && apk upgrade \
  && apk add --virtual build-dependencies \
       build-base \
       gcc \
  && mix local.rebar --force \
  && mix local.hex --force

RUN make deps compile && mix release

# ---[ runtime image ]---
FROM elixir:1.9.4-alpine AS runtime

LABEL org.label-schema.description="PlayerBio Application"

ARG TARGET_ENV=prod
ENV MIX_ENV=${TARGET_ENV:+-$TARGET_ENV} \
    LANG=C.UTF-8

WORKDIR /app
COPY --from=build /app/_build/${MIX_ENV}/rel/player_bio .

RUN apk update \
  && apk upgrade --no-cache \
  && apk --no-cache add tini \
  && addgroup -S appgroup \
  && adduser -S appuser -G appgroup \
       --disabled-password \
       --home "$(pwd)" \
       --gecos "" \
       --no-create-home \
  && chown -R appuser: .

EXPOSE 8080

USER appuser
CMD ["/sbin/tini", "--", "./bin/player_bio", "start"]
