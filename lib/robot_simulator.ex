defmodule RobotSimulator do
  @moduledoc """
  This module has a function that performs tasks such as creating a single direction and position for the robot,
  validates the direction and position. In addition to a function that simulates a movement from one that was created,
  and finally function that returns the direction and position.
  """
  @directions [:north, :east, :south, :west]
  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`

  ## Examples

  iex> RobotSimulator.create()
  {:north, {0, 0}}

  iex> RobotSimulator.create(:test, {0, 0})
  {:error, "invalid direction"}

  iex> RobotSimulator.create(:east, {3, 2})
  {:east, {3, 2}}
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0, 0}) do
    with {:ok, direction} <- validate_direct(direction),
         {:ok, position} <- validate_position(position) do
      {direction, position}
    end
  end

  # funtion private of validation
  defp validate_direct(direction) when direction in @directions, do: {:ok, direction}
  defp validate_direct(_), do: {:error, "invalid direction"}

  defp validate_position({left, right}) when is_integer(left) and is_integer(right),
    do: {:ok, {left, right}}

  defp validate_position(_), do: {:error, "invalid position"}

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)

  ## Examples

  iex> robot = RobotSimulator.create(:east, {3, 2})
  {:east, {3, 2}}

  iex> RobotSimulator.simulate(robot, "LAAARRRALLLL")
  {:west, {2, 5}}
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    Enum.reduce(String.to_charlist(instructions), robot, &to_move/2)
  end

  defp to_move(_, {:error, _} = error), do: error
  defp to_move(?A, {:north, {x, y}}), do: {:north, {x, y + 1}}
  defp to_move(?A, {:south, {x, y}}), do: {:south, {x, y - 1}}
  defp to_move(?A, {:east, {x, y}}), do: {:east, {x + 1, y}}
  defp to_move(?A, {:west, {x, y}}), do: {:west, {x - 1, y}}

  # function private of move, movement instruction and validation
  defp to_move(interchange, {direction, position}) when interchange in [?L, ?R] do
    current = Enum.find_index(@directions, &(&1 == direction))
    new_direct = Enum.at(@directions, interchange_index(current, interchange))
    {new_direct, position}
  end

  defp to_move(_, _), do: {:error, "invalid instruction"}

  defp interchange_index(current, ?L), do: rem(current + 3, 4)
  defp interchange_index(current, ?R), do: rem(current + 1, 4)

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`

  ## Examples

  iex> robot = RobotSimulator.create(:west, {3, 2})
  {:west, {3, 2}}

  iex> RobotSimulator.direction(robot)
  :west
  """
  @spec direction(robot :: any) :: atom
  def direction(robot) do
    elem(robot, 0)
  end

  @doc """
  Return the robot's position.

  ## Examples

  iex> robot = RobotSimulator.create(:east, {3, 2})
  {:east, {3, 2}}

  iex> RobotSimulator.position(robot)
  {3, 2}
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(robot) do
    elem(robot, 1)
  end
end
