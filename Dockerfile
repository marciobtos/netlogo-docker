FROM java:openjdk-7-jdk

MAINTAINER Lisa Stillwell <lisa@renci.org>
# See https://github.com/NetLogo/NetLogo/wiki/Controlling-API

ENV NETLOGO_HOME /opt/netlogo

# Download and extract NetLogo to /opt/netlogo.
# RUN wget https://ccl.northwestern.edu/netlogo/5.2.0/netlogo-5.2.0.tar.gz && \
	# tar xzf netlogo-5.2.0.tar.gz && \
	# rm netlogo-5.2.0.tar.gz && \
	# mv netlogo-5.2.0 $NETLOGO_HOME
RUN wget https://ccl.northwestern.edu/netlogo/5.3.1/NetLogo-5.3.1-64.tgz && \
	tar xzf NetLogo-5.3.1-64.tgz && \
	rm NetLogo-5.3.1-64.tgz && \
	mv netlogo-5.3.1-64 $NETLOGO_HOME

ADD ./netlogo-headless.sh $NETLOGO_HOME/
RUN chmod 755 $NETLOGO_HOME/netlogo-headless.sh

# Download NetLogo extensions:
# R extension
#RUN wget "http://phoenixnap.dl.sourceforge.net/project/r-ext/v1.4 for NetLogo 5.3 and R3.2 and later/r_v1.4_for_NL5.3_R3.2_and_higher.zip" && \
RUN wget "https://iweb.dl.sourceforge.net/project/r-ext/v1.4 for NetLogo 5.3 and R 3.2 and later/r_v1.4_for_NL5.3_R3.2_and_higher.zip" && \
	unzip r_v1.4_for_NL5.3_R3.2_and_higher.zip -d $NETLOGO_HOME/extensions && \
	rm r_v1.4_for_NL5.3_R3.2_and_higher.zip

# pathdir extension
RUN wget https://github.com/cstaelin/Pathdir-Extension/archive/v2.0.0.zip && \
	unzip v2.0.0.zip && \
	cd Pathdir-Extension-2.0.0 && \
	unzip pathdir.zip -d $NETLOGO_HOME/extensions && \
	cd / && \
	rm -rf v2.0.0.zip Pathdir-Extension-2.0.0

# Install R
RUN useradd docker \
	&& mkdir /home/docker \
	&& chown docker:docker /home/docker \
	&& addgroup docker staff

RUN apt-get update \ 
	&& apt-get install -y --no-install-recommends \
		ed \
		less \
		locales \
		vim-tiny \
		wget \
		ca-certificates \
		fonts-texgyre \
	&& rm -rf /var/lib/apt/lists/*

## Configure default locale, see https://github.com/rocker-org/rocker/issues/19
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& locale-gen en_US.utf8 \
		&& /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

## Use Debian unstable via pinning -- new style via APT::Default-Release
RUN echo "deb http://http.debian.net/debian sid main" > /etc/apt/sources.list.d/debian-unstable.list \
	&& echo 'APT::Default-Release;' > /etc/apt/apt.conf.d/default

#ENV R_BASE_VERSION 3.4.0
ENV R_BASE_VERSION 3.4
ENV R_HOME /usr/lib/R
ENV JRI_HOME /usr/local/lib/R/site-library/rJava/jri
ENV R_LIBS /usr/lib/R/library:/usr/lib/R/site-library:/usr/local/lib/R/site-library
ENV R_LIBS_SITE /usr/lib/R/library:/usr/lib/R/site-library:/usr/local/lib/R/site-library
ENV R_LIBS_USER /usr/lib/R/library:/usr/lib/R/site-library:/usr/local/lib/R/site-library

## Now install R and littler, and create a link for littler in /usr/local/bin
## Also set a default CRAN repo, and make sure littler knows about it too
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		littler \
		r-cran-littler \
		r-base=${R_BASE_VERSION}* \
		r-base-dev=${R_BASE_VERSION}* \
		r-recommended=${R_BASE_VERSION}* \
	&& echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site \
	&& echo 'source("/etc/R/Rprofile.site")' >> /etc/littler.r \
	&& ln -s /usr/share/doc/littler/examples/install.r /usr/local/bin/install.r \
	&& ln -s /usr/share/doc/littler/examples/install2.r /usr/local/bin/install2.r \
	&& ln -s /usr/share/doc/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
	&& ln -s /usr/share/doc/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
	&& ln -s /usr/lib/jvm/java-7-openjdk-amd64 /usr/lib/jvm/default-java \
	&& install.r docopt \
	&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
	&& rm -rf /var/lib/apt/lists/*

# install package rJava
RUN /usr/local/bin/install.r rJava bnlearn readr

# For debugging
#CMD ["/bin/bash"]

ENTRYPOINT ["/opt/netlogo/netlogo-headless.sh"]
