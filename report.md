# Отчет по выполнению задачи: Миграции базы данных с использованием Liquibase

## 1. Цель работы
Реализовать механизм миграции базы данных для Spring Boot приложения из задачи «Слой DAO (Data Access Object)» с использованием Liquibase. Перенести логику инициализации схемы и тестовых данных из `schema.sql` в версионируемые SQL-миграции, организовать структуру changelog-файлов и обеспечить автоматическое применение миграций при запуске приложения. Весь рефакторинг выполнен в отдельной feature-ветке `feature-migration-liquidBase`.

## 2. Использованные технологии и инструменты
- **ОС:** Ubuntu (через WSL2) с Docker Engine
- **Среда разработки:** IntelliJ IDEA Community Edition 2025
- **Язык программирования:** Java 17 (OpenJDK 17.0.6_10)
- **Сборщик проектов:** Apache Maven
- **Фреймворк:** Spring Boot 3.5.14
  - `spring-boot-starter-web` — для REST API и Tomcat
  - `spring-boot-starter-jdbc` — для работы с JDBC и `NamedParameterJdbcTemplate`
- **Система миграций БД:** Liquibase 5.0.2 (через `liquibase-core`)
- **База данных:** PostgreSQL 16 (запущена в Docker-контейнере)
- **Драйвер БД:** `org.postgresql:postgresql`
- **Контейнеризация:** Docker Engine (в среде Ubuntu WSL2)
- **Инструменты управления БД:** DBeaver (для визуального проектирования схемы, выполнения SQL-скриптов и отладки запросов)
- **Инструменты тестирования API:** Postman (для отправки HTTP-запросов, проверки параметров и валидации ответов контроллера), `curl`
- **Вспомогательные инструменты:** Qwen (AI-ассистент для генерации boilerplate-кода, отладки синтаксиса SQL/Java, диагностики автоконфигурации Spring Boot и структурирования итогового отчета)

## 3. Выполненные шаги

### 3.1. Создание feature-ветки
В корневой директории проекта выполнена команда:
```bash
git checkout -b feature-migrations-liquidBase
```
Вся дальнейшая разработка велась в изолированной ветке для сохранения работоспособности основной версии.

### 3.2. Добавление зависимости Liquibase
В файл `pom.xml` добавлена зависимость:
```xml
<dependency>
    <groupId>org.liquibase</groupId>
    <artifactId>liquibase-core</artifactId>
</dependency>
```
Версия управляется через `spring-boot-starter-parent`.

### 3.3. Настройка `application.properties`
Обновлён файл конфигурации:
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/postgres
spring.datasource.username=postgres
spring.datasource.password=postgres
spring.liquibase.change-log=classpath:db/changelog/db.changelog-master.yaml
spring.sql.init.mode=never
```
Ключевой момент: `spring.sql.init.mode=never` отключает стандартный механизм `schema.sql`, чтобы избежать конфликта с Liquibase.

### 3.4. Создание структуры миграций
Создана следующая структура директорий:
```
src/main/resources/
└── db/
    └── changelog/
        ├── db.changelog-master.yaml
        └── changes/
            ├── v1.0.0-create-schema-and-tables.sql
            └── v1.0.1-insert-test-data.sql
```

### 3.5. Написание главного changelog-файла
Файл `db.changelog-master.yaml` определяет порядок применения миграций:
```yaml
databaseChangeLog:
  - include:
      file: db/changelog/changes/v1.0.0-create-schema-and-tables.sql
  - include:
      file: db/changelog/changes/v1.0.1-insert-test-data.sql
