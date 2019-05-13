---
author: acrogenesis
comments: true
date: 2013-09-28 03:03:01+00:00
layout: post
slug: how-to-bypass-api-restrictions
title: How to bypass API restrictions
wordpress_id: 21
categories:
- How-To
---

Don't you hate it when a free API has limits on the number of request you can do? I was hitting the wunderground.com and openexchangerates.org API's limits often. The problem was when we had a traffic spike. We didn't want to pay for premium the same way we don't want to pay extra bandwidth in case of a spontaneous traffic surge. So we came with the idea to cache it. Here's an easy way to ‘cache’ the API's JSON response.

First of all let’s create a shell script (.sh) (I’ll be doing the example for the wunderground API) and add some code (I use VIM, the vim command will create the file)


{% highlight bash %}
vim getWeather.sh
{% endhighlight %}


{% highlight bash %}
#!/bin/bash
cd /home/user/pathto/weatherapi
wget -O http://api.wunderground.com/api/heregoeskey/forecast/lang:SP/q/Mexico/Monterrey.json
{% endhighlight %}


This script works as follows: It goes to the path where you created the getWeather.sh  get’s the json from the API we are trying to bypass restrictions.

Now instead of calling api.wunderground.com on your website call mywebsite.com/pathto/weatherapi/Monterrey.json this will give us the same file but locally bypassing the amounts of calls done to the api server.

Now we need to refresh the file we made locally so for this we make a cronjob, to make a cronjob type


{% highlight bash %}
crontab -e
{% endhighlight %}


This will open the cron editor, just add the following and we should be refreshing our local json every hour


{% highlight bash %}
0 * * * * /home/user/pathto/weatherapi/getWeather.sh
{% endhighlight %}


The api call to the service will only be done every hour instead of every hit on your website. Now we are good to go!

Good luck!
[@acrogenesis](https://twitter.com/acrogenesis)

Thanks [/u/Cixis](http://www.reddit.com/user/Cixis) for some suggestions
