#!/bin/sh
  set -e
  mkdir -p /root/.ssh /run/sshd /etc/ssh/sshd_config.d
  [ -n "$SSH_PUBKEY" ] && printf '%s\n' "$SSH_PUBKEY" > /root/.ssh/authorized_keys
  chmod 700 /root/.ssh; chmod 600 /root/.ssh/authorized_keys 2>/dev/null || true
  cat > /etc/ssh/sshd_config.d/railway.conf <<EOF
  Port ${SSH_PORT:-2222}
  PermitRootLogin yes
  PubkeyAuthentication yes
  PasswordAuthentication no
  AuthorizedKeysFile /root/.ssh/authorized_keys
  EOF
  grep -q 'sshd_config.d' /etc/ssh/sshd_config || echo 'Include /etc/ssh/sshd_config.d/*.conf' >> /etc/ssh/sshd_config
  /usr/sbin/sshd
  exec node index.js
