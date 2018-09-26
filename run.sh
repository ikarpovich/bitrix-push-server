#!/bin/sh

if [[ "$MODE" == "pub" ]]; then
    export PUBLISH_MODE=true
    export ROUTES=$(cat <<-END
        "pub": "/bitrix/pub/",
        "stat": "/server-stat/"
END
)
elif [[ "$MODE" == "sub" ]]; then
    export PUBLISH_MODE=false
    export ROUTES=$(cat <<-END
        "sub": "/bitrix/subws/"
END
)
fi

envsubst </etc/push-server/config.template.json >/etc/push-server/config.json

node server.js --config /etc/push-server/config.json