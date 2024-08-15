# my-scripts

Some personal scripts

## How to choose SSL Library for Nginx

|                    | OpenSSL 1.1 | OpenSSL 3.x | quicTLS 1.1 | quicTLS 3.x | BoringSSL | AWS-LC |
|--------------------|-------------|-------------|-------------|-------------|-----------|--------|
|HTTP/3              |No           |No           |Yes          |Yes          |Yes        |Yes     |
|OCSP Stapling       |Yes          |Yes          |Yes          |Yes          |No         |Yes     |
|Post-Quantum[^1]    |Fork Repo[^2]|Provider[^3] |No           |Provider     |built-in   |built-in|
|Performance         |Good         |Bad[^4]      |Good         |Bad          |Good       |Good    |
|Security            |EOL          |-            |EOL          |-            |-          |-       |

[^1]: https://blog.cloudflare.com/nist-post-quantum-surprise/
[^2]: https://github.com/open-quantum-safe/openssl
[^3]: https://github.com/open-quantum-safe/oqs-provider
[^4]: https://github.com/haproxy/wiki/wiki/SSL-Libraries-Support-Status
