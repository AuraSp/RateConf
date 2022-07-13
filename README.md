# Rateconf OCR
Data Entry Project

**This repository is the copy  of the original one. All the credits goes to the 'UAB' GP Transco contributors, who developed this project with me**

## About
This repo contains API(rateconfocr) for extracting rate confirmation document information from pdfs and web client(frontend) for testing it.

Web API uses [AWS Textract](https://aws.amazon.com/textract/) api to extract key value pair, table and text data from the pdf.


## Clone the repository

```shell
git clone git@github.com:GPTransco/rateconfocr.git
```
## Install

## Rails web API

### Check your Ruby version

```shell
ruby -v
```

The ouput should start with something like `ruby 3.1.0`

If not, install the right ruby version using [rbenv](https://github.com/rbenv/rbenv) (it could take a while):

```shell
rbenv install 3.1.0
```

### Install dependencies

Using [Bundler](https://github.com/bundler/bundler)

```shell
cd server
bundle
```

### Initialize the database

```shell
cd server
rails db:create db:migrate db:seed
```

### Create HMAC key for encrypting API tokens in the database
```shell
cd server
export API_KEY_HMAC_SECRET_KEY=testHmacSecret
```

### Create test user and assign API token to it
```shell
cd server
rails console
User.create! name: "TestUser"
u = User.last
u.api_keys.create! token: "gg"
```

### Serve

```shell
cd server
foreman start -f Procfile.dev
```
## Frontend web client
You will need `node` and `npm` installed globally on your machine.  

### Installation:

```shell
cd frontend
npm install
```

### To Start Server:

```shell
cd frontend
npm start
```
