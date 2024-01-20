# GenstageDemo2023

## Requirements
  - elixir >= 1.14
  - postgres 

## Installation
  - Install dependencies `mix deps.get`

## Run project
  - without interactive console `mix`
  - with interactive console `iex -S mix`

## Usage
  - To `enqueue` a new `Task`
  ```elixir
  GenstageDemo2023.enqueue(module, function, arguments)

  # Example:
  GenstageDemo2023.enqueue(IO, :inspect, ["this will be logged"])
  ``````
