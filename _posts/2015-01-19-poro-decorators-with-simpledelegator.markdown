---
layout: AcrogenesisCom.PostLayout
title: "PORO decorators with SimpleDelegator"
slug: 'poro-decorators-with-simpledelegator'
date: "2015-01-19"
author: acrogenesis
comments: true
permalink: /:title/
---

An easy and __PORO__ way to create decorators is using ruby's
[SimpleDelegator](http://ruby-doc.org/stdlib-2.2.0/libdoc/delegate/rdoc/SimpleDelegator.html).

### SimpleDelegator

> A concrete implementation of Delegator, this class provides the means to delegate
all supported method calls to the object passed into the constructor and even
to change the object being delegated to at a later time with #\_\_setobj__.

I like the decorators to behave like they are the class that's been decorated. To acheive this
let's create a class `Decorator` which inherits from `SimpleDelegator`.

```ruby
class Decorator < SimpleDelegator
  def component
    @component ||= __getobj__
  end

  def class
    component.class
  end
end

```

As you can see we created the method `component` which will return the object it's decorating
and the method `class` which will return the component class.

Now let's create a `UserDecorator` that inherits from `Decorator`.

```ruby
class UserDecorator < Decorator
  def pirate_name
    "Ahoy! #{first_name}"
  end
end
```

Great! But how do we use this decorator?

```ruby
decorated_user = UserDecorator.new(current_user)
decorated_user.pirate_name # => Ahoy! Adrian
```

So decorating objects allows you to avoid having view logic on your model.
