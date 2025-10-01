defmodule AcrogenesisCom do
  @site_name "acrogenesis.com"
  @site_tagline "notes, how-tos, and experiments."

  @projects [
    %{
      name: "PG Orbit",
      url: "https://pgorbit.com/",
      description: "Desktop-class PostgreSQL management in your pocket"
    },
    %{
      name: "Advanced JSON Viewer",
      url: "https://ajsonviewer.browserutils.com/",
      description: "Safari extension for macOS, iOS, and visionOS"
    },
    %{
      name: "macchanger",
      url: "https://acrogenesis.com/macchanger/",
      description: "Change your MAC address easily on macOS"
    },
    %{
      name: "Omarchy Hotkeys",
      url: "https://acrogenesis.com/omarchy-cheat-sheet/",
      description: "Printable cheat-sheet of official Omarchy hotkeys"
    }
  ]

  defmacro sigil_H({:<<>>, opts, [bin]}, _mods) do
    quote do
      _ = var!(assigns)
      unquote(EEx.compile_string(bin, opts))
    end
  end

  def site_name, do: @site_name
  def site_tagline, do: @site_tagline

  def projects, do: @projects

  def site_url do
    Application.get_env(:tableau, :config, [])
    |> Keyword.get(:url, "https://acrogenesis.com")
    |> String.trim_trailing("/")
  end

  def page_title(assigns) do
    page = assigns[:page] || %{}

    case page[:title] do
      nil -> site_name()
      title -> "#{title} | #{site_name()}"
    end
  end

  def page_description(assigns) do
    page = assigns[:page] || %{}
    description = page[:description] || page[:excerpt]

    cond do
      is_binary(description) and String.trim(description) != "" -> String.trim(description)
      true -> site_tagline()
    end
  end

  def canonical_path(assigns) do
    page = assigns[:page] || %{}

    cond do
      path = page[:canonical] -> path
      path = page[:permalink] -> path
      true -> "/"
    end
  end

  def canonical_url(assigns) do
    path = canonical_path(assigns)

    if is_binary(path) and String.starts_with?(path, "http") do
      path
    else
      site_url()
      |> URI.parse()
      |> URI.merge(%URI{path: path})
      |> to_string()
    end
  end

  def rss_url do
    site_url()
    |> URI.parse()
    |> URI.merge(%URI{path: "/feed.xml"})
    |> to_string()
  end

  def og_type(assigns) do
    page = assigns[:page] || %{}

    if page[:date], do: "article", else: "website"
  end

  def social_image(assigns) do
    page = assigns[:page] || %{}

    image = page[:image] || page[:social_image]

    cond do
      is_binary(image) and String.starts_with?(image, "http") ->
        image

      is_binary(image) and image != "" ->
        site_url()
        |> URI.parse()
        |> URI.merge(%URI{path: image})
        |> to_string()

      true ->
        nil
    end
  end

  def twitter_card(assigns) do
    if social_image(assigns), do: "summary_large_image", else: "summary"
  end
end
