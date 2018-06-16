# vi: set ft=yaml:

docker:
  host:
    enabled: true
    options: {}
    pkgs: [{'docker-ce': '18.03.1~ce-0~ubuntu'}, 'python-docker']
  client:
    enabled: true
    container:
      coredns:
        start: True
        makedirs: False
        restart: always
        image: coredns/coredns:1.1.3
        command: "-conf /Corefile -log"
        ports:
          - 53:53
          - 53:53/UDP
          - 9153:9153
          - 9154:9154
          - 8080:8080
          - 8081:8081
        volumes:
          - /app/config/coredns/Corefile:/Corefile
          - /app/config/coredns/db.jswlabs.com:/db.jswlabs.com
  
