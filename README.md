# README #

## Requirements

 * Ruby 2.5.7
 * redis
    - Install redis
    ```sh
        $ sudo apt-get install redis-server
    ```
    - Start redis server:
    ```sh
     $ redis-server
    ```
 * auzmor_api psql dump

## Setup
### 1. Install RVM  and required ruby
```sh
# install RVM if not installed. (please refer https://rvm.io/ for this).
rvm install 2.5.7
```
### 2. Clone and setup the project
```sh
# clone the repository (git clone path_to_the_repository)
```

### 3. Install dependencies 
```sh
# open project folder in terminal (cd cloned path)
gem install bundle
bundle
```
### 4. Configuration
```sh
mv config/database.yml.example config/database.yml
rake db:create
```
### 5. Load db dump
```sh
psql <db_name>  < dump_schema.sql
```
### 8. Start server 
```sh
rails s
```
## Sample requests
### inbound
```sh
curl --location --request POST 'localhost:3000/inbound/sms' \
--header 'Authorization: Basic YXpyNTo2RExIOEEyNVha' \
--form 'from=3234456667' \
--form 'text=STOP' \
--form 'to=61871112940'
```

### outbound
```sh
curl --location --request POST 'localhost:3000/outbound/sms' \
--header 'Authorization: Basic YXpyNTo2RExIOEEyNVha' \
--form 'from=61871112940' \
--form 'to=21323453221' \
--form 'text=Outbound message'
```