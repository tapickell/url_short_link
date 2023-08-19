defmodule GeneratorComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <.form for={@form} phx-change="generate_short_url">
      <.input field={@form[:long_url]} />
    </.form>
    """
  end

  def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
  end
end
