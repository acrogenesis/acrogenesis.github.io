---
layout: post
title: "Securing your kubernetes with Cloudflare's Argo tunnel"
slug: 'securing-your-kubernetes-with-cloudflares-argo-tunnel'
# date: "2019-01-19"
author: acrogenesis
comments: true
---

[Argo tunnel](https://www.cloudflare.com/products/argo-tunnel/) is a service which provides a secure tunnel between Cloudflare servers and your kubernetes deployment. This way you can block all access to your kubernetes cluster so it can be protected behind Cloudflare's service, reducing the attack surface and benefiting of the added performance of Argo tunnel.


