
```
Get:18 http://archive.ubuntu.com/ubuntu bionic-backports/universe amd64 Packages [12.6 kB]
Fetched 13.0 MB in 35s (368 kB/s)
Reading package lists...
W: http://archive.ubuntu.com/ubuntu/dists/bionic/universe/binary-amd64/by-hash/SHA256/ca221e8754c933c636b6c0a344617e3444a7c8cb0982ca97725cda9b7bfe1e6a: Automatically disabled Acquire::http::Pipeline-Depth due to incorrect response from server/proxy. (man 5 apt.conf)
E: Failed to fetch http://archive.ubuntu.com/ubuntu/dists/bionic/multiverse/binary-amd64/by-hash/SHA256/910cb989ed0e55b8c98589881a57730a36f074123991366c0263e61582a0e156  Hash Sum mismatch
   Hashes of expected file:
    - Filesize:185953 [weak]
    - SHA256:910cb989ed0e55b8c98589881a57730a36f074123991366c0263e61582a0e156
    - SHA1:53e443a4f5a28fb91c27ce711a30b9cb2807f026 [weak]
    - MD5Sum:18df22249d6b00a016c03e8e995f8980 [weak]
   Hashes of received file:
    - SHA256:1882c40b2622df18e42bd27233179538eb7a0a3574c47fc0b3bc38cf2ff3dc67
    - SHA1:e494727546ac740d0d27e5b775d3bcae24c160e3 [weak]
    - MD5Sum:aca1129dec3e7002ff47d61a8959ebc5 [weak]
    - Filesize:1343916 [weak]
   Last modification reported: Thu, 26 Apr 2018 17:43:25 +0000
   Release file created at: Thu, 26 Apr 2018 23:37:48 +0000
W: Failed to fetch http://archive.ubuntu.com/ubuntu/dists/bionic/main/binary-amd64/by-hash/SHA256/ff7fd80e902a1acfba06e7b513711da31abe915d95b3ba39ce198e02efd209e5  
E: Failed to fetch http://archive.ubuntu.com/ubuntu/dists/bionic/universe/binary-amd64/by-hash/SHA256/ca221e8754c933c636b6c0a344617e3444a7c8cb0982ca97725cda9b7bfe1e6a  
E: Failed to fetch http://security.ubuntu.com/ubuntu/dists/bionic-security/main/binary-amd64/by-hash/SHA256/e2c39525bac9e74b6a4981b65987b202c703f7717c081511a1d74bd148942226  Hash Sum mismatch
   Hashes of expected file:
    - Filesize:2491610 [weak]
    - SHA256:e2c39525bac9e74b6a4981b65987b202c703f7717c081511a1d74bd148942226
    - SHA1:3f6d8bcd35322aaf4753e58e7dfbc4761168cb2e [weak]
    - MD5Sum:db41ac0f86ebe2dd64066e4cf35253c0 [weak]
   Hashes of received file:
    - SHA256:444b81f124b8ec16a96c5994e20d400b345159c1698d0ad366792131e70757dd
    - SHA1:385ba8a03abd726b1227cc34fc97ccadfefc27c3 [weak]
    - MD5Sum:e9843a200212d68a8c23b385b569d13b [weak]
    - Filesize:715787 [weak]
   Last modification reported: Wed, 05 Jan 2022 10:35:51 +0000
   Release file created at: Tue, 11 Jan 2022 11:44:33 +0000
W: Some index files failed to download. They have been ignored, or old ones used instead.
ERROR: Service 'base-ubuntu-18.04' failed to build: The command '/bin/sh -c apt-get update && apt-get -y upgrade && apt-get install -y     git     locales && apt-get autoremove --yes && apt-get clean --yes' returned a non-zero code: 100
```
googling for `Acquire::http::Pipeline-Depth due to incorrect response from server/proxy`
leads to `http://marc-abramowitz.com/archives/2007/10/29/possible-fix-for-using-apt-through-a-broken-http-proxy/`
Where man `apt.conf` is cited:

```
One setting is provided to control the pipeline depth in cases where the remote server is not RFC conforming or buggy (such as Squid 2.0.2) Acquire::http::Pipeline-Depth can be a value from 0 to 5 indicating how many outstanding requests APT should send. A value of zero MUST be specified if the remote host does not properly linger on TCP connections – otherwise data corruption will occur. Hosts which require this are in violation of RFC 2068.
```

Although not longer in use, this helps also with problems related to ubuntu 20.04.
