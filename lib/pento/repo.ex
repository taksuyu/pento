defmodule Pento.Repo do
  use Ecto.Repo,
    otp_app: :pento,
    adapter: Ecto.Adapters.SQLite3
end
