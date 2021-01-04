# Authorizer

Authorizer is an app that authorizes a transaction for a specific account following a set of predefined rules.

## How to run

```bash
docker build -t authorizer .
docker run -i authorizer
```

# Technical specifications

Authorizer was developed using Elixir because it's dynamic, functional language designed for building scalable and maintainable applications. It's known for running low-latency, distributed and fault-tolerant systems.

## Components

- **Authorizer API** to perform actions when incoming input is comming and manage the account state. It's main responsibility are:
- Receive incoming parsed input to perform actions.
- Manage the state of the app when an event happen.

  _It uses a GenServer. A Genserver is process can hold and manage state, but it can also perform calculations, wait for completion, process incoming messages, and do things completely on it’s own. It runs as a separate process (on the BEAM virtual machine, not the OS), so it is often used to handle non-blocking processing of things._

- **AccountValidator API** to validate all the account creation rules.
- **TransactionValidator API** to validate all the transaction authorization rules.
- **ReaderStream API** to read and listen new incoming data from stdin.

## Credits

Authorizer was developed and maintained by Isaac Almanza. You can stay in touch at isaac.almanza19@gmail.com.
