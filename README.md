# docker-backup
Backup docker service using backup gem

## Available ENV variables

| Variable  | Description  | Default  |
|---|---|---|
| `DATABASE_URL`  | URL of a postgres database to be backuped. Ex.: `postgres://postgres@database:5432/postgres` | `nil` |
| `FREQUENCY`  | How often clockwork should run the job (ex: `1.day`) | `1.day` |
| `FREQUENCY_AT`  | At which hour clockwork should perform the backup (ex: `03:00`) | `nil` |
| `NOTIFIER_SLACK`  | Enables slack notifier | `false` |
| `NOTIFIER_SLACK_ON_SUCCESS`  | Send success notifications | `false` |
| `NOTIFIER_SLACK_ON_WARNING`  | Send warning notifications | `false` |
| `NOTIFIER_SLACK_ON_FAILURE`  | Send failure notifications | `false` |
| `NOTIFIER_SLACK_WEBHOOK_URL`  | Slack webhook url | `nil` |
