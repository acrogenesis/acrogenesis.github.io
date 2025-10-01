defmodule AcrogenesisCom.RootLayout do
  use Tableau.Layout
  import AcrogenesisCom

  def template(assigns) do
    ~H"""
    <!DOCTYPE html>

    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />

        <title><%= page_title(assigns) %></title>
        <meta name="description" content="<%= page_description(assigns) %>" />
        <link rel="canonical" href="<%= canonical_url(assigns) %>" />
        <link rel="alternate" type="application/rss+xml" title="<%= site_name() %>" href="<%= rss_url() %>" />

        <meta property="og:site_name" content="<%= site_name() %>" />
        <meta property="og:title" content="<%= page_title(assigns) %>" />
        <meta property="og:description" content="<%= page_description(assigns) %>" />
        <meta property="og:url" content="<%= canonical_url(assigns) %>" />
        <meta property="og:type" content="<%= og_type(assigns) %>" />
        <%= if image = social_image(assigns) do %>
          <meta property="og:image" content="<%= image %>" />
        <% end %>

        <meta name="twitter:card" content="<%= twitter_card(assigns) %>" />
        <meta name="twitter:title" content="<%= page_title(assigns) %>" />
        <meta name="twitter:description" content="<%= page_description(assigns) %>" />
        <meta name="twitter:site" content="@acrogenesis" />
        <%= if image = social_image(assigns) do %>
          <meta name="twitter:image" content="<%= image %>" />
        <% end %>
        <script>
          (function() {
            try {
              var t = localStorage.getItem('theme');
              if (!t) {
                t = (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) ? 'dark' : 'light';
              }
              document.documentElement.setAttribute('data-theme', t);
            } catch (_) {}
          })();
        </script>
        <link rel="stylesheet" href="/css/site.css" />
        <script defer src="/js/site.js"></script>
      </head>

      <body>
        <header class="site-header">
          <div class="container">
            <p class="site-title"><a href="/">acrogenesis.com</a></p>
            <nav class="site-nav" aria-label="Primary">
              <a href="/">home</a>
              <span class="sep" aria-hidden="true">|</span>
              <a href="/archive">archive</a>
              <span class="sep" aria-hidden="true">|</span>
              <a href="/feed.xml">rss</a>
              <span class="sep" aria-hidden="true">|</span>
              <a href="mailto:adrian.rangel@gmail.com">contact</a>
              <span class="sep" aria-hidden="true">|</span>
              <a href="https://x.com/acrogenesis" target="_blank" rel="noopener">𝕏</a>
              <span class="sep" aria-hidden="true">|</span>
              <a href="https://github.com/acrogenesis" target="_blank" rel="noopener">github</a>
              <span class="sep" aria-hidden="true">|</span>
              <button id="theme-toggle" class="theme-toggle" aria-label="Toggle theme">theme: auto</button>
            </nav>
          </div>
        </header>

        <main class="container" id="main-content">
          <%= render @inner_content %>
        </main>

        <footer class="site-footer">
          <div class="container">
            <pre class="ascii">[ acrogenesis :: since 2008 ]</pre>
          </div>
        </footer>
      </body>

      <%= if Mix.env() == :dev do %>
        <%= Tableau.live_reload(assigns) %>
      <% end %>
    </html>
    """
  end
end
