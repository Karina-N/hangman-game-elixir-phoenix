defmodule TextClient.Impl.Player do

  @typep game :: Hangman.game
  @typep tally :: Hangman.Type.tally()
  @typep state :: { game, tally }

  @spec start(game) :: :ok
  def start(game) do
    tally = Hangman.tally(game)
    interact({ game, tally })
  end

  @spec interact(state) :: :ok
  def interact({ _game, _tally = %{ game_state: :won } }) do
    IO.puts "Congratulations. You won!"
  end

  def interact({ _game, tally = %{ game_state: :lost } }) do
    IO.puts "Sorry, you lost... the word was #{tally.letters |> Enum.join}"
  end

  def interact({ game, tally }) do
    IO.puts feedback_for(tally)
    IO.puts current_word(tally)
    tally = Hangman.make_move(game, get_guess())
    interact({ game, tally })
  end

  def feedback_for(tally = %{ game_state: :initializing }) do
    "Welcome! I'm thinking of a #{tally.letters |> length} letter word"
  end

  def feedback_for(%{ game_state: :good_guess }), do: "Good guess!"
  def feedback_for(%{ game_state: :bad_guess }) , do: "Bad guess..."
  def feedback_for(%{ game_state: :already_used }), do: "You already tried this letter..."

  def current_word(tally) do
    [
      IO.ANSI.blue_background() <> "Word so far:  #{tally.letters |> Enum.join(" ")}"<> IO.ANSI.reset(),
      IO.ANSI.green() <> " turns left: "<> IO.ANSI.reset(),
      IO.ANSI.yellow() <> " #{tally.turns_left |> to_string}, " <> IO.ANSI.reset(),
      IO.ANSI.green() <> "used so far: "<> IO.ANSI.reset(),
      IO.ANSI.yellow() <> "#{tally.letters_used |> Enum.join(",")} "<> IO.ANSI.reset(),
    ]
  end

  def get_guess() do
    IO.gets("Next letter: ")
    |> String.trim()
    |> String.downcase()
  end
end