```

### 3.6. Миграция создания схемы и таблиц
Файл `v1.0.0-create-schema-and-tables.sql` использует формат Liquibase с обязательными комментариями `--changeset` и блоком `--rollback`

### 3.7. Миграция наполнения тестовыми данными
Файл `v1.0.1-insert-test-data.sql`:

### 3.8. Очистка старого кода
Файл `schema.sql` удалён (или переименован в `schema.sql.bak`), чтобы исключить его случайное выполнение.

### 3.9. Сохранение бизнес-логики
Классы `OrderRepository` и `OrderController` остались без изменений — это главное преимущество миграций: Java-код не зависит от способа инициализации БД.

## 4. Проблемы и их решения

8. **Liquibase не запускается после добавления зависимости (ключевая проблема рефакторинга)**
   - **Причина:** В проекте использовался Spring Boot 4.0.6 (новейшая версия 2026 года) с автоматически подтянутым Liquibase 5.0.2. Автоконфигурация `LiquibaseAutoConfiguration` отсутствовала в Positive matches отчёта `CONDITIONS EVALUATION REPORT`, что указывало на несовместимость механизма автоконфигурации Spring Boot 4.x с Liquibase 5.x.
   - **Диагностика:** Включён режим отладки через `logging.level.org.springframework.boot.autoconfigure=DEBUG`. Анализ отчёта CONDITIONS EVALUATION REPORT показал, что `DataSourceAutoConfiguration` работает корректно, но `LiquibaseAutoConfiguration` полностью отсутствует.
   - **Решение:** Понижение версии Spring Boot с 4.0.6 до стабильной 3.5.14 в блоке `<parent>` файла `pom.xml`. После выполнения `mvn clean install -U` и Reload Maven автоконфигурация Liquibase заработала из коробки.

## 5. Чек-лист самопроверки
- Создана отдельная feature-ветка `feature-migration-liquidBase`
- Добавлена зависимость `liquibase-core` в `pom.xml`
- Отключён стандартный механизм `schema.sql` через `spring.sql.init.mode=never`
- Создана структура директорий `db/changelog/changes/`
- Главный файл `db.changelog-master.yaml` корректно ссылается на миграции
- Миграции используют формат Liquibase с комментариями `--changeset` и `--rollback`
- При запуске в логах видны сообщения `Liquibase: Update has been successful`
- В базе данных автоматически создаются таблицы `databasechangelog` и `databasechangeloglock`
- Java-код (Repository, Controller) не потребовал изменений
- API возвращает корректные результаты для существующих клиентов (HTTP 200)
- API возвращает HTTP 404 для несуществующих клиентов
- Код закоммичен и отправлен в удалённый репозиторий GitHub

## 6. Полученные результаты

**Работающий REST API после миграции:**
- `GET /products/fetch-product?name=Kirill` → `Dirol` (HTTP 200)
- `GET /products/fetch-product?name=oleg` → `Orbit` (HTTP 200, нечувствительность к регистру)
- `GET /products/fetch-product?name=Alexey` → `Продукт для пользователя 'Alexey' не найден` (HTTP 404)

**Архитектурные улучшения после перехода на Liquibase:**
- **Версионируемость схемы БД:** каждая миграция имеет уникальный changeset ID, что позволяет отслеживать историю изменений.
- **Идемпотентность:** Liquibase ведёт таблицу `databasechangelog` и не применяет уже выполненные миграции повторно.
- **Возможность отката:** благодаря блокам `--rollback` миграции можно откатывать командой `mvn liquibase:rollback`.
- **Разделение ответственности:** Java-код полностью отделён от логики инициализации БД и не требует изменений при рефакторинге схемы.
- **Командная работа:** миграции можно коммитить в Git, что позволяет всей команде иметь идентичную структуру БД.

**Диагностический опыт:**
- Освоен механизм `CONDITIONS EVALUATION REPORT` для диагностики автоконфигурации Spring Boot.
- Получен практический опыт решения проблем совместимости версий Spring Boot и сторонних библиотек.

## 7. Вывод
В ходе выполнения задачи со звёздочкой были освоены ключевые практики работы с миграциями баз данных:
- Интеграция Liquibase в Spring Boot приложение через `liquibase-core` и автоконфигурацию.
- Организация структуры changelog-файлов с разделением на главный `db.changelog-master.yaml` и отдельные SQL-миграции.
- Использование формата Liquibase SQL с обязательными комментариями `--changeset` и блоками `--rollback`.
- Корректное отключение стандартного механизма `schema.sql` для избежания конфликтов.
- Применение feature-веток в Git для изоляции рефакторинга.
- Глубокая диагностика автоконфигурации Spring Boot через `logging.level.org.springframework.boot.autoconfigure=DEBUG` и анализ CONDITIONS EVALUATION REPORT.
- Решение проблем совместимости версий (Spring Boot 4.0.6 + Liquibase 5.0.2) через понижение до стабильной версии Spring Boot 3.5.14.

Реализованное решение полностью соответствует требованиям задания, демонстрирует профессиональный подход к управлению схемой базы данных и готово к использованию в командной разработке. Приложение сохранило всю функциональность исходной задачи «Слой DAO», но приобрело важнейшее свойство — предсказуемую и версионируемую инициализацию базы данных.
