defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, reset_game(socket)}
  end

  def render(assigns) do
    ~H"""
      <h1 class="mb-4 text-4xl font-extrabold">
        Your score: <%= @score %>
      </h1>
      <h2>
        <%= @message %> It's <%= @time %>
      </h2>
      <br />
      <h2>
        <%= if @correct_number == @guess do %>
          <div class="pb-8">
            Congratulations!
            <.link
              patch="#"
              class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
            >
              Play again?
            </.link>
          </div>
        <% end %>

        <div>
          <%= for n <- @range do %>
            <.link
              href="#"
              class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
              phx-click="guess"
              phx-value-number={n}
            >
              <%= n %>
            </.link>
          <% end %>
        </div>
      </h2>
    """
  end

  def assign_time(socket) do
    assign(socket, time: DateTime.utc_now() |> to_string())
  end

  def assign_correct_number(socket) do
    assign(socket, correct_number: Enum.random(socket.assigns.range))
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    guess_int = String.to_integer(guess)

    changes =
      if socket.assigns.correct_number != guess_int do
        [
          message: "Your guess: #{guess}. Wrong. Guess again.",
          score: socket.assigns.score - 1
        ]
      else
        [message: "Your guess: #{guess}. You are correct!"]
      end

    {
      :noreply,
      assign(socket, changes)
      |> assign(:guess, guess_int)
      |> assign_time()
    }
  end

  def reset_game(socket) do
    assign(socket, score: 0, message: "Make a guess:", range: 1..10, guess: 0)
    |> assign_time()
    |> assign_correct_number()
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, reset_game(socket)}
  end
end
