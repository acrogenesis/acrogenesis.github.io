defmodule AcrogenesisCom.HomePage do
  use Tableau.Page,
    layout: AcrogenesisCom.RootLayout,
    permalink: "/"

  import AcrogenesisCom

  def template(assigns) do
    ~H"""
    <section class="intro">
      <p>notes, how-tos, and experiments.</p>
      <hr/>
    </section>

    <section class="projects">
      <h2>projects</h2>
      <ul>
        <li><a href="https://pgorbit.com/" target="_blank" rel="noopener">PG Orbit</a> Desktop-Class PostgreSQL Management in Your Pocket</li>
        <li><a href="https://ajsonviewer.browserutils.com/" target="_blank" rel="noopener">Advanced JSON Viewer</a> Safari Extension for macOS, iOS, and visionOS</li>
        <li><a href="https://acrogenesis.com/macchanger/" target="_blank" rel="noopener">macchanger</a> Change your MAC address easily on macOS</li>
        <li><a href="https://acrogenesis.com/omarchy-cheat-sheet/" target="_blank" rel="noopener">Omarchy Hotkeys</a> Printable cheat-sheet of official <a href="https://omarchy.org/" target="_blank" rel="noopener">Omarchy</a> Hotkeys</li>
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
