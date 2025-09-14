defmodule AcrogenesisCom.PostLayout do
  use Tableau.Layout, layout: AcrogenesisCom.RootLayout
  import AcrogenesisCom

  def template(assigns) do
    ~H"""
    <article class="post">
      <header class="post-header">
        <h1 class="post-title"><%= @page[:title] %></h1>
        <p class="post-meta">
          <%= Calendar.strftime(@page[:date], "%Y-%m-%d") %>
        </p>
        <hr/>
      </header>

      <section class="post-body">
        <%= render @inner_content %>
      </section>

      <%= if @page[:comments] do %>
        <section class="comments">
          <h2>comments</h2>
          <button
            id="comments-toggle"
            class="comments-toggle"
            data-disqus-shortname="bluehats"
            data-disqus-identifier="<%= @page[:permalink] %>"
            data-disqus-title="<%= @page[:title] %>"
            data-disqus-url=""
          >Show comments</button>
          <div id="disqus_thread"></div>
          <noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
        </section>
      <% end %>
    </article>
    """
  end
end
