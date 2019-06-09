# BUILD: docker build -t cpasternack/locfg .
# RUN:   docker run -v /path/to/ilo/xml_files:/ilo cpasternack/locfg

FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive
RUN echo "deb-src http://deb.debian.org/debian/ jessie main non-free contrib" >> /etc/apt/sources.list.d/jessie.list

# apt complained about sources, so we sed the sources.list to enable deb-src
RUN sed -i '/^#\sdeb-src /s/^#//' /etc/apt/sources.list
RUN sed -i '/^#\sdeb-src /s/^#//' /etc/apt/sources.list.d/jessie.list
# Required because the validity ran out. This is a hack, and if security was important, you wouldn't
# be doing any of this in the first place without real good mitigations.
RUN touch /etc/apt/apt.conf.d/10no--check-valid-until
RUN echo "Acquire::Check-Valid-Until \"0\";" >> /etc/apt/apt.conf.d/10no--check-valid-until

RUN apt-get update && apt-get install -y \
  perl \
  libio-socket-ssl-perl \
  libsocket6-perl \
  libterm-readkey-perl

RUN apt-get -y build-dep openssl
RUN apt-get -y source openssl
RUN apt-cache show openssl > /openssl-version

#RUN UPVER=$(awk '$1 == "Version:" { split($2,a1,/\-/); print a1[1] }' /openssl-version); \
#  cd openssl-${UPVER}; sed --in-place 's/no-ssl3//g' debian/rules; dpkg-buildpackage -b -us -uc;

# I am explicitly using a version here. I didn't have any luck with the variable in setting 
# the openssl value via a variable.
RUN cd openssl-1.0.1t; sed --in-place 's/no-ssl3//g' debian/rules; dpkg-buildpackage -b -us -uc;

#RUN SSLVER=$(awk '$1 == "Version:" { print $2 }' /openssl-version); \
#  dpkg -i /libssl1.0.0_${SSLVER}_amd64.deb /openssl_${SSLVER}_amd64.deb

# Same as above, explicitly setting. This will probably need fixed.
RUN dpkg -i /libssl1.0.0_1.0.1t-1+deb8u8_amd64.deb /openssl_1.0.1t-1+deb8u8_amd64.deb

ADD locfg.pl /locfg.pl
#ADD . /ilo
VOLUME /ilo
WORKDIR /ilo

ENTRYPOINT ["/locfg.pl"]
CMD ["-h"]

