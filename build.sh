#!/bin/bash

curl http://repos.1c-bitrix.ru/yum/bitrix-env.sh > bitrix-env.sh && \
    /bin/bash ./bitrix-env.sh && \
    rm -f ./bitrix-env.sh

yum -y install bx-push-server