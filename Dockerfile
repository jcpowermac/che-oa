FROM quay.io/openshift/origin-ansible:v3.11
USER 0
# Set permissions on /etc/passwd and /home to allow arbitrary users to write
COPY --chown=0:0 entrypoint.sh /
RUN mkdir -p /home/user && chgrp -R 0 /home && chmod -R g=u /etc/passwd /etc/group /home && chmod +x /entrypoint.sh

# Install common terminal editors in container to aid development process
COPY install-editor-tooling.sh /tmp
RUN /tmp/install-editor-tooling.sh && rm -f /tmp/install-editor-tooling.sh

USER 1001
ENV HOME=/home/user
WORKDIR /projects

RUN timeout 30 sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" || true

RUN (cd ${HOME}; git clone https://github.com/gpakosz/.tmux.git) && \
    (cd ${HOME}; ln -s -f .tmux/.tmux.conf) && \
    (cd ${HOME}; cp .tmux/.tmux.conf.local .)

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["tail", "-f", "/dev/null"]

