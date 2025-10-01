defmodule AcrogenesisCom.HomePage do
  use Tableau.Page,
    layout: AcrogenesisCom.RootLayout,
    permalink: "/"

  import AcrogenesisCom

  def template(assigns) do
    ~H"""
    <section class="intro">
      <p><%= site_tagline() %></p>
      <hr/>
    </section>

    <section class="projects">
      <h2>projects</h2>
      <ul>
        <%= for project <- projects() do %>
          <li>
            <a href="<%= project.url %>" target="_blank" rel="noopener"><%= project.name %></a>
            <span class="project-description"> – <%= project.description %></span>
          </li>
        <% end %>
      </ul>
    </section>

    <section class="post-list">
      <ul>
        <%= for post <- @posts do %>
          <li>
            <span class="date"><%= Calendar.strftime(post.date, "%Y-%m-%d") %></span>
            <a href="<%= post.permalink %>"><%= post.title %></a>
          </li>
        <% end %>
      </ul>
    </section>
    """
  end
end
