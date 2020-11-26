defmodule Covid19Web.RecoveredChartComponent do
  @moduledoc false

  use Covid19Web, :live_component

  def mount(socket) do
    {:ok,
     socket
     |> assign(is_log: false)}
  end

  def handle_event("toggle-log-chart", _, socket) do
    {:noreply, socket |> update(:is_log, &Kernel.not/1)}
  end

  defp fmt(%Date{} = date) do
    Timex.format!(date, "%b %d, %Y", :strftime)
  end

  def render(assigns) do
    ~L"""
    <div
    class="card"
    phx-hook="RecoveredChart"
    data-statistics="<%= Jason.encode! @data %>"
    data-log="<%= Jason.encode! @is_log %>">
      <div class="card-content">
        <p class="title is-5 is-uppercase has-text-centered">Recoveries</p>
        <p class="subtitle is-6 is-uppercase has-text-centered has-text-monospace">
          <%= Enum.at(@data, 0).date |> fmt() %> -
          <%= Enum.at(@data, -1).date |> fmt() %>
        </p>
        <div phx-update="ignore">
          <p class="title is-6 is-uppercase has-text-centered">Daily</p>
          <div id="new-recovered-chart" style="height: 150px"></div>
        </div>
        <hr />
        <div phx-update="ignore">
          <p class="title is-6 is-uppercase has-text-centered">Cumulative</p>
          <div id="cumulative-recovered-chart" style="height: 150px"></div>
        </div>

        <p class="has-text-centered has-text-monospace">
          <button
              class="button is-small <%= @is_log && "is-info" || "is-link" %>"
              phx-click="toggle-log-chart" phx-target="<%= @myself %>">
            <%= @is_log && "Show Linear" || "Show Logarithmic" %>
          </button>
        </p>
      </div>
    </div>
    """
  end
end
