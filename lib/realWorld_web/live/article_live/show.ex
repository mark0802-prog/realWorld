defmodule RealWorldWeb.ArticleLive.Show do
  use RealWorldWeb, :live_view

  alias RealWorld.Blogs

  on_mount {RealWorldWeb.CurrentUserAssign, :user}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :comment_changeset, change_comment())}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    article = get_article!(id)
    author_id = article.author_id

    %{
      live_action: action,
      current_user: user
    } = socket.assigns

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

  @impl true
  def handle_event("post_comment", %{"comment" => comment_params}, socket) do
    case create_comment(comment_params, socket) do
      {:ok, _} ->
        article = get_article!(socket.assigns.article.id)

        {:noreply,
         socket
         |> assign(:article, article)
         |> assign(:comment_changeset, change_comment())}

      {:error, changeset} ->
        {:norepl, assign(socket, :comment_changeset, changeset)}
        nil
    end
  end

  defp get_article!(id), do: Blogs.get_article!(id) |> RealWorld.Repo.preload(:comments)

  defp change_comment, do: Blogs.change_comment(%Blogs.Comment{})

  defp create_comment(comment_params, socket) do
    %{
      article: article,
      current_user: user
    } = socket.assigns

    comment_params
    |> Map.put("article_id", article.id)
    |> Map.put("author_id", user.id)
    |> Blogs.create_comment()
  end

  defp page_title(:show), do: "Show Article"
  defp page_title(:edit), do: "Edit Article"
end
