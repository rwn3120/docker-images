FROM radowan/debian-base:latest
LABEL maintainer="radowan <radek.strejc@gmail.com>"

# default arguments
ARG DEBIAN_FRONTEND=noninteractive

# retrieve new lists of packages & install utils
RUN apt-get update \
    && apt-get install -y \
        vim-tiny wget curl telnet mc openssh-client


# default command
CMD ["/bin/bash"]
