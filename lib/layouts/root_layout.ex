defmodule AcrogenesisCom.RootLayout do
  use Tableau.Layout
  import AcrogenesisCom

  def template(assigns) do
    ~H"""
    <!DOCTYPE html>

    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta http_equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />

        <title>
          <%= [@page[:title], "acrogenesis.com"]
              |> Enum.filter(& &1)
              |> Enum.intersperse("|")
              |> Enum.join(" ") %>
        </title>
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
        <script src="/js/site.js"></script>
      </head>

      <body>
        <header class="site-header">
          <div class="container">
            <h1 class="site-title"><a href="/">acrogenesis.com</a></h1>
            <nav class="site-nav">
              <a href="/">home</a>
              <span class="sep">|</span>
              <a href="/archive">archive</a>
              <span class="sep">|</span>
              <a href="/feed.xml">rss</a>
              <span class="sep">|</span>
              <a href="mailto:adrian.rangel@gmail.com">contact</a>
              <span class="sep">|</span>
              <a href="https://x.com/acrogenesis" target="_blank" rel="noopener">𝕏</a>
              <span class="sep">|</span>
              <a href="https://github.com/acrogenesis" target="_blank" rel="noopener">github</a>
              <span class="sep">|</span>
              <button id="theme-toggle" class="theme-toggle" aria-label="Toggle theme">theme: auto</button>
            </nav>
          </div>
        </header>

        <main class="container">
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
