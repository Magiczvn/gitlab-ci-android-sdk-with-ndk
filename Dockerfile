FROM ubuntu:16.04
MAINTAINER Tam Nguyen

ENV VERSION_SDK_TOOLS "25.2.3"
ENV VERSION_BUILD_TOOLS "25.0.2"
ENV VERSION_TARGET_SDK "25"
ENV VERSION_ANDROID_NDK "android-ndk-r14b"

ENV SDK_PACKAGES "build-tools-${VERSION_BUILD_TOOLS},android-${VERSION_TARGET_SDK},addon-google_apis-google-${VERSION_TARGET_SDK},platform-tools,extra-android-m2repository,extra-android-support,extra-google-google_play_services,extra-google-m2repository"

ENV ANDROID_HOME "/sdk"
ENV ANDROID_NDK_HOME ${VERSION_ANDROID_NDK}

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${ANDROID_NDK_HOME}

ENV DEBIAN_FRONTEND noninteractive


RUN apt-get -qq update && \
    apt-get install -qqy --no-install-recommends \
      curl \
      html2text \
      openjdk-8-jdk \
      libc6-i386 \
      lib32stdc++6 \
      lib32gcc1 \
      lib32ncurses5 \
      lib32z1 \
      unzip \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm -f /etc/ssl/certs/java/cacerts; \
    /var/lib/dpkg/info/ca-certificates-java.postinst configure

RUN curl -s http://dl.google.com/android/repository/tools_r${VERSION_SDK_TOOLS}-linux.zip > /tools.zip && \
    unzip /tools.zip -d /sdk && \
    rm -v /tools.zip
    
RUN curl -s https://dl.google.com/android/repository/${VERSION_ANDROID_NDK}-linux-x86_64.zip > android-ndk.zip && \
    unzip -q android-ndk.zip && \
    rm -f android-ndk.zip
    
RUN curl -s https://dl.google.com/android/repository/cmake-3.6.3155560-linux-x86_64.zip > cmake.zip && \
    unzip -q cmake.zip -d ${ANDROID_HOME}/cmake && \
    rm -f cmake.zip

RUN mkdir -p $ANDROID_HOME/licenses/ \
  && echo "8933bad161af4178b1185d1a37fbf41ea5269c55" > $ANDROID_HOME/licenses/android-sdk-license \
  && echo "84831b9409646a918e30573bab4c9c91346d8abd" > $ANDROID_HOME/licenses/android-sdk-preview-license

RUN (while [ 1 ]; do sleep 5; echo y; done) | ${ANDROID_HOME}/tools/android update sdk -u -a -t ${SDK_PACKAGES}
