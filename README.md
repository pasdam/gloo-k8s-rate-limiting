# gloo-k8s-rate-limiting

Playground to test rate limiting in Gloo Edge OSS running in k8s.

## Usage

To create a k8s cluster using [k3d](https://k3d.io/):

```sh
k3d/create_cluster.sh
```

To deploy all the required components:

```sh
./deploy.sh
```

To test the configuration:

```sh
$ curl localhost:8080/api/pets -v
*   Trying ::1...
* TCP_NODELAY set
* Connected to localhost (::1) port 8080 (#0)
> GET /api/pets HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/7.64.1
> Accept: */*
>
< HTTP/1.1 200 OK
< content-type: application/xml
< date: Wed, 31 Mar 2021 11:43:37 GMT
< content-length: 86
< x-envoy-upstream-service-time: 1
< x-test: hello
< server: envoy
<
[{"id":1,"name":"Dog","status":"available"},{"id":2,"name":"Cat","status":"pending"}]
* Connection #0 to host localhost left intact
* Closing connection 0
```

When performing more than 2 requests per minute the output will be:

```sh
*   Trying ::1...
* TCP_NODELAY set
* Connected to localhost (::1) port 8080 (#0)
> GET /api/pets HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/7.64.1
> Accept: */*
>
< HTTP/1.1 429 Too Many Requests
< x-test: hello
< x-envoy-ratelimited: true
< date: Wed, 31 Mar 2021 11:43:41 GMT
< server: envoy
< content-length: 0
<
* Connection #0 to host localhost left intact
* Closing connection 0
```

## Credits

Thanks to [stevejr](https://github.com/stevejr) for all his support while I was
trying to get this up and running, and all the help in debugging some of the
issues I faced.
