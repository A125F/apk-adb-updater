FROM ubuntu:20.04
LABEL Maintainer="Jorenn92"
LABEL Description="Contains the aptoid-adb-updater image"

ENV APP_HOME=/opt/aptoide-adb-updater

RUN groupadd user && \
    useradd -g user user && \
    mkdir -p ${APP_HOME}

COPY    --chown=user:user   *.py                ${APP_HOME}
COPY    --chown=user:user   config.yml          ${APP_HOME}
COPY    --chown=user:user   startUpdater.sh     ${APP_HOME}

RUN set -x && \
    apt-get -y update  && \
    apt-get -y install pip python3  && \
    cd ${APP_HOME} && \
    pip install pyyaml && \
    mkdir -p adb/linux && \
    mkdir cache && \
    cd adb/linux && \
    wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip && \
    unzip -o platform-tools-latest-linux.zip && \
    mv platform_tools/* . && \
    rm -rf platform_tools platform-tools-latest-linux.zip

USER user
ENTRYPOINT ["${APP_HOME}/startUpdater.sh"]