# System Health Monitor

Bash skripty na monitorovanie zdravia systému — zbiera CPU, RAM a disk, loguje výsledky a upozorní pri prekročení prahovej hodnoty.

## Štruktúra

```
system-health-monitor/
├── monitor.sh      # zbiera metriky a loguje
├── report.sh       # zobrazí súhrn z denného logu
├── logs/           # generované logy (gitignore)
└── README.md
```

## Požiadavky

- `bash`, `awk`, `bc`, `top`, `free`, `df`, `ps`
- `shellcheck` (pre-commit hook)

## Použitie

### monitor.sh

Zbiera CPU, RAM, disk a top 5 procesov. Výsledky zapíše do `logs/health-YYYY-MM-DD.log`.

```bash
./monitor.sh
```

Adresár `logs/` sa vytvorí automaticky.

### report.sh

Zobrazí posledných N riadkov denného logu, počet WARNING/CRITICAL a najhoršiu metriku.

```bash
./report.sh        # posledných 20 riadkov (default)
./report.sh 50     # posledných 50 riadkov
```

## Prahy

| Metrika | WARNING | CRITICAL |
|---------|---------|----------|
| CPU     | > 70%   | > 90%    |
| RAM     | > 80%   | > 95%    |
| Disk    | > 85%   | > 95%    |

## Formát logu

```
[2026-06-09 14:32:01] [INFO]     CPU usage: 12.3%
[2026-06-09 14:32:01] [WARNING]  RAM usage: 83.5%
[2026-06-09 14:32:01] [INFO]     Disk usage: 42%
```

## Automatizácia

Skript beží automaticky každých 5 minút cez cron:

```bash
crontab -e
# pridaj:
*/5 * * * * /cesta/k/system-health-monitor/monitor.sh
```

Aktuálny cron skontroluješ cez:

```bash
crontab -l
```
