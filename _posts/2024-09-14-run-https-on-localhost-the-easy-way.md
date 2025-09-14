---
layout: AcrogenesisCom.PostLayout
title: "Run https on localhost the easy way"
slug: "run-https-on-localhost-the-easy-way"
date: "2024-09-14"
author: acrogenesis
comments: true
permalink: /:title/
---
Setting up HTTPS on localhost doesn't have to be a headache. With a few simple steps, you can have a secure local development environment up and running in no time. Here's how:

## 1. Install mkcert

First, we'll use Homebrew to install mkcert, a simple tool for making locally-trusted development certificates:

```bash
brew install mkcert
```

## 2. Set up mkcert

Now, let's set up mkcert on your system:

```bash
mkcert -install
```

This command creates a local certificate authority on your machine.

## 3. Create a certificates folder

We'll create a dedicated folder in your home directory to store the certificates, this will make it easier to run on different projects and domains:

```bash
mkdir ~/.certs
cd ~/.certs
```

## 4. Generate certificates

Generate certificates for localhost:

```bash
mkcert localhost 127.0.0.1 ::1
```

This creates two files in your `.certs` folder: `localhost+2.pem` (the certificate) and `localhost+2-key.pem` (the key).

## 5. Run local-ssl-proxy

Now, we'll use `npx local-ssl-proxy` to run our local server with HTTPS.

```bash
npx local-ssl-proxy --cert ~/.certs/localhost+2.pem --key ~/.certs/localhost+2-key.pem --source 443 --target 4000
```

This command starts a proxy server that will serve your local content over HTTPS. If you're running something on port 4000 you can now see it at [https://localhost](https://localhost)

**Note**: The -`-source` flag specifies the port where the HTTPS server will run, and the `--target` flag specifies the port where your actual application is running.

## Bonus: Custom Domain Names

This method also works for custom domain names. If you want to use a domain like my.x.com, follow these steps:

1. Modify your `/etc/hosts` file (using `sudo vim /etc/hosts`) and add this to the end:

```bash
127.0.0.1 my.x.com
```

2. Generate a certificate for your custom domain:

```bash
cd ~/.cert
mkcert my.x.com
```

3. Run local-ssl-proxy with the new certificate:

```bash
npx local-ssl-proxy --cert ~/.certs/my.x.com.pem --key ~/.certs/my.x.com-key.pem --source 443 --target 4000
```

Now you can access your local site at [https://my.x.com](https://my.x.com)!
