# Un service de scans AntiVirus

... qui wrappe ClamAV.

> IMPORTANT: clamd does not currently protect or authenticate traffic coming over the TCP socket, meaning it will accept commands from any source that can reach that socket. Thus, we strongly recommend following best networking practices when setting up your clamd instance. I.e. don’t expose your TCP socket to the Internet.

_c.f._ https://docs.clamav.net/manual/Usage/Scanning.html#daemon

## Contribuer

```shell
# obtenir un environnement contenant les outils nécessaires
nix-shell

# lancer les tests
$ bash_unit tests/*.test.sh
# valide le formattage
$ treefmt
```
