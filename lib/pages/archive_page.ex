defmodule AcrogenesisCom.ArchivePage do
  use Tableau.Page,
    layout: AcrogenesisCom.RootLayout,
    permalink: "/archive"

  import AcrogenesisCom

  def template(assigns) do
    ~H"""
    <h2>archive</h2>
    <hr/>
    <section class="archive">
      <%= for {year, year_posts} <- @posts |> Enum.group_by(& &1.date.year) |> Enum.sort_by(fn {y, _} -> y end, :desc) do %>
        <h3><%= year %></h3>
        <ul>
          <%= for post <- year_posts do %>
            <li>
              <span class="date"><%= Calendar.strftime(post.date, "%m-%d") %></span>
              <a href="<%= post.permalink %>"><%= post.title %></a>
            </li>
          <% end %>
        </ul>
      <% end %>
    </section>
    """
  end
end
