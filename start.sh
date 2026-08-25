#!/bin/sh

# 只有设置了 SSH_PUBKEY 时才配置和启动 SSH 服务
if [ -n "$SSH_PUBKEY" ]; then
  mkdir -p /root/.ssh /run/sshd /etc/ssh/sshd_config.d
  printf '%s\n' "$SSH_PUBKEY" > /root/.ssh/authorized_keys
  chmod 700 /root/.ssh
  chmod 600 /root/.ssh/authorized_keys 2>/dev/null || true
  cat > /etc/ssh/sshd_config.d/railway.conf <<EOF
Port ${SSH_PORT:-22}
PermitRootLogin yes
PubkeyAuthentication yes
PasswordAuthentication no
AuthorizedKeysFile /root/.ssh/authorized_keys
EOF
  grep -q 'sshd_config.d' /etc/ssh/sshd_config || echo 'Include /etc/ssh/sshd_config.d/*.conf' >> /etc/ssh/sshd_config
  /usr/sbin/sshd || true
fi

exec node index.js
