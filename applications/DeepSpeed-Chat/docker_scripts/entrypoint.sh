#!/bin/bash

# Change the container's SSH port to that specified by the env var SSH_PORT
sed -i "s/^#Port 22/Port $SSH_PORT/" /etc/ssh/sshd_config
echo "Set SSHD to port $SSH_PORT"

# Copy SSH keys from mounted directory if present and not already set up
# Change permissions to root
if [ -d /tmp/host_ssh ]; then
    echo "Copying SSH keys from /tmp/host_ssh to /root/.ssh..."
    mkdir -p /root/.ssh
    cp -r /tmp/host_ssh/* /root/.ssh/
    chown -R root:root /root/.ssh
    chmod 700 /root/.ssh
    chmod 600 /root/.ssh/id_rsa /root/.ssh/authorized_keys
    touch /root/.ssh/config
    chmod 600 /root/.ssh/config
    echo "StrictHostKeyChecking no" > /root/.ssh/config && \
    echo "UserKnownHostsFile=/dev/null" >> /root/.ssh/config && \
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys && \
    echo "Finished SSH setup..."
fi

# Start SSHD
/usr/sbin/sshd

# Prevent container from exiting
tail -f /dev/null

