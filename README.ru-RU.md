<h1 align="center">
  <img alt="IDENA Runner Bash Script - fast idena-go network node deployment with possibility of multiple instances installation: 1 user - 1 idena-go node instance" src="https://github.com/ltraveler/ltraveler/raw/main/images/idena-runner-logo.png" width="224px"/><br/>
  🏃 IDENA RUNNER — Запуск, настройка и обновление ИДЕНА, <span style="font-size: 95%; color: gray;">с возможностью установки шаред и мультинод</span>
</h1>

<p align="justify"><b>Установщик Идена</b> в виде bash скрипта. Позволяет устанавить множество нод <b>Idena-Go</b> на ваш сервер в виде простого и понятного мастера с дружественным интерфейсом.</p>

<p align="center"><a href="https://github.com/ltraveler/idena-runner/releases/latest" target="_blank"><img src="https://img.shields.io/badge/версия-v0.2.6-blue?style=for-the-badge&logo=none" alt="последняя версия скрипта idena runner" /></a>&nbsp;<a href="https://wiki.ubuntu.com/FocalFossa/ReleaseNotes" target="_blank"><img src="https://img.shields.io/badge/Ubuntu-18.04(LTS)+-00ADD8?style=for-the-badge&logo=none" alt="Минимальная версия Ubuntu" /></a>&nbsp;<a href="https://github.com/ltraveler/idena-runner/blob/main/CHANGELOG.md" target="_blank"><img src="https://img.shields.io/badge/Сборка-Стабильная-success?style=for-the-badge&logo=none" alt="Последний релиз idena-go" /></a>&nbsp;<a href="https://www.gnu.org/licenses/quick-guide-gplv3.html" target="_blank"><img src="https://img.shields.io/badge/лицензия-GPL3.0-red?style=for-the-badge&logo=none" alt="license" /></a>&nbsp;<a href="https://github.com/ltraveler/idena-runner/blob/main/README.md" target="_blank"><img src="https://img.shields.io/badge/readme-ENGLISH-orange?style=for-the-badge&logo=none" alt="Idena Runner Script" /></a></p>

## 📈 Требования к серверу

**Рекомендации от команды (на ОДНУ ноду):**
* _1 ЦПУ от 2.5 ГГц._
* _2 ГБ ОЗУ._
* _20 ГБ SSD/HDD._
* _Порт от 100 Мбит/сек._
* _Ubuntu 18.04 и выше._

**На период валидации, во избежание перегрузки сервера, на случай оверсейла VPS, можно добавить 1-2 CPU.**

## ❔ Что устанавливается
### Проект Idena состоит из нескольких приложений:

