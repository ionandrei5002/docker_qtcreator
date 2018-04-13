FROM ubuntu:16.04

RUN apt update && \
	apt install --no-install-recommends -y build-essential software-properties-common aptitude wget dbus && \
	DEBIAN_FRONTEND=noninteractive apt install -yq keyboard-configuration && \
	add-apt-repository ppa:jonathonf/gcc-7.1 && \
	apt update && \
	apt install --no-install-recommends -y gcc-7 g++-7 valgrind gdm3 cmake ninja-build && \
	update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 50 && \
	update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 50 && \
	update-alternatives --install /usr/bin/cpp cpp /usr/bin/cpp-7 50 && \
	apt install --no-install-recommends -y mesa-utils libgl1-mesa-glx nvidia-340 && \
	rm -rf /var/lib/apt/lists/*
	
RUN groupadd -r andrei -g 1000 && \
	useradd -u 1000 -d /home/andrei -r -g andrei andrei && \
	mkdir -p /home/andrei && \
	echo "andrei:x:1000:1000:andrei,,,:/home/andrei:/bin/bash" >> /etc/passwd && \
	echo "andrei:x:1000:" >> /etc/group && \
	mkdir -p /etc/sudoers.d && \
	echo "andrei ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/andrei && \
	chmod 0440 /etc/sudoers.d/andrei && \
	chown 1000:1000 -R /home/andrei && \
	chmod 777 -R /home/andrei && \
	dbus-uuidgen > /var/lib/dbus/machine-id && \
	wget http://ftp.fau.de/qtproject/archive/qt/5.10/5.10.1/qt-opensource-linux-x64-5.10.1.run && \
	chmod +x qt-opensource-linux-x64-5.10.1.run

RUN echo 'root:admin' | chpasswd
USER andrei
ENV HOME /home/andrei
COPY qt-installer-noninteractive.qs /home/andrei/qt-installer-noninteractive.qs
RUN ./qt-opensource-linux-x64-5.10.1.run -v --platform minimal --script /home/andrei/qt-installer-noninteractive.qs

USER root
RUN rm -f qt-opensource-linux-x64-5.10.1.run && \
	rm /home/andrei/qt-installer-noninteractive.qs
RUN ln -sf /home/andrei/Qt/Tools/QtCreator/bin/qtcreator /usr/bin/qtcreator

USER andrei

CMD /usr/bin/qtcreator