# vi: set ft=yaml:

docker:
  host:
    enabled: true
    options: {}
    pkgs: [{'docker-ce': '18.03.1~ce-0~ubuntu'}, 'python-docker']
    {%- if grains.os == 'Raspbian' %}
    service: docker
    {%- endif %}
  client:
    enabled: true
    container:
      kea-dhcp:
        start: True
        restart: always
        required_containers: coredns
        image: jweinstock/kea-dhcp:1.4.0
        makedirs: False
        network_mode: host
        ports:
          - 67:67
          - 67:67/UDP
        volumes:
          - /app/config/kea-dhcp/kea-dhcp4.conf:/usr/local/etc/kea/kea-dhcp4.conf
          - /app/config/kea-dhcp/hosts-hook.sh:/usr/local/etc/kea/hosts-hook.sh
        volumes_from:
          - coredns
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
          - hostfile:/app/config/shared/hostsfile
          - /app/config/coredns/Corefile:/Corefile
          - /app/config/coredns/db.jswlabs.com:/db.jswlabs.com
          - /app/config/coredns/db.192.168:/db.192.168
  