* **_Нода_** (которую мы устанавливаем) — создаёт блоки, занимается майнингом. Обновляется автоматически, с помощью данного скрипта, для бесперебойной работы.
* **_Клиент_** — позволяет взаимодействовать с кошельком, оракулом, делать флипы и проходить валидации через графический интерфейс. Самый простой способ доступа к клиенту — через [официальный веб-интерфейс](https://app.idena.io), также есть [официальное десктопное приложение](https://github.com/idena-network/idena-desktop/releases/latest/) для _Windows_, _MacOS_ и _Linux_.

☆ **Внимание:** для работы веб интерфейса, вам поребуется API ключ (англ. Shared Node API KEY).\
[Приобрести API ключ](https://t.me/ltrvlr) можно у меня (**_первая валидация бесплатная_**), либо в маркет плейсе, при переходе в настройки вашего аккаунта, после авторизации.

## 🚀&nbsp; Запуск `idena_install.sh` (запускать от пользователя с привилегиями root)

Пожалуйста убедитесь, что у вас установлена **ОС Ubuntu 18.04** и выше.
Для установки ноды идена-гоу, используя данный скрипт, вам нужно выполнить 4 простых шага:
* `git clone https://github.com/ltraveler/idena-runner.git`\
**клонируем репозиторий**
* `cd idena-runner`\
**переходим в директорию скрипта**
* `chmod +x idena_install.sh`\
**делаем скрипт исполняемым**
* `./idena_install.sh`\
**запускаем скрипт**

## ✅&nbsp; Возможности скрипта

* Устанавливать несколько нод на одном сервере — **один пользователь** = **одна нода**.
* Импортировать существующие приватные ключи и нодкеи во время процесса установки.
* Автоматически обновлять ноду idena-go crontask задачей.
* Автоматически настраивать порты для **Uncomplicated Firewall** (**UFW**) во время установки ноды.
* Возможность установить `idena-go` как шаред ноду, с указанием всех наиболее важных параметров.

## 🙋&nbsp; Что делает скрипт?

1. Проверяет существует ли сервис idena.service.
2. Создаёт нового пользователя и пароль для запуска демона ноды идена от его имени.
3. Обновляет необходимые пакеты и устанавливает всё необходимое для стабильной работы ноды.
4. Скачивает последнюю версию клиента ноды Idena **или той версии, которая была введена вручную в процессе установки**. Если пользователь ничего не вводит, скачивает самую последнюю версию. [История релизов сервера ноды idena-go](https://github.com/idena-network/idena-go/releases).
5. **Для продвинутых пользователей** — скрипт использует предопределённый разработчиками конфигурационный файл `config.json`. Файл можно редактировать во время процесса установки.
6. Устанавливает и запускает ноду Idena-go на базе конфигурационного файла config.json из репозитория.
7. Заменяет во время установки `private key` и `nodekey` на ваш собственный, если он у вас есть.
8. Создает задание cron для регулярной проверки обновлений для ноды. По умолчанию проверка происходит раз в день. Вы можете установить любую периодичность с помощью языка cron.
9. Создает и запускает демон Idena.
10. Устанавливает и настраивает фаервол для добавления в него всех необходимых портов на основе выставленных номеров портов SSH и IPFS из конфигурационного файла.

### 🏛️&nbsp;  В случае если вы устанавливаете шаред ноду:
1. Скрипт добавляет `--profile=shared` в качестве аргумента для запуска сервиса шаред ноды;
2. Вы можете указать наиболее критичные параметры: `BlockPinThreshold`, `FlipPinThreshold`, `AllFlipsLoadingTime`
   - **Значения по умолчанию:** 
     - `BlockPinThreshold` = `0.3`
     - `FlipPinThreshold` = `1`
     - `AllFlipsLoadingTime` = `7200000000000`

##  ⚙️&nbsp;  Коротко об управлении демоном Idena
Скрипт создаёт демон-сервис который называется idena_$username. Сервис запускается при запуске системы, на стадии начальной инициализации. Таким образом обеспечивая бесперебойную работу ноды.
#### Вы можете его котролировать с помощью следующих команд:
* `service idena_$username status`\
**проверка статуса**
* `service idena_$username restart`\
**перезапуск**
* `service idena_$username stop`\
**остановка демона**
* `service idena_$username start`\
**запуск демона**

*здесь $username это имя пользователя, от которого запускается демон

## ✔️&nbsp; Idena-runner процесс обновления скрипта (требуются привилегии root)

1. Сделайте бэкап приватного ключа (`/home/idena_instance_username/idena-go/datadir/keystore/nodekey`)
2. Сделайте бэкап node api.key (`/home/idena_instance_username/idena-go/datadir/api.key`)
3. Запустите самую последнии версию скрипта Idena Runner и введите имя пользователя от имени которого вы будете ставить сервис idena-go. Имя должно быть тем же, от которого была изначально установлена инстанция idena-runner.
Все файлы будут перезаписаны.
***Внимание:*** **все файлы внутри папки idena-go будут полностью уничтожены**.

## 🗑️&nbsp; Удаление установленной инстанции Idena-go (требуется запуск от пользователя root)

1. `service idena_username stop`\
_остановка демона idena от имени пользователя, инстанцию idena-go которого мы собираемся удалить_
2. `pkill -u username`\
_убиваем все активные процессы, которые принадлежат данному пользователю_
3. `deluser --remove-home username`\
_удаление относящихся к этому пользователю файлов и папок_
4. `rm /etc/cron.d/idena_update_username`\
_удаляем cron задачу, которая была создана для своевременного обновления ноды idena-go_
5. `rm /etc/systemd/system/idena_username.service`\
_удаляем демона idena привязанного к этому пользователю_
6. `systemctl daemon-reload` and `systemctl reset-failed`\
_обновление изменений в systemctl которые мы сделали на предыдущем шаге_
7. `ufw delete allow ipfs_port_number`\
_вам нужно изменить порт ipfs_port_number для ipfs который вы использовали для установки idena-go инстанции. По умолчанию это порт # `40405`_.
8. `sudo visudo`\
_вам нужно найти и удалить строку относящуюся к удаляемому пользователю_

### 🤝&nbsp; Кошелёк для отправки донейшенов

* `0xf041640788910fc89a211cd5bcbf518f4f14d831`

### 🚦&nbsp; Оцените полезность скрипта

* **20 IDNA** — _Отлично, чтобы я делал без твоего скрипта_.
```
dna://send/v1?address=0xf041640788910fc89a211cd5bcbf518f4f14d831&amount=20&comment=%D0%9E%D1%82%D0%BB%D0%B8%D1%87%D0%BD%D0%BE%2C+%D1%87%D1%82%D0%BE%D0%B1%D1%8B+%D1%8F+%D0%B4%D0%B5%D0%BB%D0%B0%D0%BB+%D0%B1%D0%B5%D0%B7+%D1%82%D0%B2%D0%BE%D0%B5%D0%B3%D0%BE+%D1%81%D0%BA%D1%80%D0%B8%D0%BF%D1%82%D0%B0&callback_url=https%3A%2F%2Fgithub.com%2Fltraveler%2Fidena-runner
```

* **10 IDNA** — _Хорошо, скрипт пригодился_.
```
dna://send/v1?address=0xf041640788910fc89a211cd5bcbf518f4f14d831&amount=10&comment=%D0%A5%D0%BE%D1%80%D0%BE%D1%88%D0%BE%2C+%D1%81%D0%BA%D1%80%D0%B8%D0%BF%D1%82+%D0%BF%D1%80%D0%B8%D0%B3%D0%BE%D0%B4%D0%B8%D0%BB%D1%81%D1%8F&callback_url=https%3A%2F%2Fgithub.com%2Fltraveler%2Fidena-runner
```

* [**0 IDNA**](https://t.me/ltrvlr) - _Плохо, сейчас напишу что добавить_.

### ℹ️&nbsp; Другая информация
* Если вы ищете стабильный и надёжный сервис shared нод, вы всегда можете написать мне в личку в мессенджере **Telegram**  [@ltrvlr](https://t.me/ltrvlr)
* Скрипт не проходил проверку на версиях Убунту ниже 20.04

### 🗣️&nbsp; Контактная информация
* **Email** `ltraveler@protonmail.com`
* **Telegram** [@ltrvlr](https://t.me/ltrvlr)

За более подробной информацией о клиенте **idena-go** вы можете обратится к официальному репозиторию [idena-go](https://github.com/idena-network/idena-go) github.
