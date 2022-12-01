FROM alpine:3.6

RUN apk -U add \
	libusb && \
\
	apk -U add --virtual=build-deps \
	musl-dev \
	gcc \
        g++ \
	make \
	cmake \
	pkgconf \
	git \
	libusb-dev && \
\
	cd / && \
	git clone git://git.osmocom.org/rtl-sdr.git && \
	mkdir -p rtl-sdr/build && \
	cd rtl-sdr/build && \
	cmake ../ -DDETACH_KERNEL_DRIVER=ON && \
	make && \
	make install && \
	cd / && \
	rm -rf /rtl-sdr && \
    apk del --purge build-deps && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/* && \
	addgroup -g 1000 -S user && \
	adduser -G user -u 1000 -s /bin/sh -D user

ADD docker-entrypoint.sh /
RUN chmod 7555 /docker-entrypoint.sh

ENV PORT=1234 \
	RTLTCP_ARGS=""
EXPOSE 1234

VOLUME ["/dev/bus/usb"]

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["rtl-tcp"]

