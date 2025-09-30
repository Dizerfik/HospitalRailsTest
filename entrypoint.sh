#!/bin/bash
set -e

# Ожидаем доступности БД
until bash -c "echo > /dev/tcp/${POSTGRES_HOST:-db}/${POSTGRES_PORT:-5432}" >/dev/null 2>&1; do
  echo "Waiting for postgres..."
  sleep 1
done

# Предотвращаем повторный запуск миграций при hot restart
if [ -f tmp/pids/server.pid ]; then
  rm -f tmp/pids/server.pid
fi

# Выполняем миграции (создаст БД, если надо)
bundle exec rails db:drop db:create db:migrate 2>/dev/null || bundle exec rails db:migrate

exec "$@"
