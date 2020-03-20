# PlayerBio

A dummy generator of player profiles written in [Elixir](https://elixir-lang.org/).


## Requirements

- [Elixir](https://elixir-lang.org/) (1.8 or newer)
- [GNU Make](https://www.gnu.org/software/make/)


## Building and Running the Project

The project can be built running `make deps compile`.

By running `make run`, you will start the Elixir interpreter and the `PlayerBio` service will be running in it.


## Configuration

The service listens on port `8080` by default. This behaviour can be changed in `config/config.exs`.


## API

The service exposes the following two endpoints.

### /ping

Meant to be used as a health check. Returns with a `200` response code and the text `pong!` in the response body
if the service is up and running.

```bash
curl -v http://localhost:8080/ping

*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 8080 (#0)
> GET /ping HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/7.54.0
> Accept: */*
>
< HTTP/1.1 200 OK
< cache-control: max-age=0, private, must-revalidate
< content-length: 5
< content-type: plain/text; charset=utf-8
< date: Wed, 31 Jul 2019 12:57:52 GMT
< server: Cowboy
<
* Connection #0 to host localhost left intact
pong!
```

### /player

Generates the profile of an imaginary sports player.

```bash
curl -v http://localhost:8080/ping

*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 8080 (#0)
> GET /player HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/7.54.0
> Accept: */*
>
< HTTP/1.1 200 OK
< cache-control: max-age=0, private, must-revalidate
< content-length: 70
< content-type: application/json; charset=utf-8
< date: Wed, 31 Jul 2019 12:59:52 GMT
< server: Cowboy
<
{
   "sport" : "Tennis",
   "age" : 28,
   "country" : "Spain",
   "name" : "LeBron Williams"
}
```

### /metrics

Returns service-level metrics in a Prometheus-compliant text-based format.

```bash
curl -v http://127.0.0.1:8080/metrics

*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to 127.0.0.1 (127.0.0.1) port 8080 (#0)
> GET /metrics HTTP/1.1
> Host: 127.0.0.1:8080
> User-Agent: curl/7.54.0
> Accept: */*
>
< HTTP/1.1 200 OK
< cache-control: max-age=0, private, must-revalidate
< content-length: 6776
< date: Wed, 31 Jul 2019 13:51:27 GMT
< server: Cowboy
<
# TYPE erlang_vm_memory_atom_bytes_total gauge
# HELP erlang_vm_memory_atom_bytes_total The total amount of memory currently allocated for atoms. This memory is part of the memory presented as system memory.
erlang_vm_memory_atom_bytes_total{usage="used"} 870829
erlang_vm_memory_atom_bytes_total{usage="free"} 21020
# TYPE erlang_vm_memory_bytes_total gauge
# HELP erlang_vm_memory_bytes_total The total amount of memory currently allocated. This is the same as the sum of the memory size for processes and system.
erlang_vm_memory_bytes_total{kind="system"} 40780928
...
```

## License

> Copyright (c) 2019, BlueLabs Software Limited