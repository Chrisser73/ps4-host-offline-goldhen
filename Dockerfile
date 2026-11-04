FROM alpine/git AS host-source

WORKDIR /work

RUN git clone --depth 1 https://github.com/psx8/psx8.github.io.git www \
    && git clone --depth 1 https://github.com/well0nez/afterglow-web.git www/1400

COPY scripts/ /overlays/scripts/

RUN cd /overlays \
    && sh scripts/customize-afterglow-1400.sh /work/www/1400 \
    && sh scripts/prepare-afterglow-1400.sh /work/www \
    && sh scripts/apply-pspulse-color-overrides.sh /work/www \
    && rm -rf /work/www/.git /work/www/1400/.git

FROM nginx:alpine

COPY default.conf /etc/nginx/conf.d/default.conf
COPY --from=host-source /work/www/ /usr/share/nginx/html/
