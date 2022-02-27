defmodule RealWorldWeb.ArticleLive.Show do
  use RealWorldWeb, :live_view

  alias RealWorld.Blogs

  on_mount {RealWorldWeb.CurrentUserAssign, :user}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    article = Blogs.get_article!(id)
    %{live_action: action, current_user: user} = socket.assigns
    author_id = article.author_id

    if action == :edit && user.id != author_id do
      {:noreply,
       socket
       |> put_flash(:error, "You can't edit this article.")
       |> push_redirect(to: Routes.article_show_path(socket, :show, article))}
    else
      {:noreply,
       socket
       |> assign(:page_title, page_title(socket.assigns.live_action))
       |> assign(:article, article)}
    end
  end

  @impl true
  def handle_event("delete", _value, socket) do
    %{
      article: article,
      current_user: user
    } = socket.assigns

    if article.author_id != user.id do
      {:noreply, put_flash(socket, :error, "You can't delete this article.")}
    else
      {:ok, _} = Blogs.delete_article(article)
      {:noreply, push_redirect(socket, to: Routes.article_index_path(socket, :index))}
    end
  end

  defp page_title(:show), do: "Show Article"
  defp page_title(:edit), do: "Edit Article"
end
